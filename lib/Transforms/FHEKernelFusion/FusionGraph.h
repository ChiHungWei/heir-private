#ifndef LIB_TRANSFORMS_FHEKERNELFUSION_FUSIONGRAPH_H_
#define LIB_TRANSFORMS_FHEKERNELFUSION_FUSIONGRAPH_H_

#include "lib/Transforms/FHEKernelFusion/FHEKernelFusion.h"

namespace mlir::heir {

LogicalResult buildFusionGraph(Operation* root, FusionPolicy& policy,
                               FusionGraph& graph);

}  // namespace mlir::heir

#endif