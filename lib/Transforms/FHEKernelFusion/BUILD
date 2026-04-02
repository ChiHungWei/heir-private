load("@rules_cc//cc:cc_library.bzl", "cc_library")

package(
    default_applicable_licenses = ["@heir//:license"],
    default_visibility = ["//visibility:public"],
)

cc_library(
    name = "FHEKernelFusion",
    srcs = [
        "FusionGraph.cpp",
        "FusionScheduler.cpp",
    ],
    hdrs = [
        "FHEKernelFusion.h",
        "FusionGraph.h",
        "FusionScheduler.h",
    ],
    deps = [
        "@llvm-project//llvm:Support",
        "@llvm-project//mlir:FuncDialect",
        "@llvm-project//mlir:IR",
        "@llvm-project//mlir:Pass",
        "@llvm-project//mlir:Support",
        "@llvm-project//mlir:Transforms",
    ],
)