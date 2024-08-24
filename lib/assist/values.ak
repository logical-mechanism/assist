//// This module contains code that aids in various value 
//// manipulations and comparisons.
////

use aiken/collection/dict
use aiken/collection/list
use aiken/hash
use aiken/primitive/bytearray
use aiken/primitive/string
use assist/types/cip68
use assist/types/hashes.{TxHash}
use assist/types/token.{Token, Tokens}
use cardano/assets.{AssetName, PolicyId, Value}

/// Creates a Value type from a token.
///
/// ```aiken
/// values.from_token(this_token)
/// ```
pub fn from_token(token: Token) -> Value {
  assets.from_asset(token.pid, token.tkn, token.amt)
}

test token_to_value() {
  let token: Token = Token { pid: #"", tkn: #"", amt: 10 }
  let expected: Value = assets.from_lovelace(10)
  from_token(token) == expected
}

/// Creates a Value type from a list of tokens.
///
/// ```aiken
/// values.from_tokens(redeemer.tokens)
/// ```
pub fn from_tokens(tokens: Tokens) -> Value {
  do_from_tokens(assets.zero(), tokens)
}

test tokens_to_value() {
  let token: Token = Token { pid: #"", tkn: #"", amt: 10 }
  let expected: Value = assets.from_lovelace(20)
  from_tokens([token, token]) == expected
}

// Internal only
fn do_from_tokens(val: Value, tokens: Tokens) -> Value {
  when tokens is {
    // take a token and add it to the value
    [tkn, ..tkns] ->
      val |> assets.add(tkn.pid, tkn.tkn, tkn.amt) |> do_from_tokens(tkns)
    // all the things are added so return the value
    [] -> val
  }
}

/// Multiply some value by `n`. This is just a linear scaling to the quantity
/// of each token.
///
/// ```aiken
/// values.multiply(bundle_value, bundle_size)
/// ```
pub fn multiply(val: Value, n: Int) -> Value {
  // convert the Value to Tokens
  let ts: Tokens = token.from_value(val)
  // do the math on the Tokens then map it back to a Value
  do_multiply([], ts, n) |> from_tokens()
}

// Internal only
fn do_multiply(ans: Tokens, ts: Tokens, n: Int) -> Tokens {
  when ts is {
    // take a token and add it to the value
    [tkn, ..tkns] ->
      ans
        |> list.push(Token { pid: tkn.pid, tkn: tkn.tkn, amt: n * tkn.amt })
        |> do_multiply(tkns, n)
    // each token has been multiplied
    [] -> ans
  }
}

test values_multiply_by_0() {
  let val: Value = assets.from_lovelace(100)
  let ans: Value = assets.zero()
  multiply(val, 0) == ans
}

test values_multiply_by_4() {
  let val: Value = assets.from_lovelace(100)
  let ans: Value = assets.from_lovelace(400)
  multiply(val, 4) == ans
}

test values_multiply_by_52314523() {
  let val: Value = assets.from_lovelace(2)
  let ans: Value = assets.from_lovelace(104629046)
  multiply(val, 52314523) == ans
}

/// Prove that the target value is contained inside another assets. Each token
/// inside the target must exist inside the total assets. The quantity of each
/// token must be at least the target amount or greater.
///
/// ```aiken
/// values.contains(total_value, target_value)
/// ```
pub fn contains(total: Value, target: Value) -> Bool {
  let flat: List<(PolicyId, AssetName, Int)> = assets.flatten(target)
  do_contains(total, flat)
}

// Internal only
fn do_contains(total: Value, flat: List<(PolicyId, AssetName, Int)>) -> Bool {
  when flat is {
    [(pid, tkn, amt), ..rest] ->
      if assets.quantity_of(total, pid, tkn) >= amt {
        do_contains(total, rest)
      } else {
        // something is missing
        False
      }
    // found all of them
    [] -> True
  }
}

test value_contains_lovelace() {
  let target: Value = assets.from_lovelace(10)
  let total: Value = assets.from_lovelace(100)
  contains(total, target) == True
}

test value_contains_tokens() {
  let target: Value = assets.from_asset(#"acab", #"beef", 10)
  let total: Value = assets.from_asset(#"acab", #"beef", 40)
  contains(total, target) == True
}

test value_contains_both() {
  let target: Value =
    assets.from_lovelace(10)
      |> assets.merge(assets.from_asset(#"acab", #"beef", 2))
      |> assets.merge(assets.from_asset(#"cafe", #"face", 10))
  let total: Value =
    assets.from_lovelace(100)
      |> assets.merge(assets.from_asset(#"acab", #"beef", 10))
      |> assets.merge(assets.from_asset(#"cafe", #"face", 40))
      |> assets.merge(assets.from_asset(#"beef", #"face", 40))
      |> assets.merge(assets.from_asset(#"face", #"beef", 40))
  contains(total, target) == True
}

test value_contains_nothing() {
  let target: Value = assets.from_lovelace(10)
  let total: Value = assets.from_asset(#"acab", #"beef", 40)
  contains(total, target) == False
}

/// Compute the sha3_256 hash of a value by merklizing the policy id, asset
/// name, and quantity. Empty values return the empty by string.
///
/// ```aiken
/// values.compute_hash(validating_value)
/// ```
pub fn compute_hash(target: Value) -> ByteArray {
  let flat: List<(PolicyId, AssetName, Int)> = assets.flatten(target)
  do_compute_hash(flat, #"")
}

// Internal only
fn do_compute_hash(
  flat: List<(PolicyId, AssetName, Int)>,
  total: ByteArray,
) -> ByteArray {
  when flat is {
    [(pid, tkn, amt), ..rest] -> {
      let hashed_amt: ByteArray = int_to_hash(amt)
      // concat the things then hash
      let concatted: ByteArray =
        pid
          |> bytearray.concat(tkn)
          |> bytearray.concat(hashed_amt)
          |> bytearray.concat(total)
      let next: ByteArray = hash.sha3_256(concatted)
      do_compute_hash(rest, next)
    }
    [] -> total
  }
}

// Private function to sha3 256 an integer into a bytearray.
// Internal only
fn int_to_hash(num: Int) -> ByteArray {
  string.from_int(num) |> bytearray.from_string() |> hash.sha3_256()
}

test hash_empty_value() {
  let val: Value = assets.zero()
  compute_hash(val) == #""
}

test hash_lovelace_value() {
  let val: Value = assets.from_lovelace(100)
  compute_hash(val) == #"93b41836fbabea4f566ccb5aaa6ba4aa7efc92b4401cce01f4766c8e70225824"
}

test hash_large_value() {
  let val: Value =
    assets.from_lovelace(100)
      |> assets.merge(assets.from_asset(#"acab", #"beef", 10))
      |> assets.merge(assets.from_asset(#"cafe", #"face", 40))
      |> assets.merge(assets.from_asset(#"beef", #"face", 40))
      |> assets.merge(assets.from_asset(#"face", #"beef", 40))
  compute_hash(val) == #"b22cc86ab71b7aba20615b56f07941aacf5445b9089c2d9ec97164a879e1b6b5"
}

/// Calculate a unique token name from a `TxId#Idx` and prefix. Can be combined
/// with the `find` module to create unique token names from the first input
/// utxo inside the transaction.
///
/// ```aiken
/// values.unique_token_name(tx_id, tx_idx, cip68.prefix_333)
/// ```
pub fn unique_token_name(txid: TxHash, idx: Int, prefix: ByteArray) -> AssetName {
  // sha3_256 hash of the tx id
  // this step will be removed in Assist v0.5.0+
  let txid_hash: ByteArray = hash.sha3_256(txid)
  // prefix the txid hash with the index
  let prepend_index: ByteArray = bytearray.push(txid_hash, idx)
  // concat the prefix
  let prepend_prefix: ByteArray = bytearray.concat(prefix, prepend_index)
  // slice off the first 32
  bytearray.slice(prepend_prefix, 0, 31)
}

test no_prefix_token_name() {
  // the zero becomes the prefix
  unique_token_name(#"", 0, #"") == #"00a7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f843"
}

test prefix_222_token_name() {
  let tkn: AssetName = unique_token_name(#"", 0, cip68.prefix_222)
  // the prefixes all have length 4
  bytearray.take(tkn, 4) == cip68.prefix_222
}

test real_token_name() {
  let tkn: AssetName =
    unique_token_name(
      #"82fca2f3221cf2d3ef017e8aa76f5c70317df0af32d327c84af4b9b9bddad91f",
      0,
      cip68.prefix_100,
    )
  bytearray.length(tkn) == 32
}

/// Proves that inside some value there is a policy id with a single token
/// name that has a quantity of 1. This will show that a value contains an
/// NFT or something that is nft-like. Should be useful to prove that
/// something is holding a token inside a transaction when the token name
/// is assumed to be unique.
///
/// ```aiken
/// values.prove_nft(this_value, pid)
/// ```
pub fn prove_nft(total: Value, pid: PolicyId) {
  let amts: List<Int> = assets.tokens(total, pid) |> dict.values()
  let sum: Int = list.foldl(amts, 0, fn(n, total) { n + total })
  and {
    // must have only one asset name
    list.length(amts) == 1,
    sum == 1,
  }
}

test prove_nft_from_policy_id() {
  let val: Value =
    assets.from_lovelace(100)
      |> assets.merge(assets.from_asset(#"acab", #"beef", 1))
      |> assets.merge(assets.from_asset(#"cafe", #"face", 40))
      |> assets.merge(assets.from_asset(#"beef", #"face", 40))
      |> assets.merge(assets.from_asset(#"face", #"beef", 40))
  prove_nft(val, #"acab") == True
}

test too_many_nfts() {
  let val: Value =
    assets.from_lovelace(100)
      |> assets.merge(assets.from_asset(#"acab", #"beef", 1))
      |> assets.merge(assets.from_asset(#"acab", #"face", 1))
      |> assets.merge(assets.from_asset(#"beef", #"face", 40))
      |> assets.merge(assets.from_asset(#"face", #"beef", 40))
  prove_nft(val, #"acab") == False
}

test missing_nft() {
  let val: Value =
    assets.from_lovelace(100)
      |> assets.merge(assets.from_asset(#"acab", #"beef", 10))
      |> assets.merge(assets.from_asset(#"cafe", #"face", 10))
      |> assets.merge(assets.from_asset(#"beef", #"face", 40))
      |> assets.merge(assets.from_asset(#"face", #"beef", 40))
  prove_nft(val, #"acab") == False
}

/// Proves that inside some value there is a policy id with token
/// name that has a quantity of 1. This will show that a value contains an
/// NFT or something that is nft-like. Should be useful to prove that
/// something is holding a token inside a transaction when the policy id and
/// token name is known.
///
/// ```aiken
/// values.prove_exact_nft(that_value, pid, tkn)
/// ```
pub fn prove_exact_nft(
  total_value: Value,
  nft_pid: PolicyId,
  nft_tkn: AssetName,
) -> Bool {
  // exactly 1 token inside a value
  assets.quantity_of(total_value, nft_pid, nft_tkn) == 1
}

test prove_exact_nft_from_policy_id() {
  let val: Value =
    assets.from_lovelace(100)
      |> assets.merge(assets.from_asset(#"acab", #"beef", 1))
      |> assets.merge(assets.from_asset(#"cafe", #"face", 40))
      |> assets.merge(assets.from_asset(#"beef", #"face", 40))
      |> assets.merge(assets.from_asset(#"face", #"beef", 40))
  prove_exact_nft(val, #"acab", #"beef") == True
}

test missing_exact_nft() {
  let val: Value =
    assets.from_lovelace(100)
      |> assets.merge(assets.from_asset(#"acab", #"beef", 10))
      |> assets.merge(assets.from_asset(#"cafe", #"face", 10))
      |> assets.merge(assets.from_asset(#"beef", #"face", 40))
      |> assets.merge(assets.from_asset(#"face", #"beef", 40))
  prove_exact_nft(val, #"acab", #"beef") == False
}
