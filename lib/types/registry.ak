use aiken/crypto
use aiken/crypto/bls12_381/g1
use aiken/crypto/bls12_381/scalar.{Scalar}
use aiken/primitive/bytearray

/// Alpha is the generator and beta is the public value. The pair is formed from
/// the relationship g^x = u, where g is the generator and u is the public value.
/// The value x is a secret integer used to create the public value from the 
/// generator.
pub type Register {
  // the generator, #<Bls12_381, G1>
  generator: ByteArray,
  // the public value, #<Bls12_381, G1>
  public_value: ByteArray,
}

/// This simulates randomizing a register. It is used for testing purposes only.
///
/// ```aiken
/// registry.randomize(register, random_scalar)
/// ```
fn randomize(datum: Register, s: Scalar) -> Register {
  // decompress the generator and public value
  let g: G1Element = g1.decompress(datum.generator)
  let u: G1Element = g1.decompress(datum.public_value)
  // now randomize the register elements
  let g_s: G1Element = g1.scale(g, s)
  let u_s: G1Element = g1.scale(u, s)
  // recompress the new randomized elements
  Register { generator: g_s |> g1.compress, public_value: u_s |> g1.compress }
}

test cheapest_hash() {
  let s: ByteArray =
    #"abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890"
  // PASS [mem:   805, cpu:   2661352] expensive hash
  // crypto.keccak_256(s) == #"8f0af42555406ff9bab0485545772d9e31b44053cf31ffbfb75ac5a8554d81fe"
  //
  // PASS [mem:   805, cpu:   1857339] cheap hash
  // crypto.sha3_256(s) == #"9ecad985f1c9ea970cea83b6a1e18bf0e3cb904c025024935ca056edb74f4b2a"
  //
  // PASS [mem:   805, cpu:    502754] cheap hash
  // crypto.sha2_256(s) == #"359397539cc67687fa779c133c4da0cc60097dfef9e63b5ccf08eca0fca05530"
  //
  // PASS [mem:   805, cpu:    382606] cheaper hash
  // crypto.blake2b_224(s) == #"0c97d8d889acb1d65d23e44212b0a4e16a57fc0ebcfea8f5f965f8ba"
  //
  //  PASS [mem:  805, cpu:    376479] cheapest hash
  crypto.blake2b_256(s) == #"667f1e9b75c8eac1cccf77a2f82526a478b01ec0f26dd938b5b5b4ad0d856368"
}

/// A bytearray of a value for the challenge c. This process should act like a
/// random oracle providing a large challenge value for the user. The inputs
/// should be compressed g1 elements but they can also be compressed integers.
///
/// ```aiken
/// registry.fiat_shamir_heuristic(g_b, g_r_b, u_b, b)
/// ```
fn fiat_shamir_heuristic(
  // compressed g element
  g_b: ByteArray,
  // compressed g^r element
  g_r_b: ByteArray,
  // compressed g^x element
  u_b: ByteArray,
  // a bound used to create one time transforms
  b: ByteArray,
) -> ByteArray {
  // concat g_b, g_r_b, u_b, and b together then hash the result using the 
  // we are forced to use blake2b_224
  g_b
    |> bytearray.concat(g_r_b)
    |> bytearray.concat(u_b)
    |> bytearray.concat(b)
    |> crypto.blake2b_224()
}

