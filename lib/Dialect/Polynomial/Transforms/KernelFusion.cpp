#include "lib/Dialect/Polynomial/Transforms/KernelFusion.h"

#include <algorithm>
#include <cstdint>
#include <memory>
#include <string>

#include "lib/Dialect/Polynomial/IR/PolynomialOps.h"
#include "lib/Transforms/FHEKernelFusion/FHEKernelFusion.h"
#include "mlir/include/mlir/IR/BuiltinAttributes.h"
#include "mlir/include/mlir/IR/BuiltinOps.h"
#include "mlir/include/mlir/IR/BuiltinTypes.h"
#include "mlir/include/mlir/Pass/Pass.h"

namespace mlir::heir::polynomial {
namespace {

enum class PolynomialVerticalPatternKind {
  NTTMulINTT,
  NTTMul,
  MulINTT,
  ExtractConvertBasis,
  GenericTemplate,
  GenericPointwise,
};

static bool isPolynomialFusionOp(Operation* op) {
  return isa<AddOp, SubOp, MulOp, MulScalarOp, MonicMonomialMulOp,
             ModSwitchOp, NTTOp, INTTOp, ConvertBasisOp, ExtractSliceOp>(op);
}

static TensorDomainInfo analyzeValue(Value v) {
  TensorDomainInfo info;
  info.type = v.getType();

  if (auto shaped = dyn_cast<ShapedType>(v.getType())) {
    if (shaped.hasRank()) {
      for (int64_t dim : shaped.getShape()) info.shape.push_back(dim);
    }
  }

  return info;
}

static int64_t getTypeByteWidth(Type type) {
  if (auto intTy = dyn_cast<IntegerType>(type)) {
    return std::max<int64_t>(1, (intTy.getWidth() + 7) / 8);
  }
  if (auto floatTy = dyn_cast<FloatType>(type)) {
    return std::max<int64_t>(1, (floatTy.getWidth() + 7) / 8);
  }
  return 8;
}

static int64_t estimateValueBytes(Value v) {
  Type type = v.getType();

  if (auto shaped = dyn_cast<ShapedType>(type)) {
    int64_t elems = 1;
    if (shaped.hasRank()) {
      for (int64_t dim : shaped.getShape()) {
        if (ShapedType::isDynamic(dim)) return 64;
        elems *= dim;
      }
    } else {
      return 64;
    }

    Type elemType = shaped.getElementType();
    return std::max<int64_t>(1, elems) * getTypeByteWidth(elemType);
  }

  return 64;
}

template <typename OpTy>
static bool containsOp(const FusionNode& node) {
  for (Operation* op : node.ops) {
    if (isa<OpTy>(op)) return true;
  }
  return false;
}

static bool hasSameRankedShape(Type a, Type b) {
  auto ta = dyn_cast<ShapedType>(a);
  auto tb = dyn_cast<ShapedType>(b);
  if (!ta || !tb) return true;
  if (!ta.hasRank() || !tb.hasRank()) return true;
  if (ta.getRank() != tb.getRank()) return false;

  for (int64_t i = 0; i < ta.getRank(); ++i) {
    int64_t da = ta.getShape()[i];
    int64_t db = tb.getShape()[i];
    if (ShapedType::isDynamic(da) || ShapedType::isDynamic(db)) continue;
    if (da != db) return false;
  }
  return true;
}

static bool outputsFeedConsumer(const FusionNode& producer,
                                const FusionNode& consumer) {
  for (Value out : producer.outputs) {
    for (Operation* user : out.getUsers()) {
      for (Operation* consumerOp : consumer.ops) {
        if (user == consumerOp) return true;
      }
    }
  }
  return false;
}

static bool isOutputInternalizedByConsumer(Value out,
                                           const FusionNode& consumer) {
  bool usedByConsumer = false;
  for (Operation* user : out.getUsers()) {
    bool inside = false;
    for (Operation* consumerOp : consumer.ops) {
      if (user == consumerOp) {
        inside = true;
        usedByConsumer = true;
        break;
      }
    }
    if (!inside) return false;
  }
  return usedByConsumer;
}

static int64_t estimateInternalizedBytes(const FusionNode& producer,
                                         const FusionNode& consumer) {
  int64_t total = 0;
  for (Value out : producer.outputs) {
    if (isOutputInternalizedByConsumer(out, consumer)) {
      total += estimateValueBytes(out);
    }
  }
  return total;
}

static int64_t estimateMemoryTrafficSaved(const FusionNode& producer,
                                          const FusionNode& consumer) {
  return 2 * estimateInternalizedBytes(producer, consumer);
}

static int64_t countInternalizedTemps(const FusionNode& producer,
                                      const FusionNode& consumer) {
  int64_t count = 0;
  for (Value out : producer.outputs) {
    if (isOutputInternalizedByConsumer(out, consumer)) ++count;
  }
  return count;
}

static int64_t estimateCodeGrowthPenalty(const FusionNode& producer,
                                         const FusionNode& consumer) {
  int64_t penalty = 0;
  int64_t opCount = static_cast<int64_t>(producer.ops.size() + consumer.ops.size());

  if (opCount > 4) penalty += (opCount - 4) * 5;
  if (producer.outputs.size() > 1) penalty += 10;
  if (consumer.inputs.size() > 3) penalty += 10;

  return penalty;
}

static std::string nodeSignature(const FusionNode& node) {
  std::string sig;
  for (Operation* op : node.ops) {
    sig.append(op->getName().getStringRef().str());
    sig.push_back(';');
  }
  return sig;
}

static bool sameOutputArity(const FusionNode& a, const FusionNode& b) {
  return a.outputs.size() == b.outputs.size();
}

static bool sameOutputShapes(const FusionNode& a, const FusionNode& b) {
  if (!sameOutputArity(a, b)) return false;
  for (size_t i = 0; i < a.outputs.size(); ++i) {
    if (!hasSameRankedShape(a.outputs[i].getType(), b.outputs[i].getType()))
      return false;
  }
  return true;
}

static int64_t estimateGroupedOutputBytes(
    llvm::ArrayRef<const FusionNode*> siblings) {
  int64_t total = 0;
  for (const FusionNode* node : siblings) {
    for (Value out : node->outputs) total += estimateValueBytes(out);
  }
  return total;
}

static PolynomialVerticalPatternKind classifyVerticalPattern(
    const FusionNode& producer, const FusionNode& consumer) {
  bool hasNTT =
      containsOp<NTTOp>(producer) || containsOp<NTTOp>(consumer);
  bool hasMul =
      containsOp<MulOp>(producer) || containsOp<MulOp>(consumer);
  bool hasINTT =
      containsOp<INTTOp>(producer) || containsOp<INTTOp>(consumer);
  bool hasExtract =
      containsOp<ExtractSliceOp>(producer) || containsOp<ExtractSliceOp>(consumer);
  bool hasConvertBasis =
      containsOp<ConvertBasisOp>(producer) || containsOp<ConvertBasisOp>(consumer);

  if (hasNTT && hasMul && hasINTT)
    return PolynomialVerticalPatternKind::NTTMulINTT;
  if (hasNTT && hasMul)
    return PolynomialVerticalPatternKind::NTTMul;
  if (hasMul && hasINTT)
    return PolynomialVerticalPatternKind::MulINTT;
  if (hasExtract && hasConvertBasis)
    return PolynomialVerticalPatternKind::ExtractConvertBasis;

  if (producer.kind == FusionNodeKind::Template ||
      consumer.kind == FusionNodeKind::Template) {
    return PolynomialVerticalPatternKind::GenericTemplate;
  }

  return PolynomialVerticalPatternKind::GenericPointwise;
}

static std::string choosePatternName(const FusionNode& node) {
  bool hasNTT = containsOp<NTTOp>(node);
  bool hasMul = containsOp<MulOp>(node);
  bool hasINTT = containsOp<INTTOp>(node);
  bool hasExtract = containsOp<ExtractSliceOp>(node);
  bool hasConvertBasis = containsOp<ConvertBasisOp>(node);

  if (hasNTT && hasMul && hasINTT)
    return "polynomial.ntt_mul_intt";
  if (hasNTT && hasMul)
    return "polynomial.ntt_mul";
  if (hasMul && hasINTT)
    return "polynomial.mul_intt";
  if (hasExtract && hasConvertBasis)
    return "polynomial.extract_convert_basis";
  return "polynomial.generic_group";
}

static bool isHorizontalGroupSignatureCompatible(
    llvm::ArrayRef<const FusionNode*> siblings) {
  if (siblings.size() < 2) return false;

  std::string refSig = nodeSignature(*siblings.front());
  for (const FusionNode* node : siblings) {
    if (nodeSignature(*node) != refSig) return false;
  }
  return true;
}

struct PolynomialFusionPolicy : public ::mlir::heir::FusionPolicy {
  FusionNodeKind classifyKind(Operation* op) override {
    if (!isPolynomialFusionOp(op)) return FusionNodeKind::Barrier;

    if (isa<AddOp, SubOp, MulScalarOp, MonicMonomialMulOp>(op))
      return FusionNodeKind::Pointwise;

    if (isa<MulOp, NTTOp, INTTOp, ConvertBasisOp,
            ExtractSliceOp, ModSwitchOp>(op))
      return FusionNodeKind::Template;

    return FusionNodeKind::Unknown;
  }

