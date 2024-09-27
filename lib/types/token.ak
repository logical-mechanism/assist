//// A Token is a safe type for some asset on Cardano. A Token can be combined
//// with another Token to form Tokens, a list of Token.  This should be a safe
//// and clean way to build out the value type inside of datums and redeemers 
//// instead of building out the value type directly which could be harmful.
////

use aiken/collection/dict
use aiken/collection/list
use cardano/assets.{AssetName, PolicyId, Value}

/// A token type for a safe single policy id and asset name assets.
pub type Token {
  pid: PolicyId,
  tkn: AssetName,
  amt: Int,
}

/// A tokens type for a safe value as a list of Tokens.
pub type Tokens =
  List<Token>

/// Give the negative of a token.
///
/// ```aiken
/// token.negative(this_token)
/// ```
pub fn negative(tkn: Token) -> Token {
  Token { pid: tkn.pid, tkn: tkn.tkn, amt: -tkn.amt }
}

test its_negative() {
  let token: Token = Token { pid: #"", tkn: #"", amt: 10 }
  let expected: Token = Token { pid: #"", tkn: #"", amt: -10 }
  negative(token) == expected
}

/// Negate all the tokens in the list.
///
/// ```aiken
/// token.negate(these_tokens)
/// ```
pub fn negate(tokens: Tokens) -> Tokens {
  list.map(
    tokens,
    fn(tkn) { Token { pid: tkn.pid, tkn: tkn.tkn, amt: -tkn.amt } },
  )
}

test all_tokens_negated() {
  let token: Token = Token { pid: #"", tkn: #"", amt: 10 }
  let expected: Token = Token { pid: #"", tkn: #"", amt: -10 }
  negate([token, token]) == [expected, expected]
}

/// Divide a token by some integer. The divisor must be positive. This is
/// integer division so the token amount will be rounded towards negative 
/// infinity.
///
/// ```aiken
/// token.divide(that_token, 2)
/// ```
pub fn divide(token: Token, n: Int) -> Token {
  if n <= 0 {
    fail @"Invalid Divisor"
  } else {
    Token { pid: token.pid, tkn: token.tkn, amt: token.amt / n }
  }
}

/// Multiply a token by some integer. This linearly scales the token amount
/// on the token.
///
/// ```aiken
/// token.multiply(that_token, 4)
/// ```
pub fn multiply(token: Token, n: Int) -> Token {
  Token { pid: token.pid, tkn: token.tkn, amt: n * token.amt }
}

test multiply_by_zero() {
  let token: Token = Token { pid: #"", tkn: #"", amt: 10 }
  let expected: Token = Token { pid: #"", tkn: #"", amt: 0 }
  multiply(token, 0) == expected
}

test multiply_by_one() {
  let token: Token = Token { pid: #"", tkn: #"", amt: 10 }
  let expected: Token = Token { pid: #"", tkn: #"", amt: 10 }
  multiply(token, 1) == expected
}

test multiply_by_two() {
  let token: Token = Token { pid: #"", tkn: #"", amt: 10 }
  let expected: Token = Token { pid: #"", tkn: #"", amt: 20 }
  multiply(token, 2) == expected
}

/// Check that each token is less than zero in a list tokens.
///
/// ```aiken
/// token.subtraction_only(redeemer.tokens)
/// ```
pub fn subtraction_only(tokens: Tokens) -> Bool {
  list.all(tokens, fn(tkn) { tkn.amt < 0 })
}

test everything_is_negative() {
  let token: Token = Token { pid: #"", tkn: #"", amt: -1 }
  subtraction_only([token, token, token]) == True
}

test everything_is_negative_but_one() {
  let token1: Token = Token { pid: #"", tkn: #"", amt: -1 }
  let token2: Token = Token { pid: #"", tkn: #"", amt: 1 }
  subtraction_only([token1, token1, token2]) == False
}

/// Check that each token is greater than zero in a list tokens.
///
/// ```aiken
/// token.addition_only(redeemer.tokens)
/// ```
pub fn addition_only(tokens: Tokens) -> Bool {
  list.all(tokens, fn(tkn) { tkn.amt > 0 })
}

test empty_tokens_is_positive() {
  and {
    addition_only([]) == True,
    subtraction_only([]) == True,
  }
}

test everything_is_positive() {
  let token: Token = Token { pid: #"", tkn: #"", amt: 1 }
  addition_only([token, token, token]) == True
}

test everything_is_positive_but_one() {
  let token1: Token = Token { pid: #"", tkn: #"", amt: 1 }
  let token2: Token = Token { pid: #"", tkn: #"", amt: -1 }
  addition_only([token1, token1, token2]) == False
}

/// Add a Token type to a Value type. This should be a very safe way to
/// increment a value on a UTxO. The other option is having the redeemer be 
/// the general Value type and potentially allow badly formed values to be used.
///
/// ```aiken
/// add_token_to_value(token, this_value)
/// ```
pub fn add_token_to_value(the_value: Value, token: Token) -> Value {
  assets.add(the_value, token.pid, token.tkn, token.amt)
}

test add_empty_token_to_value() {
  let zero: Value = assets.zero
  let token: Token = Token { pid: #"", tkn: #"", amt: 0 }
  add_token_to_value(zero, token) == zero
}

test add_ada_token_to_value() {
  let zero: Value = assets.zero
  let token: Token = Token { pid: #"", tkn: #"", amt: 10 }
  add_token_to_value(zero, token) == assets.from_lovelace(10)
}

test add_and_subtract_token_to_value() {
  let zero: Value = assets.zero
  let token1: Token = Token { pid: #"", tkn: #"", amt: 10 }
  let token2: Token = Token { pid: #"", tkn: #"", amt: -10 }
  let expected: Value =
    add_token_to_value(zero, token1) |> add_token_to_value(token2)
  expected == zero
}

/// Add a list of Token types to a Value type. This should be a very safe way to
/// increment a value on a UTxO. The other option is having the redeemer be 
/// the general Value type and potentially allow badly formed values to be used.
///
/// ```aiken
/// add_tokens_to_value(redeemer.tokens, this_value)
/// ```
pub fn add_tokens_to_value(the_value: Value, tokens: Tokens) -> Value {
  list.foldl(tokens, the_value, fn(tkn, v) { add_token_to_value(v, tkn) })
}

test add_empty_tokens_to_value() {
  let zero: Value = assets.zero
  let token: Token = Token { pid: #"", tkn: #"", amt: 0 }
  add_tokens_to_value(zero, [token, token, token]) == zero
}

test add_ada_tokens_to_value() {
  let zero: Value = assets.zero
  let token: Token = Token { pid: #"", tkn: #"", amt: 10 }
  add_tokens_to_value(zero, [token, token, token]) == assets.from_lovelace(30)
}

test add_and_subtract_tokens_to_value() {
  let zero: Value = assets.zero
  let token1: Token = Token { pid: #"", tkn: #"", amt: 10 }
  let token2: Token = Token { pid: #"", tkn: #"", amt: -10 }
  add_tokens_to_value(zero, [token1, token2]) == zero
}

/// Convert a value into a list of tokens. This conversation is a fast way
/// to be able to do multiplication on a assets.
///
/// ```aiken
/// token.from_value(this_value)
/// ```
pub fn from_value(v: Value) -> Tokens {
  assets.to_dict(v)
    |> dict.foldl(
        [],
        fn(pid, assets, tokens) {
          dict.foldl(
            assets,
            tokens,
            fn(tkn, amt, tokens) { list.push(tokens, Token { pid, tkn, amt }) },
          )
        },
      )
}

test from_zero_value() {
  let v: Value = assets.zero
  let e: Tokens = []
  from_value(v) == e
}

test from_lovelace_value() {
  let v: Value = assets.from_lovelace(123)
  let e: Tokens =
    [Token { pid: assets.ada_policy_id, tkn: assets.ada_asset_name, amt: 123 }]
  from_value(v) == e
}

test from_general_value() {
  let v: Value = assets.from_lovelace(123) |> assets.add(#"acab", #"cafe", 41)
  let e: Tokens =
    [
      Token { pid: #"acab", tkn: #"cafe", amt: 41 },
      Token { pid: assets.ada_policy_id, tkn: assets.ada_asset_name, amt: 123 },
    ]
  from_value(v) == e
}

/// Check if a Token exists in a list of Tokens. The amount has to be greater
/// than or equal to the target.
///
/// ```aiken
/// token.exists(total_tokens, target_token )
/// ```
pub fn exists(total: Tokens, target: Token) -> Bool {
  list.any(
    total,
    fn(tkn) {
      and {
        target.pid == tkn.pid,
        target.tkn == tkn.tkn,
        tkn.amt >= target.amt,
      }
    },
  )
}

/// Check if a target list of tokens exist inside another list of tokens.
/// The token amount must be greater than or equal to the target amount. If
/// nothing is found then it returns False.
///
/// ```aiken
/// token.contains(total, target)
/// ```
pub fn contains(total: Tokens, target: Tokens) -> Bool {
  list.all(target, fn(t) { exists(total, t) })
}

test tokens_contains_lovelace() {
  let target: Tokens =
    [Token { pid: assets.ada_policy_id, tkn: assets.ada_asset_name, amt: 100 }]
  let total: Tokens =
    [Token { pid: assets.ada_policy_id, tkn: assets.ada_asset_name, amt: 100 }]
  contains(total, target) == True
}

test tokens_contains_tokens() {
  let target: Tokens = [Token { pid: #"acab", tkn: #"beef", amt: 10 }]
  let total: Tokens = [Token { pid: #"acab", tkn: #"beef", amt: 40 }]
  contains(total, target) == True
}

test tokens_contains_both() {
  let target: Tokens =
    [
      Token { pid: assets.ada_policy_id, tkn: assets.ada_asset_name, amt: 10 },
      Token { pid: #"acab", tkn: #"beef", amt: 2 },
      Token { pid: #"cafe", tkn: #"face", amt: 10 },
    ]
  let total: Tokens =
    [
      Token { pid: assets.ada_policy_id, tkn: assets.ada_asset_name, amt: 100 },
      Token { pid: #"acab", tkn: #"beef", amt: 20 },
      Token { pid: #"cafe", tkn: #"face", amt: 100 },
    ]

  contains(total, target) == True
}

test tokens_contains_nothing() {
  let target: Tokens =
    [Token { pid: assets.ada_policy_id, tkn: assets.ada_asset_name, amt: 100 }]
  let total: Tokens = [Token { pid: #"acab", tkn: #"beef", amt: 40 }]
  contains(total, target) == False
}
