#ifndef LIB_TRANSFORMS_FHEKERNELFUSION_FUSIONSCHEDULER_H_
#define LIB_TRANSFORMS_FHEKERNELFUSION_FUSIONSCHEDULER_H_

#include "lib/Transforms/FHEKernelFusion/FHEKernelFusion.h"

namespace mlir::heir {

LogicalResult collectVerticalCandidates(const FusionGraph& graph,
                                        FusionPolicy& policy,
                                        llvm::SmallVectorImpl<FusionCandidate>& out);

LogicalResult collectHorizontalCandidates(const FusionGraph& graph,
                                          FusionPolicy& policy,
                                          llvm::SmallVectorImpl<FusionCandidate>& out);

LogicalResult applyFusionCandidate(FusionGraph& graph, FusionPolicy& policy,
                                   const FusionCandidate& cand,
                                   RewriterBase& rewriter);

}  // namespace mlir::heir

#endif