test empty_fiat_shamir_transform() {
  fiat_shamir_heuristic(#"", #"", #"", #"") == #"836cc68931c2e4e3e838602eca1902591d216837bafddfe6f0c8cb07"
}

test real_fiat_shamir_transform() {
  fiat_shamir_heuristic(
    #"97f1d3a73197d7942695638c4fa9ac0fc3688c4f9774b905a14e3a3f171bac586c55e83ff97a1aeffb3af00adb22c6bb",
    #"81b223cea171a87feba9b7749a2df7601c5a75ae01155fadc124a2ac49099a514cf1e7d9cdc769dceab14a95bd6cb0bd",
    #"a09d99e02f7200526dc55ef722cc171e7aa14fc732614c02ac58d59d7026a7eb18d8798f6928ea2b513f3a4feb0c94d1",
    #"acab",
  ) == #"1b556f7bb6a26d00a7c79468794858ba6aa0e41a2c3af0754ec4a11d"
}

/// A Schnorr proof to prove knowledge of the secret value x without revealing 
/// the value in the process. The proof uses, in multiplicative form, 
/// g^z = g^r * u^c, where z = r + c*x and u = g^x. This function uses the 
/// Fiat-Shamir heuristic for non-interactivity.
///
/// ```aiken
/// registry.prove(datum, z_b, g_r_b, bound)
/// ```
pub fn prove(
  datum: Register,
  z_b: ByteArray,
  g_r_b: ByteArray,
  bound: ByteArray,
) -> Bool {
  //
  // the z computation: g^z = g^(r + c * x) = g^r * g^(c * x) = g^r * (g^x)^c
  expect Some(z): Option<Scalar> = scalar.from_bytearray_big_endian(z_b)
  let g_z: G1Element = g1.decompress(datum.generator) |> g1.scale(z)
  //
  // use the fiat-shamir heuristic to calculate the challenge then convert it to an integer
  expect Some(c): Option<Scalar> =
    fiat_shamir_heuristic(datum.generator, g_r_b, datum.public_value, bound)
      |> scalar.from_bytearray_big_endian()
  //
  // the u^c computation: u^c = (g^x)^c = g^(x * c)
  let u_c: G1Element = g1.decompress(datum.public_value) |> g1.scale(c)
  //
  // check if equation: g^z = g^r * u^c is true
  //
  g_z |> g1.equal(g1.add(g1.decompress(g_r_b), u_c))
}

test valid_schnorr_proof() {
  // some secret x 
  expect Some(x): Option<Scalar> =
    scalar.new(
      42435875175126190479447740508185965837690552500527637822603658699938581184513,
    )
  // the datum register using the g1 generator and the public value for x
  let datum: Register =
    Register {
      generator: g1.generator |> g1.compress,
      public_value: g1.generator |> g1.scale(x) |> g1.compress,
    }
  // a random number
  expect Some(r): Option<Scalar> =
    scalar.new(
      32435875175126190479447740508185965837690552500527637822603658699938581184513,
    )
  // the bound, something unique from the tx
  let bound: ByteArray = #"acab"
  // calculate the g^r term
  let g: G1Element = g1.generator
  let g_r: G1Element = g1.scale(g, r)
  let g_r_b: ByteArray = g_r |> g1.compress
  // the challenge number using a fiat shamir transform
  let c_b: ByteArray =
    fiat_shamir_heuristic(datum.generator, g_r_b, datum.public_value, bound)
  expect Some(c): Option<Scalar> = scalar.from_bytearray_big_endian(c_b)
  // the z value
  let z: Scalar = scalar.mul(c, x) |> scalar.add(r)
  let z_b: ByteArray = scalar.to_bytearray_big_endian(z, 0)
  prove(datum, z_b, g_r_b, bound)
}

test randomized_valid_schnorr_proof() {
  // some secret x 
  expect Some(x): Option<Scalar> =
    scalar.new(
      12435875175126190479447740508185965837690552500527637822603658699938581184513,
    )
  // the datum register using the g1 generator and the public value for x
  let datum: Register =
    Register {
      generator: g1.generator |> g1.compress,
      public_value: g1.generator |> g1.scale(x) |> g1.compress,
    }
  // a random number
  expect Some(r): Option<Scalar> =
    scalar.new(
      32435875175126190479447740508185965837690552500527637822603658699938581184513,
    )
  // another random number
  expect Some(d): Option<Scalar> =
    scalar.new(
      12435875175126190479447740508185965837690552500527637822603658699938581184513,
    )
  // rerandomize the a0 register
  let datum_rng: Register = randomize(datum, d)
  // the bound, something unique from the tx
  let bound: ByteArray = #"acabface"
  // calculate the g^r term
  let g: G1Element = datum_rng.generator |> g1.decompress
  let g_r: G1Element = g1.scale(g, r)
  let g_r_b: ByteArray = g_r |> g1.compress
  // the challenge number using a fiat shamir transform
  let c_b: ByteArray =
    fiat_shamir_heuristic(
      datum_rng.generator,
      g_r_b,
      datum_rng.public_value,
      bound,
    )
  expect Some(c): Option<Scalar> = scalar.from_bytearray_big_endian(c_b)
  // the z value
  let z: Scalar = scalar.mul(c, x) |> scalar.add(r)
  let z_b: ByteArray = scalar.to_bytearray_big_endian(z, 0)
  prove(datum_rng, z_b, g_r_b, bound)
}

test invalid_schnorr_proof() fail {
  // some secret x 
  expect Some(x): Option<Scalar> =
    scalar.new(
      42435875175126190479447740508185965837690552500527637822603658699938581184513,
    )
  // the datum register using the g1 generator and the public value for x
  let datum: Register =
    Register {
      generator: g1.generator |> g1.compress,
      public_value: g1.generator |> g1.scale(x) |> g1.compress,
    }
  // a random number
  expect Some(r): Option<Scalar> =
    scalar.new(
      32435875175126190479447740508185965837690552500527637822603658699938581184513,
    )
  // the bound, something unique from the tx
  let bound: ByteArray = #""
  // calculate the g^r term
  let g: G1Element = g1.generator
  let g_r: G1Element = g1.scale(g, r)
  let g_r_b: ByteArray = g_r |> g1.compress
  // the challenge number using a fiat shamir transform
  let c_b: ByteArray =
    fiat_shamir_heuristic(datum.generator, g_r_b, datum.public_value, bound)
  expect Some(c): Option<Scalar> = scalar.from_bytearray_big_endian(c_b)
  // the bad z value, it assumes the secret is the challenge
  let z: Scalar = scalar.mul(c, c) |> scalar.add(r)
  let z_b: ByteArray = scalar.to_bytearray_big_endian(z, 0)
  prove(datum, z_b, g_r_b, bound)
}
