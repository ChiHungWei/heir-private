#ifndef LIB_DIALECT_CKKS_TRANSFORMS_KERNELFUSION_H_
#define LIB_DIALECT_CKKS_TRANSFORMS_KERNELFUSION_H_

#include <memory>

namespace mlir {
class Pass;
}

namespace mlir::heir::ckks {

std::unique_ptr<Pass> createKernelFusion();
void registerCKKSKernelFusionPass();

}  // namespace mlir::heir::ckks

#endif  // LIB_DIALECT_CKKS_TRANSFORMS_KERNELFUSION_H_