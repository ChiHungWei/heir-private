#ifndef LIB_DIALECT_POLYNOMIAL_TRANSFORMS_KERNELFUSION_H_
#define LIB_DIALECT_POLYNOMIAL_TRANSFORMS_KERNELFUSION_H_

#include <memory>

namespace mlir {
class Pass;
}

namespace mlir::heir::polynomial {

std::unique_ptr<Pass> createKernelFusion();
void registerPolynomialKernelFusionPass();

}  // namespace mlir::heir::polynomial

#endif  // LIB_DIALECT_POLYNOMIAL_TRANSFORMS_KERNELFUSION_H_