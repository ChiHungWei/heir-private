#include "lib/Transforms/FHEKernelFusion/FusionGraph.h"


#include <queue>

#include "llvm/include/llvm/ADT/STLExtras.h"
#include "mlir/include/mlir/Dialect/Func/IR/FuncOps.h"

namespace mlir::heir {
namespace {

static bool isTopLevelCandidateOp(Operation* op) {
  // Skip module / func container ops. Keep this conservative at first.
  return !isa<ModuleOp, func::FuncOp>(op);
}

static void collectInputValues(Operation* op, llvm::SmallVectorImpl<Value>& out) {
  for (Value v : op->getOperands()) out.push_back(v);
}

static void collectOutputValues(Operation* op,
                                llvm::SmallVectorImpl<Value>& out) {
  for (Value v : op->getResults()) out.push_back(v);
}

}  // namespace

FusionNode& FusionGraph::addNode(FusionNode node) {
  int id = node.id;
  if (id < 0) id = nextNodeId++;
  node.id = id;
  nextNodeId = std::max(nextNodeId, id + 1);
  auto it = nodes.try_emplace(id, std::move(node));
  return it.first->second;
}

void FusionGraph::addEdge(FusionEdge edge) { edges.push_back(std::move(edge)); }

bool FusionGraph::hasNode(int id) const { return nodes.contains(id); }

FusionNode* FusionGraph::getNode(int id) {
  auto it = nodes.find(id);
  if (it == nodes.end()) return nullptr;
  return &it->second;
}

const FusionNode* FusionGraph::getNode(int id) const {
  auto it = nodes.find(id);
  if (it == nodes.end()) return nullptr;
  return &it->second;
}

bool FusionGraph::hasEdge(int producer, int consumer) const {
  return llvm::any_of(edges, [&](const FusionEdge& e) {
    return e.producer == producer && e.consumer == consumer;
  });
}

llvm::SmallVector<FusionEdge> FusionGraph::outgoingEdges(int producer) const {
  llvm::SmallVector<FusionEdge> out;
  for (const auto& e : edges)
    if (e.producer == producer) out.push_back(e);
  return out;
}

llvm::SmallVector<FusionEdge> FusionGraph::incomingEdges(int consumer) const {
  llvm::SmallVector<FusionEdge> in;
  for (const auto& e : edges)
    if (e.consumer == consumer) in.push_back(e);
  return in;
}

llvm::SmallVector<int> FusionGraph::allNodeIds() const {
  llvm::SmallVector<int> ids;
  for (const auto& [id, _] : nodes) ids.push_back(id);
  llvm::sort(ids);
  return ids;
}

bool FusionGraph::hasPath(int src, int dst) const {
  if (src == dst) return true;
  llvm::DenseSet<int> visited;
  std::queue<int> q;
  q.push(src);
  visited.insert(src);

  while (!q.empty()) {
    int cur = q.front();
    q.pop();
    for (const auto& e : outgoingEdges(cur)) {
      if (e.consumer == dst) return true;
      if (!visited.contains(e.consumer)) {
        visited.insert(e.consumer);
        q.push(e.consumer);
      }
    }
  }
  return false;
}

int FusionGraph::topoDistance(int a, int b) const {
  const auto* na = getNode(a);
  const auto* nb = getNode(b);
  if (!na || !nb) return 1'000'000;
  return std::abs(na->topoIndex - nb->topoIndex);
}

LogicalResult FusionGraph::mergeVertical(int producerId, int consumerId,
                                         int newNodeId) {
  auto* producer = getNode(producerId);
  auto* consumer = getNode(consumerId);
  if (!producer || !consumer) return failure();

  FusionNode merged;
  merged.id = newNodeId;
  merged.kind = FusionNodeKind::Grouped;  // conservative first step
  merged.domain =
      (producer->domain == consumer->domain) ? producer->domain
                                             : FusionDomain::Mixed;

  merged.ops.append(producer->ops.begin(), producer->ops.end());
  merged.ops.append(consumer->ops.begin(), consumer->ops.end());
  merged.topoIndex = std::min(producer->topoIndex, consumer->topoIndex);
  merged.hasSideEffects = producer->hasSideEffects || consumer->hasSideEffects;
  merged.isBarrier = producer->isBarrier || consumer->isBarrier;

  // External inputs = operands not produced inside the merged pair.
  llvm::DenseSet<Value> internalResults;
  for (Value v : producer->outputs) internalResults.insert(v);
  for (Value v : consumer->outputs) internalResults.insert(v);

  auto addExternalInputs = [&](const llvm::SmallVector<Value>& vals) {
    for (Value v : vals) {
      if (!internalResults.contains(v))
        merged.inputs.push_back(v);
    }
  };
  addExternalInputs(producer->inputs);
  addExternalInputs(consumer->inputs);

  // External outputs = outputs that still escape the pair.
  llvm::DenseSet<Operation*> pairOps(producer->ops.begin(), producer->ops.end());
  pairOps.insert(consumer->ops.begin(), consumer->ops.end());

  auto maybeAddEscaping = [&](Value v) {
    bool escapes = false;
    for (Operation* user : v.getUsers()) {
      if (!pairOps.contains(user)) {
        escapes = true;
        break;
      }
    }
    if (escapes) merged.outputs.push_back(v);
  };
  for (Value v : producer->outputs) maybeAddEscaping(v);
  for (Value v : consumer->outputs) maybeAddEscaping(v);

  addNode(std::move(merged));

  // Rebuild local edges conservatively.
  llvm::SmallVector<FusionEdge> newEdges;
  for (const auto& e : edges) {
    int src = e.producer;
    int dst = e.consumer;

    bool srcInside = (src == producerId || src == consumerId);
    bool dstInside = (dst == producerId || dst == consumerId);

    if (srcInside && dstInside) continue;

    if (srcInside) src = newNodeId;
    if (dstInside) dst = newNodeId;
    if (src == dst) continue;

    newEdges.push_back(FusionEdge{
        .producer = src,
        .consumer = dst,
        .carriedValues = e.carriedValues,
        .isDataDep = e.isDataDep,
        .isAntiDep = e.isAntiDep,
        .isOutputDep = e.isOutputDep,
    });
  }

  nodes.erase(producerId);
  nodes.erase(consumerId);
  edges = std::move(newEdges);
  return success();
}

LogicalResult FusionGraph::mergeHorizontal(llvm::ArrayRef<int> nodeIds,
                                           int newNodeId) {
  if (nodeIds.empty()) return failure();
  if (nodeIds.size() == 1) return success();

  FusionNode merged;
  merged.id = newNodeId;
  merged.kind = FusionNodeKind::Grouped;

  auto* first = getNode(nodeIds.front());
  if (!first) return failure();
  merged.domain = first->domain;
  merged.topoIndex = first->topoIndex;

  llvm::DenseSet<int> memberSet(nodeIds.begin(), nodeIds.end());

  for (int id : nodeIds) {
    auto* node = getNode(id);
    if (!node) return failure();
    merged.ops.append(node->ops.begin(), node->ops.end());
    merged.hasSideEffects |= node->hasSideEffects;
    merged.isBarrier |= node->isBarrier;
    merged.topoIndex = std::min(merged.topoIndex, node->topoIndex);
    if (merged.domain != node->domain) merged.domain = FusionDomain::Mixed;
    merged.inputs.append(node->inputs.begin(), node->inputs.end());
    merged.outputs.append(node->outputs.begin(), node->outputs.end());
  }

  addNode(std::move(merged));

  llvm::SmallVector<FusionEdge> newEdges;
  for (const auto& e : edges) {
    int src = e.producer;
    int dst = e.consumer;
    bool srcInside = memberSet.contains(src);
    bool dstInside = memberSet.contains(dst);

    if (srcInside && dstInside) continue;
    if (srcInside) src = newNodeId;
    if (dstInside) dst = newNodeId;
    if (src == dst) continue;

    newEdges.push_back(FusionEdge{
        .producer = src,
        .consumer = dst,
        .carriedValues = e.carriedValues,
        .isDataDep = e.isDataDep,
        .isAntiDep = e.isAntiDep,
        .isOutputDep = e.isOutputDep,
    });
  }

  for (int id : nodeIds) nodes.erase(id);
  edges = std::move(newEdges);
  return success();
}

LogicalResult buildFusionGraph(Operation* root, FusionPolicy& policy,
                               FusionGraph& graph) {
  llvm::DenseMap<Operation*, int> opToNodeId;
  int topo = 0;

  root->walk([&](Operation* op) {
    if (!isTopLevelCandidateOp(op)) return;

    FusionNode node;
    node.id = graph.nextId();
    node.ops.push_back(op);
    node.kind = policy.classifyKind(op);
    node.domain = policy.classifyDomain(op);
    node.hasSideEffects = policy.hasSideEffects(op);
    node.isBarrier = policy.isBarrier(op);
    node.topoIndex = topo++;

    collectInputValues(op, node.inputs);
    collectOutputValues(op, node.outputs);
    node.inputInfo = policy.analyzeInputs(op);
    node.outputInfo = policy.analyzeOutputs(op);

    graph.addNode(std::move(node));
    opToNodeId[op] = node.id;
  });

  for (auto [op, consumerId] : opToNodeId) {
    for (Value operand : op->getOperands()) {
      Operation* def = operand.getDefiningOp();
      if (!def) continue;
      auto it = opToNodeId.find(def);
      if (it == opToNodeId.end()) continue;

      int producerId = it->second;
      graph.addEdge(FusionEdge{
          .producer = producerId,
          .consumer = consumerId,
          .carriedValues = {operand},
          .isDataDep = true,
          .isAntiDep = false,
          .isOutputDep = false,
      });

      if (auto* producer = graph.getNode(producerId))
        producer->succs.insert(consumerId);
      if (auto* consumer = graph.getNode(consumerId))
        consumer->preds.insert(producerId);
    }
  }

  return success();
}

}  // namespace mlir::heir