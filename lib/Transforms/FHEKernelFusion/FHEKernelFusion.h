#ifndef LIB_TRANSFORMS_FHEKERNELFUSION_FHEKERNELFUSION_H_
#define LIB_TRANSFORMS_FHEKERNELFUSION_FHEKERNELFUSION_H_

#include <cstdint>
#include <optional>
#include <string>
#include <tuple>

#include "llvm/include/llvm/ADT/DenseMap.h"
#include "llvm/include/llvm/ADT/DenseSet.h"
#include "llvm/include/llvm/ADT/SmallVector.h"
#include "mlir/include/mlir/IR/Attributes.h"
#include "mlir/include/mlir/IR/BuiltinTypes.h"
#include "mlir/include/mlir/IR/Operation.h"
#include "mlir/include/mlir/IR/PatternMatch.h"

namespace mlir::heir {

inline constexpr const char* kFusionGroupAttrName = "heir.fusion_group";
inline constexpr const char* kFusionPatternAttrName = "heir.fusion_pattern";

enum class FusionNodeKind {
  Pointwise,
  Reduction,
  Template,
  Extern,
  Barrier,
  Grouped,
  Unknown,
};

enum class FusionDomain {
  CKKS,
  Polynomial,
  Mixed,
  Unknown,
};

enum class FusionDirection {
  Vertical,
  Horizontal,
};

struct TensorDomainInfo {
  Type type;
  llvm::SmallVector<int64_t> shape;

  std::optional<int64_t> level;
  std::optional<int64_t> scaleBits;
  bool inNTTDomain = false;

  Attribute ring;
  Attribute basis;
  Attribute layout;
  Attribute keyClass;
  Attribute slotCount;
};

struct FusionScore {
  int categoryPriority = 0;
  int64_t bytesSaved = 0;
  int64_t tempBuffersEliminated = 0;
  int64_t domainTransitionBonus = 0;
  int64_t graphDistancePenalty = 0;
  int64_t liveRangePenalty = 0;
  int64_t codeSizePenalty = 0;

  auto asTuple() const {
    return std::make_tuple(categoryPriority, bytesSaved,
                           tempBuffersEliminated, domainTransitionBonus,
                           -graphDistancePenalty, -liveRangePenalty,
                           -codeSizePenalty);
  }

  bool operator<(const FusionScore& other) const {
    return asTuple() < other.asTuple();
  }
};

struct FusionLegality {
  bool ok = false;
  std::string reason;
};

struct FusionNode {
  int id = -1;
  llvm::SmallVector<Operation*> ops;
  FusionNodeKind kind = FusionNodeKind::Unknown;
  FusionDomain domain = FusionDomain::Unknown;

  llvm::SmallVector<Value> inputs;
  llvm::SmallVector<Value> outputs;

  llvm::SmallVector<TensorDomainInfo> inputInfo;
  llvm::SmallVector<TensorDomainInfo> outputInfo;

  llvm::DenseSet<int> preds;
  llvm::DenseSet<int> succs;

  bool hasSideEffects = false;
  bool isBarrier = false;
  int topoIndex = -1;

  bool isGrouped() const { return kind == FusionNodeKind::Grouped; }
};

struct FusionEdge {
  int producer = -1;
  int consumer = -1;
  llvm::SmallVector<Value> carriedValues;

  bool isDataDep = true;
  bool isAntiDep = false;
  bool isOutputDep = false;
};

struct FusionCandidate {
  FusionDirection direction = FusionDirection::Vertical;
  llvm::SmallVector<int> nodeIds;
  FusionScore score;
};

class FusionGraph {
 public:
  FusionGraph() = default;

  FusionNode& addNode(FusionNode node);
  void addEdge(FusionEdge edge);

  bool hasNode(int id) const;
  FusionNode* getNode(int id);
  const FusionNode* getNode(int id) const;

  bool hasEdge(int producer, int consumer) const;
  llvm::SmallVector<FusionEdge> outgoingEdges(int producer) const;
  llvm::SmallVector<FusionEdge> incomingEdges(int consumer) const;

  bool hasPath(int src, int dst) const;
  int topoDistance(int a, int b) const;

  llvm::SmallVector<int> allNodeIds() const;

  int nextId() const { return nextNodeId; }

  LogicalResult mergeVertical(int producerId, int consumerId, int newNodeId);
  LogicalResult mergeHorizontal(llvm::ArrayRef<int> nodeIds, int newNodeId);

 private:
  int nextNodeId = 0;
  llvm::DenseMap<int, FusionNode> nodes;
  llvm::SmallVector<FusionEdge> edges;
};

class FusionPolicy {
 public:
  virtual ~FusionPolicy() = default;

  virtual FusionNodeKind classifyKind(Operation* op) = 0;
  virtual FusionDomain classifyDomain(Operation* op) = 0;
  virtual bool isBarrier(Operation* op) = 0;
  virtual bool hasSideEffects(Operation* op) = 0;

  virtual llvm::SmallVector<TensorDomainInfo> analyzeInputs(Operation* op) = 0;
  virtual llvm::SmallVector<TensorDomainInfo> analyzeOutputs(Operation* op) = 0;

  virtual FusionLegality canFuseVertical(const FusionNode& producer,
                                         const FusionNode& consumer,
                                         const FusionGraph& graph) = 0;

  virtual FusionLegality canFuseHorizontal(
      llvm::ArrayRef<const FusionNode*> siblings,
      const FusionGraph& graph) = 0;

  virtual FusionScore scoreVertical(const FusionNode& producer,
                                    const FusionNode& consumer,
                                    const FusionGraph& graph) = 0;

  virtual FusionScore scoreHorizontal(
      llvm::ArrayRef<const FusionNode*> siblings,
      const FusionGraph& graph) = 0;

  // Optional: annotate debug attrs after graph merge.
  virtual void annotateNode(FusionNode& node, RewriterBase& rewriter) = 0;
};

LogicalResult runFusionScheduler(Operation* root, FusionPolicy& policy);

}  // namespace mlir::heir

#endif