  FusionDomain classifyDomain(Operation* op) override {
    if (!isPolynomialFusionOp(op)) return FusionDomain::Unknown;
    return FusionDomain::Polynomial;
  }

  bool isBarrier(Operation* op) override {
    return !isPolynomialFusionOp(op);
  }

  bool hasSideEffects(Operation* op) override {
    return !isPolynomialFusionOp(op);
  }

  llvm::SmallVector<TensorDomainInfo> analyzeInputs(Operation* op) override {
    llvm::SmallVector<TensorDomainInfo> out;
    for (Value v : op->getOperands()) out.push_back(analyzeValue(v));
    return out;
  }

  llvm::SmallVector<TensorDomainInfo> analyzeOutputs(Operation* op) override {
    llvm::SmallVector<TensorDomainInfo> out;
    for (Value v : op->getResults()) out.push_back(analyzeValue(v));
    return out;
  }

  FusionLegality canFuseVertical(const FusionNode& producer,
                                 const FusionNode& consumer,
                                 const FusionGraph& graph) override {
    (void)graph;

    if (producer.domain != FusionDomain::Polynomial ||
        consumer.domain != FusionDomain::Polynomial) {
      return {false, "not polynomial"};
    }

    if (!outputsFeedConsumer(producer, consumer))
      return {false, "no producer-consumer flow"};

    if (producer.isBarrier || consumer.isBarrier)
      return {false, "barrier op"};

    if (!producer.outputs.empty() && !consumer.inputs.empty()) {
      if (!hasSameRankedShape(producer.outputs.front().getType(),
                              consumer.inputs.front().getType())) {
        return {false, "shape mismatch"};
      }
    }

    int64_t totalOps =
        static_cast<int64_t>(producer.ops.size() + consumer.ops.size());
    if (totalOps > 8) return {false, "group too large"};

    return {true, ""};
  }

