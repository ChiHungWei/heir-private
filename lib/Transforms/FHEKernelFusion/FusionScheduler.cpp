#include "lib/Transforms/FHEKernelFusion/FusionScheduler.h"
#include "lib/Transforms/FHEKernelFusion/FusionGraph.h"

#include "llvm/include/llvm/ADT/STLExtras.h"

namespace mlir::heir {
namespace {

static bool schedulerCanFuseVertical(const FusionNode& producer,
                                     const FusionNode& consumer,
                                     const FusionGraph& graph) {
  if (producer.isBarrier || consumer.isBarrier) return false;
  if (producer.hasSideEffects || consumer.hasSideEffects) return false;
  if (!graph.hasEdge(producer.id, consumer.id)) return false;
  if (graph.hasPath(consumer.id, producer.id)) return false;
  return true;
}

static bool areIndependentSiblings(const FusionNode& a, const FusionNode& b,
                                   const FusionGraph& graph) {
  if (a.id == b.id) return false;
  if (graph.hasPath(a.id, b.id)) return false;
  if (graph.hasPath(b.id, a.id)) return false;
  if (a.domain != b.domain) return false;
  if (a.kind != b.kind) return false;
  if (a.hasSideEffects || b.hasSideEffects) return false;
  if (a.isBarrier || b.isBarrier) return false;
  return true;
}

static bool profitable(const FusionCandidate& cand) {
  // Simple first cut; tighten later.
  return cand.score.categoryPriority > 0 ||
         cand.score.bytesSaved > 0 ||
         cand.score.tempBuffersEliminated > 0 ||
         cand.score.domainTransitionBonus > 0;
}

}  // namespace

LogicalResult collectVerticalCandidates(
    const FusionGraph& graph, FusionPolicy& policy,
    llvm::SmallVectorImpl<FusionCandidate>& out) {
  for (int id : graph.allNodeIds()) {
    const FusionNode* producer = graph.getNode(id);
    if (!producer) continue;

    for (const auto& edge : graph.outgoingEdges(id)) {
      const FusionNode* consumer = graph.getNode(edge.consumer);
      if (!consumer) continue;
      if (!schedulerCanFuseVertical(*producer, *consumer, graph)) continue;

      auto legal = policy.canFuseVertical(*producer, *consumer, graph);
      if (!legal.ok) continue;

      FusionCandidate cand;
      cand.direction = FusionDirection::Vertical;
      cand.nodeIds = {producer->id, consumer->id};
      cand.score = policy.scoreVertical(*producer, *consumer, graph);
      out.push_back(std::move(cand));
    }
  }
  return success();
}

LogicalResult collectHorizontalCandidates(
    const FusionGraph& graph, FusionPolicy& policy,
    llvm::SmallVectorImpl<FusionCandidate>& out) {
  auto ids = graph.allNodeIds();
  for (size_t i = 0; i < ids.size(); ++i) {
    const FusionNode* a = graph.getNode(ids[i]);
    if (!a) continue;

    llvm::SmallVector<const FusionNode*> siblings = {a};
    llvm::SmallVector<int> siblingIds = {a->id};

    for (size_t j = i + 1; j < ids.size(); ++j) {
      const FusionNode* b = graph.getNode(ids[j]);
      if (!b) continue;
      if (!areIndependentSiblings(*a, *b, graph)) continue;
      siblings.push_back(b);
      siblingIds.push_back(b->id);
    }

    if (siblings.size() < 2) continue;
    auto legal = policy.canFuseHorizontal(siblings, graph);
    if (!legal.ok) continue;

    FusionCandidate cand;
    cand.direction = FusionDirection::Horizontal;
    cand.nodeIds = std::move(siblingIds);
    cand.score = policy.scoreHorizontal(siblings, graph);
    out.push_back(std::move(cand));
  }
  return success();
}

LogicalResult applyFusionCandidate(FusionGraph& graph, FusionPolicy& policy,
                                   const FusionCandidate& cand,
                                   RewriterBase& rewriter) {
  if (cand.direction == FusionDirection::Vertical) {
    if (cand.nodeIds.size() != 2) return failure();
    int newId = graph.nextId();
    if (failed(graph.mergeVertical(cand.nodeIds[0], cand.nodeIds[1], newId)))
      return failure();
    if (auto* node = graph.getNode(newId)) policy.annotateNode(*node, rewriter);
    return success();
  }

  if (cand.direction == FusionDirection::Horizontal) {
    if (cand.nodeIds.size() < 2) return failure();
    int newId = graph.nextId();
    if (failed(graph.mergeHorizontal(cand.nodeIds, newId))) return failure();
    if (auto* node = graph.getNode(newId)) policy.annotateNode(*node, rewriter);
    return success();
  }

  return failure();
}

LogicalResult runFusionScheduler(Operation* root, FusionPolicy& policy) {
  FusionGraph graph;
  if (failed(buildFusionGraph(root, policy, graph))) return failure();

  IRRewriter rewriter(root->getContext());

  while (true) {
    llvm::SmallVector<FusionCandidate> candidates;
    if (failed(collectVerticalCandidates(graph, policy, candidates)))
      return failure();
    if (failed(collectHorizontalCandidates(graph, policy, candidates)))
      return failure();

    llvm::erase_if(candidates, [&](const FusionCandidate& c) {
      return !profitable(c);
    });

    llvm::sort(candidates, [](const FusionCandidate& a,
                              const FusionCandidate& b) {
      return b.score < a.score;
    });

    bool changed = false;
    for (const auto& cand : candidates) {
      if (succeeded(applyFusionCandidate(graph, policy, cand, rewriter))) {
        changed = true;
        break;
      }
    }
    if (!changed) break;
  }

  return success();
}

}  // namespace mlir::heir