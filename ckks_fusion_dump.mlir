// -----// IR Dump Before mlir::heir::ckks::(anonymous namespace)::CKKSKernelFusionPass (ckks-kernel-fusion) //----- //
!Z35184370941953_i64 = !mod_arith.int<35184370941953 : i64>
!Z35184371138561_i64 = !mod_arith.int<35184371138561 : i64>
!Z35184372121601_i64 = !mod_arith.int<35184372121601 : i64>
!Z35184372744193_i64 = !mod_arith.int<35184372744193 : i64>
!Z36028797017456641_i64 = !mod_arith.int<36028797017456641 : i64>
#inverse_canonical_encoding = #lwe.inverse_canonical_encoding<scaling_factor = 45>
#inverse_canonical_encoding1 = #lwe.inverse_canonical_encoding<scaling_factor = 90>
#key = #lwe.key<>
#layout = #tensor_ext.layout<"{ [] -> [ct, slot] : ct = 0 and slot = 0 }">
#modulus_chain_L4_C0 = #lwe.modulus_chain<elements = <36028797017456641 : i64, 35184370941953 : i64, 35184372744193 : i64, 35184371138561 : i64, 35184372121601 : i64>, current = 0>
#modulus_chain_L4_C1 = #lwe.modulus_chain<elements = <36028797017456641 : i64, 35184370941953 : i64, 35184372744193 : i64, 35184371138561 : i64, 35184372121601 : i64>, current = 1>
#modulus_chain_L4_C2 = #lwe.modulus_chain<elements = <36028797017456641 : i64, 35184370941953 : i64, 35184372744193 : i64, 35184371138561 : i64, 35184372121601 : i64>, current = 2>
#modulus_chain_L4_C3 = #lwe.modulus_chain<elements = <36028797017456641 : i64, 35184370941953 : i64, 35184372744193 : i64, 35184371138561 : i64, 35184372121601 : i64>, current = 3>
#modulus_chain_L4_C4 = #lwe.modulus_chain<elements = <36028797017456641 : i64, 35184370941953 : i64, 35184372744193 : i64, 35184371138561 : i64, 35184372121601 : i64>, current = 4>
#ring_f64_1_x8 = #polynomial.ring<coefficientType = f64, polynomialModulus = <1 + x**8>>
!rns_L0 = !rns.rns<!Z36028797017456641_i64>
!rns_L1 = !rns.rns<!Z36028797017456641_i64, !Z35184370941953_i64>
!rns_L2 = !rns.rns<!Z36028797017456641_i64, !Z35184370941953_i64, !Z35184372744193_i64>
!rns_L3 = !rns.rns<!Z36028797017456641_i64, !Z35184370941953_i64, !Z35184372744193_i64, !Z35184371138561_i64>
!rns_L4 = !rns.rns<!Z36028797017456641_i64, !Z35184370941953_i64, !Z35184372744193_i64, !Z35184371138561_i64, !Z35184372121601_i64>
#original_type = #tensor_ext.original_type<originalType = i16, layout = #layout>
!pt = !lwe.lwe_plaintext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding>>
#ring_rns_L0_1_x8 = #polynomial.ring<coefficientType = !rns_L0, polynomialModulus = <1 + x**8>>
#ring_rns_L1_1_x8 = #polynomial.ring<coefficientType = !rns_L1, polynomialModulus = <1 + x**8>>
#ring_rns_L2_1_x8 = #polynomial.ring<coefficientType = !rns_L2, polynomialModulus = <1 + x**8>>
#ring_rns_L3_1_x8 = #polynomial.ring<coefficientType = !rns_L3, polynomialModulus = <1 + x**8>>
#ring_rns_L4_1_x8 = #polynomial.ring<coefficientType = !rns_L4, polynomialModulus = <1 + x**8>>
!pkey_L4 = !lwe.lwe_public_key<key = #key, ring = #ring_rns_L4_1_x8>
!skey_L0 = !lwe.lwe_secret_key<key = #key, ring = #ring_rns_L0_1_x8>
#ciphertext_space_L0 = #lwe.ciphertext_space<ring = #ring_rns_L0_1_x8, encryption_type = mix>
#ciphertext_space_L1 = #lwe.ciphertext_space<ring = #ring_rns_L1_1_x8, encryption_type = mix>
#ciphertext_space_L2 = #lwe.ciphertext_space<ring = #ring_rns_L2_1_x8, encryption_type = mix>
#ciphertext_space_L3 = #lwe.ciphertext_space<ring = #ring_rns_L3_1_x8, encryption_type = mix>
#ciphertext_space_L4 = #lwe.ciphertext_space<ring = #ring_rns_L4_1_x8, encryption_type = mix>
#ciphertext_space_L4_D3 = #lwe.ciphertext_space<ring = #ring_rns_L4_1_x8, encryption_type = mix, size = 3>
!ct_L0 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding>, ciphertext_space = #ciphertext_space_L0, key = #key, modulus_chain = #modulus_chain_L4_C0>
!ct_L1 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding>, ciphertext_space = #ciphertext_space_L1, key = #key, modulus_chain = #modulus_chain_L4_C1>
!ct_L1_1 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding1>, ciphertext_space = #ciphertext_space_L1, key = #key, modulus_chain = #modulus_chain_L4_C1>
!ct_L2 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding>, ciphertext_space = #ciphertext_space_L2, key = #key, modulus_chain = #modulus_chain_L4_C2>
!ct_L2_1 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding1>, ciphertext_space = #ciphertext_space_L2, key = #key, modulus_chain = #modulus_chain_L4_C2>
!ct_L3 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding>, ciphertext_space = #ciphertext_space_L3, key = #key, modulus_chain = #modulus_chain_L4_C3>
!ct_L3_1 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding1>, ciphertext_space = #ciphertext_space_L3, key = #key, modulus_chain = #modulus_chain_L4_C3>
!ct_L4 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding>, ciphertext_space = #ciphertext_space_L4, key = #key, modulus_chain = #modulus_chain_L4_C4>
!ct_L4_1 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding1>, ciphertext_space = #ciphertext_space_L4, key = #key, modulus_chain = #modulus_chain_L4_C4>
!ct_L4_D3 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding1>, ciphertext_space = #ciphertext_space_L4_D3, key = #key, modulus_chain = #modulus_chain_L4_C4>
module attributes {ckks.schemeParam = #ckks.scheme_param<logN = 14, Q = [36028797017456641, 35184370941953, 35184372744193, 35184371138561, 35184372121601], P = [1152921504607338497, 1152921504608747521], logDefaultScale = 45>, scheme.ckks} {
  func.func @dot_product(%arg0: tensor<1x!ct_L4> {tensor_ext.original_type = #tensor_ext.original_type<originalType = tensor<8xi16>, layout = #tensor_ext.layout<"{ [i0] -> [ct, slot] : ct = 0 and (-i0 + slot) mod 8 = 0 and 0 <= i0 <= 7 and 0 <= slot <= 7 }">>}, %arg1: tensor<1x!ct_L4> {tensor_ext.original_type = #tensor_ext.original_type<originalType = tensor<8xi16>, layout = #tensor_ext.layout<"{ [i0] -> [ct, slot] : ct = 0 and (-i0 + slot) mod 8 = 0 and 0 <= i0 <= 7 and 0 <= slot <= 7 }">>}) -> (tensor<1x!ct_L0> {tensor_ext.original_type = #original_type}) {
    %cst = arith.constant dense<[[1, 0, 0, 0, 0, 0, 0, 0]]> : tensor<1x8xi16>
    %cst_0 = arith.constant dense<[[0, 0, 0, 0, 0, 0, 0, 1]]> : tensor<1x8xi16>
    %c1 = arith.constant 1 : index
    %c2 = arith.constant 2 : index
    %c4 = arith.constant 4 : index
    %c7 = arith.constant 7 : index
    %0 = ckks.mul %arg0, %arg1 : (tensor<1x!ct_L4>, tensor<1x!ct_L4>) -> tensor<1x!ct_L4_D3>
    %1 = ckks.relinearize %0 {from_basis = array<i32: 0, 1, 2>, to_basis = array<i32: 0, 1>} : (tensor<1x!ct_L4_D3>) -> tensor<1x!ct_L4_1>
    %2 = ckks.rotate %1 {offset = 4 : index} : tensor<1x!ct_L4_1>
    %3 = ckks.add %1, %2 : (tensor<1x!ct_L4_1>, tensor<1x!ct_L4_1>) -> tensor<1x!ct_L4_1>
    %4 = ckks.rotate %3 {offset = 2 : index} : tensor<1x!ct_L4_1>
    %5 = ckks.add %3, %4 : (tensor<1x!ct_L4_1>, tensor<1x!ct_L4_1>) -> tensor<1x!ct_L4_1>
    %6 = ckks.rotate %5 {offset = 1 : index} : tensor<1x!ct_L4_1>
    %7 = ckks.add %5, %6 : (tensor<1x!ct_L4_1>, tensor<1x!ct_L4_1>) -> tensor<1x!ct_L4_1>
    %8 = ckks.rescale %7 {to_ring = #ring_rns_L3_1_x8} : tensor<1x!ct_L4_1> -> tensor<1x!ct_L3>
    %extracted_slice = tensor.extract_slice %cst_0[0, 0] [1, 8] [1, 1] : tensor<1x8xi16> to tensor<8xi16>
    %pt = lwe.rlwe_encode %extracted_slice {encoding = #inverse_canonical_encoding, ring = #ring_f64_1_x8} : tensor<8xi16> -> !pt
    %from_elements = tensor.from_elements %pt : tensor<1x!pt>
    %9 = ckks.mul_plain %8, %from_elements : (tensor<1x!ct_L3>, tensor<1x!pt>) -> tensor<1x!ct_L3_1>
    %10 = ckks.rescale %9 {to_ring = #ring_rns_L2_1_x8} : tensor<1x!ct_L3_1> -> tensor<1x!ct_L2>
    %extracted_slice_1 = tensor.extract_slice %cst_0[0, 0] [1, 8] [1, 1] : tensor<1x8xi16> to tensor<8xi16>
    %pt_2 = lwe.rlwe_encode %extracted_slice_1 {encoding = #inverse_canonical_encoding, ring = #ring_f64_1_x8} : tensor<8xi16> -> !pt
    %from_elements_3 = tensor.from_elements %pt_2 : tensor<1x!pt>
    %11 = ckks.mul_plain %10, %from_elements_3 : (tensor<1x!ct_L2>, tensor<1x!pt>) -> tensor<1x!ct_L2_1>
    %12 = ckks.rotate %11 {offset = 7 : index} : tensor<1x!ct_L2_1>
    %13 = ckks.rescale %12 {to_ring = #ring_rns_L1_1_x8} : tensor<1x!ct_L2_1> -> tensor<1x!ct_L1>
    %extracted_slice_4 = tensor.extract_slice %cst[0, 0] [1, 8] [1, 1] : tensor<1x8xi16> to tensor<8xi16>
    %pt_5 = lwe.rlwe_encode %extracted_slice_4 {encoding = #inverse_canonical_encoding, ring = #ring_f64_1_x8} : tensor<8xi16> -> !pt
    %from_elements_6 = tensor.from_elements %pt_5 : tensor<1x!pt>
    %14 = ckks.mul_plain %13, %from_elements_6 : (tensor<1x!ct_L1>, tensor<1x!pt>) -> tensor<1x!ct_L1_1>
    %15 = ckks.rescale %14 {to_ring = #ring_rns_L0_1_x8} : tensor<1x!ct_L1_1> -> tensor<1x!ct_L0>
    return %15 : tensor<1x!ct_L0>
  }
  func.func @dot_product__encrypt__arg0(%arg0: tensor<8xi16>, %pk: !pkey_L4) -> tensor<1x!ct_L4> attributes {client.enc_func = {func_name = "dot_product", index = 0 : i64}} {
    %c0 = arith.constant 0 : index
    %cst = arith.constant dense<0> : tensor<1x8xi16>
    %c0_i32 = arith.constant 0 : i32
    %c1_i32 = arith.constant 1 : i32
    %c8_i32 = arith.constant 8 : i32
    %0 = scf.for %arg1 = %c0_i32 to %c8_i32 step %c1_i32 iter_args(%arg2 = %cst) -> (tensor<1x8xi16>)  : i32 {
      %1 = arith.index_cast %arg1 : i32 to index
      %extracted = tensor.extract %arg0[%1] : tensor<8xi16>
      %inserted = tensor.insert %extracted into %arg2[%c0, %1] : tensor<1x8xi16>
      scf.yield %inserted : tensor<1x8xi16>
    }
    %extracted_slice = tensor.extract_slice %0[0, 0] [1, 8] [1, 1] : tensor<1x8xi16> to tensor<8xi16>
    %pt = lwe.rlwe_encode %extracted_slice {encoding = #inverse_canonical_encoding, ring = #ring_f64_1_x8} : tensor<8xi16> -> !pt
    %ct = lwe.rlwe_encrypt %pt, %pk : (!pt, !pkey_L4) -> !ct_L4
    %from_elements = tensor.from_elements %ct : tensor<1x!ct_L4>
    return %from_elements : tensor<1x!ct_L4>
  }
  func.func @dot_product__encrypt__arg1(%arg0: tensor<8xi16>, %pk: !pkey_L4) -> tensor<1x!ct_L4> attributes {client.enc_func = {func_name = "dot_product", index = 1 : i64}} {
    %c0 = arith.constant 0 : index
    %cst = arith.constant dense<0> : tensor<1x8xi16>
    %c0_i32 = arith.constant 0 : i32
    %c1_i32 = arith.constant 1 : i32
    %c8_i32 = arith.constant 8 : i32
    %0 = scf.for %arg1 = %c0_i32 to %c8_i32 step %c1_i32 iter_args(%arg2 = %cst) -> (tensor<1x8xi16>)  : i32 {
      %1 = arith.index_cast %arg1 : i32 to index
      %extracted = tensor.extract %arg0[%1] : tensor<8xi16>
      %inserted = tensor.insert %extracted into %arg2[%c0, %1] : tensor<1x8xi16>
      scf.yield %inserted : tensor<1x8xi16>
    }
    %extracted_slice = tensor.extract_slice %0[0, 0] [1, 8] [1, 1] : tensor<1x8xi16> to tensor<8xi16>
    %pt = lwe.rlwe_encode %extracted_slice {encoding = #inverse_canonical_encoding, ring = #ring_f64_1_x8} : tensor<8xi16> -> !pt
    %ct = lwe.rlwe_encrypt %pt, %pk : (!pt, !pkey_L4) -> !ct_L4
    %from_elements = tensor.from_elements %ct : tensor<1x!ct_L4>
    return %from_elements : tensor<1x!ct_L4>
  }
  func.func @dot_product__decrypt__result0(%arg0: tensor<1x!ct_L0>, %sk: !skey_L0) -> i16 attributes {client.dec_func = {func_name = "dot_product", index = 0 : i64}} {
    %c0 = arith.constant 0 : index
    %c0_0 = arith.constant 0 : index
    %extracted = tensor.extract %arg0[%c0_0] : tensor<1x!ct_L0>
    %pt = lwe.rlwe_decrypt %extracted, %sk : (!ct_L0, !skey_L0) -> !pt
    %0 = lwe.rlwe_decode %pt {encoding = #inverse_canonical_encoding, ring = #ring_f64_1_x8} : !pt -> tensor<1x8xi16>
    %concat = tensor.concat dim(0) %0 : (tensor<1x8xi16>) -> tensor<1x8xi16>
    %extracted_1 = tensor.extract %concat[%c0, %c0] : tensor<1x8xi16>
    return %extracted_1 : i16
  }
}


// -----// IR Dump After mlir::heir::ckks::(anonymous namespace)::CKKSKernelFusionPass (ckks-kernel-fusion) //----- //
!Z35184370941953_i64 = !mod_arith.int<35184370941953 : i64>
!Z35184371138561_i64 = !mod_arith.int<35184371138561 : i64>
!Z35184372121601_i64 = !mod_arith.int<35184372121601 : i64>
!Z35184372744193_i64 = !mod_arith.int<35184372744193 : i64>
!Z36028797017456641_i64 = !mod_arith.int<36028797017456641 : i64>
#inverse_canonical_encoding = #lwe.inverse_canonical_encoding<scaling_factor = 45>
#inverse_canonical_encoding1 = #lwe.inverse_canonical_encoding<scaling_factor = 90>
#key = #lwe.key<>
#layout = #tensor_ext.layout<"{ [] -> [ct, slot] : ct = 0 and slot = 0 }">
#modulus_chain_L4_C0 = #lwe.modulus_chain<elements = <36028797017456641 : i64, 35184370941953 : i64, 35184372744193 : i64, 35184371138561 : i64, 35184372121601 : i64>, current = 0>
#modulus_chain_L4_C1 = #lwe.modulus_chain<elements = <36028797017456641 : i64, 35184370941953 : i64, 35184372744193 : i64, 35184371138561 : i64, 35184372121601 : i64>, current = 1>
#modulus_chain_L4_C2 = #lwe.modulus_chain<elements = <36028797017456641 : i64, 35184370941953 : i64, 35184372744193 : i64, 35184371138561 : i64, 35184372121601 : i64>, current = 2>
#modulus_chain_L4_C3 = #lwe.modulus_chain<elements = <36028797017456641 : i64, 35184370941953 : i64, 35184372744193 : i64, 35184371138561 : i64, 35184372121601 : i64>, current = 3>
#modulus_chain_L4_C4 = #lwe.modulus_chain<elements = <36028797017456641 : i64, 35184370941953 : i64, 35184372744193 : i64, 35184371138561 : i64, 35184372121601 : i64>, current = 4>
#ring_f64_1_x8 = #polynomial.ring<coefficientType = f64, polynomialModulus = <1 + x**8>>
!rns_L0 = !rns.rns<!Z36028797017456641_i64>
!rns_L1 = !rns.rns<!Z36028797017456641_i64, !Z35184370941953_i64>
!rns_L2 = !rns.rns<!Z36028797017456641_i64, !Z35184370941953_i64, !Z35184372744193_i64>
!rns_L3 = !rns.rns<!Z36028797017456641_i64, !Z35184370941953_i64, !Z35184372744193_i64, !Z35184371138561_i64>
!rns_L4 = !rns.rns<!Z36028797017456641_i64, !Z35184370941953_i64, !Z35184372744193_i64, !Z35184371138561_i64, !Z35184372121601_i64>
#original_type = #tensor_ext.original_type<originalType = i16, layout = #layout>
!pt = !lwe.lwe_plaintext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding>>
#ring_rns_L0_1_x8 = #polynomial.ring<coefficientType = !rns_L0, polynomialModulus = <1 + x**8>>
#ring_rns_L1_1_x8 = #polynomial.ring<coefficientType = !rns_L1, polynomialModulus = <1 + x**8>>
#ring_rns_L2_1_x8 = #polynomial.ring<coefficientType = !rns_L2, polynomialModulus = <1 + x**8>>
#ring_rns_L3_1_x8 = #polynomial.ring<coefficientType = !rns_L3, polynomialModulus = <1 + x**8>>
#ring_rns_L4_1_x8 = #polynomial.ring<coefficientType = !rns_L4, polynomialModulus = <1 + x**8>>
!pkey_L4 = !lwe.lwe_public_key<key = #key, ring = #ring_rns_L4_1_x8>
!skey_L0 = !lwe.lwe_secret_key<key = #key, ring = #ring_rns_L0_1_x8>
#ciphertext_space_L0 = #lwe.ciphertext_space<ring = #ring_rns_L0_1_x8, encryption_type = mix>
#ciphertext_space_L1 = #lwe.ciphertext_space<ring = #ring_rns_L1_1_x8, encryption_type = mix>
#ciphertext_space_L2 = #lwe.ciphertext_space<ring = #ring_rns_L2_1_x8, encryption_type = mix>
#ciphertext_space_L3 = #lwe.ciphertext_space<ring = #ring_rns_L3_1_x8, encryption_type = mix>
#ciphertext_space_L4 = #lwe.ciphertext_space<ring = #ring_rns_L4_1_x8, encryption_type = mix>
#ciphertext_space_L4_D3 = #lwe.ciphertext_space<ring = #ring_rns_L4_1_x8, encryption_type = mix, size = 3>
!ct_L0 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding>, ciphertext_space = #ciphertext_space_L0, key = #key, modulus_chain = #modulus_chain_L4_C0>
!ct_L1 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding>, ciphertext_space = #ciphertext_space_L1, key = #key, modulus_chain = #modulus_chain_L4_C1>
!ct_L1_1 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding1>, ciphertext_space = #ciphertext_space_L1, key = #key, modulus_chain = #modulus_chain_L4_C1>
!ct_L2 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding>, ciphertext_space = #ciphertext_space_L2, key = #key, modulus_chain = #modulus_chain_L4_C2>
!ct_L2_1 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding1>, ciphertext_space = #ciphertext_space_L2, key = #key, modulus_chain = #modulus_chain_L4_C2>
!ct_L3 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding>, ciphertext_space = #ciphertext_space_L3, key = #key, modulus_chain = #modulus_chain_L4_C3>
!ct_L3_1 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding1>, ciphertext_space = #ciphertext_space_L3, key = #key, modulus_chain = #modulus_chain_L4_C3>
!ct_L4 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding>, ciphertext_space = #ciphertext_space_L4, key = #key, modulus_chain = #modulus_chain_L4_C4>
!ct_L4_1 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding1>, ciphertext_space = #ciphertext_space_L4, key = #key, modulus_chain = #modulus_chain_L4_C4>
!ct_L4_D3 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding1>, ciphertext_space = #ciphertext_space_L4_D3, key = #key, modulus_chain = #modulus_chain_L4_C4>
module attributes {ckks.schemeParam = #ckks.scheme_param<logN = 14, Q = [36028797017456641, 35184370941953, 35184372744193, 35184371138561, 35184372121601], P = [1152921504607338497, 1152921504608747521], logDefaultScale = 45>, scheme.ckks} {
  func.func @dot_product(%arg0: tensor<1x!ct_L4> {tensor_ext.original_type = #tensor_ext.original_type<originalType = tensor<8xi16>, layout = #tensor_ext.layout<"{ [i0] -> [ct, slot] : ct = 0 and (-i0 + slot) mod 8 = 0 and 0 <= i0 <= 7 and 0 <= slot <= 7 }">>}, %arg1: tensor<1x!ct_L4> {tensor_ext.original_type = #tensor_ext.original_type<originalType = tensor<8xi16>, layout = #tensor_ext.layout<"{ [i0] -> [ct, slot] : ct = 0 and (-i0 + slot) mod 8 = 0 and 0 <= i0 <= 7 and 0 <= slot <= 7 }">>}) -> (tensor<1x!ct_L0> {tensor_ext.original_type = #original_type}) {
    %cst = arith.constant dense<[[1, 0, 0, 0, 0, 0, 0, 0]]> : tensor<1x8xi16>
    %cst_0 = arith.constant dense<[[0, 0, 0, 0, 0, 0, 0, 1]]> : tensor<1x8xi16>
    %c1 = arith.constant 1 : index
    %c2 = arith.constant 2 : index
    %c4 = arith.constant 4 : index
    %c7 = arith.constant 7 : index
    %0 = ckks.mul %arg0, %arg1 {heir.fusion_group = 0 : i64, heir.fusion_pattern = "ckks.mul_relinearize"} : (tensor<1x!ct_L4>, tensor<1x!ct_L4>) -> tensor<1x!ct_L4_D3>
    %1 = ckks.relinearize %0 {from_basis = array<i32: 0, 1, 2>, heir.fusion_group = 0 : i64, heir.fusion_pattern = "ckks.mul_relinearize", to_basis = array<i32: 0, 1>} : (tensor<1x!ct_L4_D3>) -> tensor<1x!ct_L4_1>
    %2 = ckks.rotate %1 {heir.fusion_group = 1 : i64, heir.fusion_pattern = "ckks.rotate_add", offset = 4 : index} : tensor<1x!ct_L4_1>
    %3 = ckks.add %1, %2 {heir.fusion_group = 1 : i64, heir.fusion_pattern = "ckks.rotate_add"} : (tensor<1x!ct_L4_1>, tensor<1x!ct_L4_1>) -> tensor<1x!ct_L4_1>
    %4 = ckks.rotate %3 {heir.fusion_group = 2 : i64, heir.fusion_pattern = "ckks.rotate_add", offset = 2 : index} : tensor<1x!ct_L4_1>
    %5 = ckks.add %3, %4 {heir.fusion_group = 2 : i64, heir.fusion_pattern = "ckks.rotate_add"} : (tensor<1x!ct_L4_1>, tensor<1x!ct_L4_1>) -> tensor<1x!ct_L4_1>
    %6 = ckks.rotate %5 {heir.fusion_group = 3 : i64, heir.fusion_pattern = "ckks.rotate_add", offset = 1 : index} : tensor<1x!ct_L4_1>
    %7 = ckks.add %5, %6 {heir.fusion_group = 3 : i64, heir.fusion_pattern = "ckks.generic_chain"} : (tensor<1x!ct_L4_1>, tensor<1x!ct_L4_1>) -> tensor<1x!ct_L4_1>
    %8 = ckks.rescale %7 {heir.fusion_group = 3 : i64, heir.fusion_pattern = "ckks.generic_chain", to_ring = #ring_rns_L3_1_x8} : tensor<1x!ct_L4_1> -> tensor<1x!ct_L3>
    %extracted_slice = tensor.extract_slice %cst_0[0, 0] [1, 8] [1, 1] : tensor<1x8xi16> to tensor<8xi16>
    %pt = lwe.rlwe_encode %extracted_slice {encoding = #inverse_canonical_encoding, ring = #ring_f64_1_x8} : tensor<8xi16> -> !pt
    %from_elements = tensor.from_elements %pt : tensor<1x!pt>
    %9 = ckks.mul_plain %8, %from_elements {heir.fusion_group = 4 : i64, heir.fusion_pattern = "ckks.generic_chain"} : (tensor<1x!ct_L3>, tensor<1x!pt>) -> tensor<1x!ct_L3_1>
    %10 = ckks.rescale %9 {heir.fusion_group = 4 : i64, heir.fusion_pattern = "ckks.generic_chain", to_ring = #ring_rns_L2_1_x8} : tensor<1x!ct_L3_1> -> tensor<1x!ct_L2>
    %extracted_slice_1 = tensor.extract_slice %cst_0[0, 0] [1, 8] [1, 1] : tensor<1x8xi16> to tensor<8xi16>
    %pt_2 = lwe.rlwe_encode %extracted_slice_1 {encoding = #inverse_canonical_encoding, ring = #ring_f64_1_x8} : tensor<8xi16> -> !pt
    %from_elements_3 = tensor.from_elements %pt_2 : tensor<1x!pt>
    %11 = ckks.mul_plain %10, %from_elements_3 {heir.fusion_group = 5 : i64, heir.fusion_pattern = "ckks.generic_chain"} : (tensor<1x!ct_L2>, tensor<1x!pt>) -> tensor<1x!ct_L2_1>
    %12 = ckks.rotate %11 {heir.fusion_group = 5 : i64, heir.fusion_pattern = "ckks.generic_chain", offset = 7 : index} : tensor<1x!ct_L2_1>
    %13 = ckks.rescale %12 {to_ring = #ring_rns_L1_1_x8} : tensor<1x!ct_L2_1> -> tensor<1x!ct_L1>
    %extracted_slice_4 = tensor.extract_slice %cst[0, 0] [1, 8] [1, 1] : tensor<1x8xi16> to tensor<8xi16>
    %pt_5 = lwe.rlwe_encode %extracted_slice_4 {encoding = #inverse_canonical_encoding, ring = #ring_f64_1_x8} : tensor<8xi16> -> !pt
    %from_elements_6 = tensor.from_elements %pt_5 : tensor<1x!pt>
    %14 = ckks.mul_plain %13, %from_elements_6 {heir.fusion_group = 6 : i64, heir.fusion_pattern = "ckks.generic_chain"} : (tensor<1x!ct_L1>, tensor<1x!pt>) -> tensor<1x!ct_L1_1>
    %15 = ckks.rescale %14 {heir.fusion_group = 6 : i64, heir.fusion_pattern = "ckks.generic_chain", to_ring = #ring_rns_L0_1_x8} : tensor<1x!ct_L1_1> -> tensor<1x!ct_L0>
    return %15 : tensor<1x!ct_L0>
  }
  func.func @dot_product__encrypt__arg0(%arg0: tensor<8xi16>, %pk: !pkey_L4) -> tensor<1x!ct_L4> attributes {client.enc_func = {func_name = "dot_product", index = 0 : i64}} {
    %c0 = arith.constant 0 : index
    %cst = arith.constant dense<0> : tensor<1x8xi16>
    %c0_i32 = arith.constant 0 : i32
    %c1_i32 = arith.constant 1 : i32
    %c8_i32 = arith.constant 8 : i32
    %0 = scf.for %arg1 = %c0_i32 to %c8_i32 step %c1_i32 iter_args(%arg2 = %cst) -> (tensor<1x8xi16>)  : i32 {
      %1 = arith.index_cast %arg1 : i32 to index
      %extracted = tensor.extract %arg0[%1] : tensor<8xi16>
      %inserted = tensor.insert %extracted into %arg2[%c0, %1] : tensor<1x8xi16>
      scf.yield %inserted : tensor<1x8xi16>
    }
    %extracted_slice = tensor.extract_slice %0[0, 0] [1, 8] [1, 1] : tensor<1x8xi16> to tensor<8xi16>
    %pt = lwe.rlwe_encode %extracted_slice {encoding = #inverse_canonical_encoding, ring = #ring_f64_1_x8} : tensor<8xi16> -> !pt
    %ct = lwe.rlwe_encrypt %pt, %pk : (!pt, !pkey_L4) -> !ct_L4
    %from_elements = tensor.from_elements %ct : tensor<1x!ct_L4>
    return %from_elements : tensor<1x!ct_L4>
  }
  func.func @dot_product__encrypt__arg1(%arg0: tensor<8xi16>, %pk: !pkey_L4) -> tensor<1x!ct_L4> attributes {client.enc_func = {func_name = "dot_product", index = 1 : i64}} {
    %c0 = arith.constant 0 : index
    %cst = arith.constant dense<0> : tensor<1x8xi16>
    %c0_i32 = arith.constant 0 : i32
    %c1_i32 = arith.constant 1 : i32
    %c8_i32 = arith.constant 8 : i32
    %0 = scf.for %arg1 = %c0_i32 to %c8_i32 step %c1_i32 iter_args(%arg2 = %cst) -> (tensor<1x8xi16>)  : i32 {
      %1 = arith.index_cast %arg1 : i32 to index
      %extracted = tensor.extract %arg0[%1] : tensor<8xi16>
      %inserted = tensor.insert %extracted into %arg2[%c0, %1] : tensor<1x8xi16>
      scf.yield %inserted : tensor<1x8xi16>
    }
    %extracted_slice = tensor.extract_slice %0[0, 0] [1, 8] [1, 1] : tensor<1x8xi16> to tensor<8xi16>
    %pt = lwe.rlwe_encode %extracted_slice {encoding = #inverse_canonical_encoding, ring = #ring_f64_1_x8} : tensor<8xi16> -> !pt
    %ct = lwe.rlwe_encrypt %pt, %pk : (!pt, !pkey_L4) -> !ct_L4
    %from_elements = tensor.from_elements %ct : tensor<1x!ct_L4>
    return %from_elements : tensor<1x!ct_L4>
  }
  func.func @dot_product__decrypt__result0(%arg0: tensor<1x!ct_L0>, %sk: !skey_L0) -> i16 attributes {client.dec_func = {func_name = "dot_product", index = 0 : i64}} {
    %c0 = arith.constant 0 : index
    %c0_0 = arith.constant 0 : index
    %extracted = tensor.extract %arg0[%c0_0] : tensor<1x!ct_L0>
    %pt = lwe.rlwe_decrypt %extracted, %sk : (!ct_L0, !skey_L0) -> !pt
    %0 = lwe.rlwe_decode %pt {encoding = #inverse_canonical_encoding, ring = #ring_f64_1_x8} : !pt -> tensor<1x8xi16>
    %concat = tensor.concat dim(0) %0 : (tensor<1x8xi16>) -> tensor<1x8xi16>
    %extracted_1 = tensor.extract %concat[%c0, %c0] : tensor<1x8xi16>
    return %extracted_1 : i16
  }
}


!Z35184370941953_i64 = !mod_arith.int<35184370941953 : i64>
!Z35184371138561_i64 = !mod_arith.int<35184371138561 : i64>
!Z35184372121601_i64 = !mod_arith.int<35184372121601 : i64>
!Z35184372744193_i64 = !mod_arith.int<35184372744193 : i64>
!Z36028797017456641_i64 = !mod_arith.int<36028797017456641 : i64>
#inverse_canonical_encoding = #lwe.inverse_canonical_encoding<scaling_factor = 45>
#inverse_canonical_encoding1 = #lwe.inverse_canonical_encoding<scaling_factor = 90>
#key = #lwe.key<>
#layout = #tensor_ext.layout<"{ [] -> [ct, slot] : ct = 0 and slot = 0 }">
#modulus_chain_L4_C0 = #lwe.modulus_chain<elements = <36028797017456641 : i64, 35184370941953 : i64, 35184372744193 : i64, 35184371138561 : i64, 35184372121601 : i64>, current = 0>
#modulus_chain_L4_C1 = #lwe.modulus_chain<elements = <36028797017456641 : i64, 35184370941953 : i64, 35184372744193 : i64, 35184371138561 : i64, 35184372121601 : i64>, current = 1>
#modulus_chain_L4_C2 = #lwe.modulus_chain<elements = <36028797017456641 : i64, 35184370941953 : i64, 35184372744193 : i64, 35184371138561 : i64, 35184372121601 : i64>, current = 2>
#modulus_chain_L4_C3 = #lwe.modulus_chain<elements = <36028797017456641 : i64, 35184370941953 : i64, 35184372744193 : i64, 35184371138561 : i64, 35184372121601 : i64>, current = 3>
#modulus_chain_L4_C4 = #lwe.modulus_chain<elements = <36028797017456641 : i64, 35184370941953 : i64, 35184372744193 : i64, 35184371138561 : i64, 35184372121601 : i64>, current = 4>
#ring_f64_1_x8 = #polynomial.ring<coefficientType = f64, polynomialModulus = <1 + x**8>>
!rns_L0 = !rns.rns<!Z36028797017456641_i64>
!rns_L1 = !rns.rns<!Z36028797017456641_i64, !Z35184370941953_i64>
!rns_L2 = !rns.rns<!Z36028797017456641_i64, !Z35184370941953_i64, !Z35184372744193_i64>
!rns_L3 = !rns.rns<!Z36028797017456641_i64, !Z35184370941953_i64, !Z35184372744193_i64, !Z35184371138561_i64>
!rns_L4 = !rns.rns<!Z36028797017456641_i64, !Z35184370941953_i64, !Z35184372744193_i64, !Z35184371138561_i64, !Z35184372121601_i64>
#original_type = #tensor_ext.original_type<originalType = i16, layout = #layout>
!pt = !lwe.lwe_plaintext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding>>
#ring_rns_L0_1_x8 = #polynomial.ring<coefficientType = !rns_L0, polynomialModulus = <1 + x**8>>
#ring_rns_L1_1_x8 = #polynomial.ring<coefficientType = !rns_L1, polynomialModulus = <1 + x**8>>
#ring_rns_L2_1_x8 = #polynomial.ring<coefficientType = !rns_L2, polynomialModulus = <1 + x**8>>
#ring_rns_L3_1_x8 = #polynomial.ring<coefficientType = !rns_L3, polynomialModulus = <1 + x**8>>
#ring_rns_L4_1_x8 = #polynomial.ring<coefficientType = !rns_L4, polynomialModulus = <1 + x**8>>
!pkey_L4 = !lwe.lwe_public_key<key = #key, ring = #ring_rns_L4_1_x8>
!skey_L0 = !lwe.lwe_secret_key<key = #key, ring = #ring_rns_L0_1_x8>
#ciphertext_space_L0 = #lwe.ciphertext_space<ring = #ring_rns_L0_1_x8, encryption_type = mix>
#ciphertext_space_L1 = #lwe.ciphertext_space<ring = #ring_rns_L1_1_x8, encryption_type = mix>
#ciphertext_space_L2 = #lwe.ciphertext_space<ring = #ring_rns_L2_1_x8, encryption_type = mix>
#ciphertext_space_L3 = #lwe.ciphertext_space<ring = #ring_rns_L3_1_x8, encryption_type = mix>
#ciphertext_space_L4 = #lwe.ciphertext_space<ring = #ring_rns_L4_1_x8, encryption_type = mix>
#ciphertext_space_L4_D3 = #lwe.ciphertext_space<ring = #ring_rns_L4_1_x8, encryption_type = mix, size = 3>
!ct_L0 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding>, ciphertext_space = #ciphertext_space_L0, key = #key, modulus_chain = #modulus_chain_L4_C0>
!ct_L1 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding>, ciphertext_space = #ciphertext_space_L1, key = #key, modulus_chain = #modulus_chain_L4_C1>
!ct_L1_1 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding1>, ciphertext_space = #ciphertext_space_L1, key = #key, modulus_chain = #modulus_chain_L4_C1>
!ct_L2 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding>, ciphertext_space = #ciphertext_space_L2, key = #key, modulus_chain = #modulus_chain_L4_C2>
!ct_L2_1 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding1>, ciphertext_space = #ciphertext_space_L2, key = #key, modulus_chain = #modulus_chain_L4_C2>
!ct_L3 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding>, ciphertext_space = #ciphertext_space_L3, key = #key, modulus_chain = #modulus_chain_L4_C3>
!ct_L3_1 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding1>, ciphertext_space = #ciphertext_space_L3, key = #key, modulus_chain = #modulus_chain_L4_C3>
!ct_L4 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding>, ciphertext_space = #ciphertext_space_L4, key = #key, modulus_chain = #modulus_chain_L4_C4>
!ct_L4_1 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding1>, ciphertext_space = #ciphertext_space_L4, key = #key, modulus_chain = #modulus_chain_L4_C4>
!ct_L4_D3 = !lwe.lwe_ciphertext<plaintext_space = <ring = #ring_f64_1_x8, encoding = #inverse_canonical_encoding1>, ciphertext_space = #ciphertext_space_L4_D3, key = #key, modulus_chain = #modulus_chain_L4_C4>
module attributes {ckks.schemeParam = #ckks.scheme_param<logN = 14, Q = [36028797017456641, 35184370941953, 35184372744193, 35184371138561, 35184372121601], P = [1152921504607338497, 1152921504608747521], logDefaultScale = 45>, scheme.ckks} {
  func.func @dot_product(%arg0: tensor<1x!ct_L4> {tensor_ext.original_type = #tensor_ext.original_type<originalType = tensor<8xi16>, layout = #tensor_ext.layout<"{ [i0] -> [ct, slot] : ct = 0 and (-i0 + slot) mod 8 = 0 and 0 <= i0 <= 7 and 0 <= slot <= 7 }">>}, %arg1: tensor<1x!ct_L4> {tensor_ext.original_type = #tensor_ext.original_type<originalType = tensor<8xi16>, layout = #tensor_ext.layout<"{ [i0] -> [ct, slot] : ct = 0 and (-i0 + slot) mod 8 = 0 and 0 <= i0 <= 7 and 0 <= slot <= 7 }">>}) -> (tensor<1x!ct_L0> {tensor_ext.original_type = #original_type}) {
    %c0 = arith.constant 0 : index
    %cst = arith.constant dense<[[1, 0, 0, 0, 0, 0, 0, 0]]> : tensor<1x8xi16>
    %cst_0 = arith.constant dense<[[0, 0, 0, 0, 0, 0, 0, 1]]> : tensor<1x8xi16>
    %extracted = tensor.extract %arg0[%c0] : tensor<1x!ct_L4>
    %extracted_1 = tensor.extract %arg1[%c0] : tensor<1x!ct_L4>
    %ct = ckks.mul %extracted, %extracted_1 {heir.fusion_group = 0 : i64, heir.fusion_pattern = "ckks.mul_relinearize"} : (!ct_L4, !ct_L4) -> !ct_L4_D3
    %ct_2 = ckks.relinearize %ct {from_basis = array<i32: 0, 1, 2>, heir.fusion_group = 0 : i64, heir.fusion_pattern = "ckks.mul_relinearize", to_basis = array<i32: 0, 1>} : (!ct_L4_D3) -> !ct_L4_1
    %ct_3 = ckks.rotate %ct_2 {heir.fusion_group = 1 : i64, heir.fusion_pattern = "ckks.rotate_add", offset = 4 : index} : !ct_L4_1
    %ct_4 = ckks.add %ct_2, %ct_3 {heir.fusion_group = 1 : i64, heir.fusion_pattern = "ckks.rotate_add"} : (!ct_L4_1, !ct_L4_1) -> !ct_L4_1
    %ct_5 = ckks.rotate %ct_4 {heir.fusion_group = 2 : i64, heir.fusion_pattern = "ckks.rotate_add", offset = 2 : index} : !ct_L4_1
    %ct_6 = ckks.add %ct_4, %ct_5 {heir.fusion_group = 2 : i64, heir.fusion_pattern = "ckks.rotate_add"} : (!ct_L4_1, !ct_L4_1) -> !ct_L4_1
    %ct_7 = ckks.rotate %ct_6 {heir.fusion_group = 3 : i64, heir.fusion_pattern = "ckks.rotate_add", offset = 1 : index} : !ct_L4_1
    %ct_8 = ckks.add %ct_6, %ct_7 {heir.fusion_group = 3 : i64, heir.fusion_pattern = "ckks.generic_chain"} : (!ct_L4_1, !ct_L4_1) -> !ct_L4_1
    %ct_9 = ckks.rescale %ct_8 {heir.fusion_group = 3 : i64, heir.fusion_pattern = "ckks.generic_chain", to_ring = #ring_rns_L3_1_x8} : !ct_L4_1 -> !ct_L3
    %extracted_slice = tensor.extract_slice %cst_0[0, 0] [1, 8] [1, 1] : tensor<1x8xi16> to tensor<8xi16>
    %pt = lwe.rlwe_encode %extracted_slice {encoding = #inverse_canonical_encoding, ring = #ring_f64_1_x8} : tensor<8xi16> -> !pt
    %ct_10 = ckks.mul_plain %ct_9, %pt {heir.fusion_group = 4 : i64, heir.fusion_pattern = "ckks.generic_chain"} : (!ct_L3, !pt) -> !ct_L3_1
    %ct_11 = ckks.rescale %ct_10 {heir.fusion_group = 4 : i64, heir.fusion_pattern = "ckks.generic_chain", to_ring = #ring_rns_L2_1_x8} : !ct_L3_1 -> !ct_L2
    %ct_12 = ckks.mul_plain %ct_11, %pt {heir.fusion_group = 5 : i64, heir.fusion_pattern = "ckks.generic_chain"} : (!ct_L2, !pt) -> !ct_L2_1
    %ct_13 = ckks.rotate %ct_12 {heir.fusion_group = 5 : i64, heir.fusion_pattern = "ckks.generic_chain", offset = 7 : index} : !ct_L2_1
    %ct_14 = ckks.rescale %ct_13 {to_ring = #ring_rns_L1_1_x8} : !ct_L2_1 -> !ct_L1
    %extracted_slice_15 = tensor.extract_slice %cst[0, 0] [1, 8] [1, 1] : tensor<1x8xi16> to tensor<8xi16>
    %pt_16 = lwe.rlwe_encode %extracted_slice_15 {encoding = #inverse_canonical_encoding, ring = #ring_f64_1_x8} : tensor<8xi16> -> !pt
    %ct_17 = ckks.mul_plain %ct_14, %pt_16 {heir.fusion_group = 6 : i64, heir.fusion_pattern = "ckks.generic_chain"} : (!ct_L1, !pt) -> !ct_L1_1
    %0 = tensor.empty() : tensor<1x!ct_L0>
    %ct_18 = ckks.rescale %ct_17 {heir.fusion_group = 6 : i64, heir.fusion_pattern = "ckks.generic_chain", to_ring = #ring_rns_L0_1_x8} : !ct_L1_1 -> !ct_L0
    %inserted = tensor.insert %ct_18 into %0[%c0] : tensor<1x!ct_L0>
    return %inserted : tensor<1x!ct_L0>
  }
  func.func @dot_product__encrypt__arg0(%arg0: tensor<8xi16>, %pk: !pkey_L4) -> tensor<1x!ct_L4> attributes {client.enc_func = {func_name = "dot_product", index = 0 : i64}} {
    %c0 = arith.constant 0 : index
    %cst = arith.constant dense<0> : tensor<1x8xi16>
    %c0_i32 = arith.constant 0 : i32
    %c1_i32 = arith.constant 1 : i32
    %c8_i32 = arith.constant 8 : i32
    %0 = scf.for %arg1 = %c0_i32 to %c8_i32 step %c1_i32 iter_args(%arg2 = %cst) -> (tensor<1x8xi16>)  : i32 {
      %1 = arith.index_cast %arg1 : i32 to index
      %extracted = tensor.extract %arg0[%1] : tensor<8xi16>
      %inserted = tensor.insert %extracted into %arg2[%c0, %1] : tensor<1x8xi16>
      scf.yield %inserted : tensor<1x8xi16>
    }
    %extracted_slice = tensor.extract_slice %0[0, 0] [1, 8] [1, 1] : tensor<1x8xi16> to tensor<8xi16>
    %pt = lwe.rlwe_encode %extracted_slice {encoding = #inverse_canonical_encoding, ring = #ring_f64_1_x8} : tensor<8xi16> -> !pt
    %ct = lwe.rlwe_encrypt %pt, %pk : (!pt, !pkey_L4) -> !ct_L4
    %from_elements = tensor.from_elements %ct : tensor<1x!ct_L4>
    return %from_elements : tensor<1x!ct_L4>
  }
  func.func @dot_product__encrypt__arg1(%arg0: tensor<8xi16>, %pk: !pkey_L4) -> tensor<1x!ct_L4> attributes {client.enc_func = {func_name = "dot_product", index = 1 : i64}} {
    %c0 = arith.constant 0 : index
    %cst = arith.constant dense<0> : tensor<1x8xi16>
    %c0_i32 = arith.constant 0 : i32
    %c1_i32 = arith.constant 1 : i32
    %c8_i32 = arith.constant 8 : i32
    %0 = scf.for %arg1 = %c0_i32 to %c8_i32 step %c1_i32 iter_args(%arg2 = %cst) -> (tensor<1x8xi16>)  : i32 {
      %1 = arith.index_cast %arg1 : i32 to index
      %extracted = tensor.extract %arg0[%1] : tensor<8xi16>
      %inserted = tensor.insert %extracted into %arg2[%c0, %1] : tensor<1x8xi16>
      scf.yield %inserted : tensor<1x8xi16>
    }
    %extracted_slice = tensor.extract_slice %0[0, 0] [1, 8] [1, 1] : tensor<1x8xi16> to tensor<8xi16>
    %pt = lwe.rlwe_encode %extracted_slice {encoding = #inverse_canonical_encoding, ring = #ring_f64_1_x8} : tensor<8xi16> -> !pt
    %ct = lwe.rlwe_encrypt %pt, %pk : (!pt, !pkey_L4) -> !ct_L4
    %from_elements = tensor.from_elements %ct : tensor<1x!ct_L4>
    return %from_elements : tensor<1x!ct_L4>
  }
  func.func @dot_product__decrypt__result0(%arg0: tensor<1x!ct_L0>, %sk: !skey_L0) -> i16 attributes {client.dec_func = {func_name = "dot_product", index = 0 : i64}} {
    %c0 = arith.constant 0 : index
    %extracted = tensor.extract %arg0[%c0] : tensor<1x!ct_L0>
    %pt = lwe.rlwe_decrypt %extracted, %sk : (!ct_L0, !skey_L0) -> !pt
    %0 = lwe.rlwe_decode %pt {encoding = #inverse_canonical_encoding, ring = #ring_f64_1_x8} : !pt -> tensor<1x8xi16>
    %extracted_0 = tensor.extract %0[%c0, %c0] : tensor<1x8xi16>
    return %extracted_0 : i16
  }
}