  FusionLegality canFuseHorizontal(
      llvm::ArrayRef<const FusionNode*> siblings,
      const FusionGraph& graph) override {
    (void)graph;

    if (siblings.size() < 2) return {false, "need at least 2 siblings"};

    FusionNodeKind refKind = siblings.front()->kind;
    for (const FusionNode* node : siblings) {
      if (node->domain != FusionDomain::Polynomial)
        return {false, "not polynomial"};
      if (node->isBarrier) return {false, "barrier node"};
      if (node->kind != refKind) return {false, "kind mismatch"};
      if (!sameOutputArity(*node, *siblings.front()))
        return {false, "arity mismatch"};
      if (!sameOutputShapes(*node, *siblings.front()))
        return {false, "shape mismatch"};
    }

    if (!isHorizontalGroupSignatureCompatible(siblings) &&
        siblings.front()->kind != FusionNodeKind::Pointwise) {
      return {false, "signature mismatch"};
    }

    return {true, ""};
  }

  FusionScore scoreVertical(const FusionNode& producer,
                            const FusionNode& consumer,
                            const FusionGraph& graph) override {
    FusionScore s;

    PolynomialVerticalPatternKind pattern =
        classifyVerticalPattern(producer, consumer);

    switch (pattern) {
      case PolynomialVerticalPatternKind::NTTMulINTT:
        s.categoryPriority = 540;
        s.domainTransitionBonus = 240;
        break;
      case PolynomialVerticalPatternKind::NTTMul:
        s.categoryPriority = 520;
        s.domainTransitionBonus = 180;
        break;
      case PolynomialVerticalPatternKind::MulINTT:
        s.categoryPriority = 510;
        s.domainTransitionBonus = 180;
        break;
      case PolynomialVerticalPatternKind::ExtractConvertBasis:
        s.categoryPriority = 380;
        s.domainTransitionBonus = 100;
        break;
      case PolynomialVerticalPatternKind::GenericTemplate:
        s.categoryPriority = 180;
        s.domainTransitionBonus = 30;
        break;
      case PolynomialVerticalPatternKind::GenericPointwise:
      default:
        s.categoryPriority = 120;
        break;
    }

    s.bytesSaved = estimateMemoryTrafficSaved(producer, consumer);
    s.tempBuffersEliminated = countInternalizedTemps(producer, consumer);
    s.graphDistancePenalty = graph.topoDistance(producer.id, consumer.id);
    s.liveRangePenalty =
        std::max<int64_t>(0,
            static_cast<int64_t>(producer.ops.size() + consumer.ops.size()) - 4);
    s.codeSizePenalty = estimateCodeGrowthPenalty(producer, consumer);
    return s;
  }

  FusionScore scoreHorizontal(
      llvm::ArrayRef<const FusionNode*> siblings,
      const FusionGraph& graph) override {
    FusionScore s;

    bool sameSig = isHorizontalGroupSignatureCompatible(siblings);
    bool sameShape = true;
    for (const FusionNode* node : siblings) {
      if (!sameOutputShapes(*node, *siblings.front())) {
        sameShape = false;
        break;
      }
    }

    s.categoryPriority = sameSig ? 260 : 180;
    s.bytesSaved = estimateGroupedOutputBytes(siblings) / 8;

    if (sameSig) s.domainTransitionBonus += 80;
    if (sameShape) s.domainTransitionBonus += 40;
    s.domainTransitionBonus += static_cast<int64_t>(siblings.size()) * 5;

    int minTopo = siblings.front()->topoIndex;
    int maxTopo = siblings.front()->topoIndex;
    int64_t totalOps = 0;
    for (const FusionNode* node : siblings) {
      minTopo = std::min(minTopo, node->topoIndex);
      maxTopo = std::max(maxTopo, node->topoIndex);
      totalOps += static_cast<int64_t>(node->ops.size());
    }

    s.graphDistancePenalty = maxTopo - minTopo;
    s.liveRangePenalty = std::max<int64_t>(0, totalOps - 6);
    s.codeSizePenalty = static_cast<int64_t>(siblings.size()) * 3;
    return s;
  }

  void annotateNode(FusionNode& node, RewriterBase& rewriter) override {
    auto groupAttr = rewriter.getI64IntegerAttr(node.id);
    auto patternAttr = rewriter.getStringAttr(choosePatternName(node));

    for (Operation* op : node.ops) {
      op->setAttr(::mlir::heir::kFusionGroupAttrName, groupAttr);
      op->setAttr(::mlir::heir::kFusionPatternAttrName, patternAttr);
    }
  }
};

class PolynomialKernelFusionPass
    : public PassWrapper<PolynomialKernelFusionPass, OperationPass<ModuleOp>> {
 public:
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(PolynomialKernelFusionPass)

  StringRef getArgument() const final { return "polynomial-kernel-fusion"; }
  StringRef getDescription() const final {
    return "Improved graph-based vertical/horizontal fusion scheduler for polynomial ops";
  }

  void runOnOperation() override {
    PolynomialFusionPolicy policy;
    if (failed(::mlir::heir::runFusionScheduler(getOperation(), policy))) {
      signalPassFailure();
    }
  }
};

}  // namespace

std::unique_ptr<Pass> createKernelFusion() {
  return std::make_unique<PolynomialKernelFusionPass>();
}

void registerPolynomialKernelFusionPass() {
  static PassRegistration<PolynomialKernelFusionPass> reg;
}

}  // namespace mlir::heir::polynomial