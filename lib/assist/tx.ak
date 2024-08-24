//// This module contains code that aids in various transaction
//// checks and comparisons.
////

use aiken/collection/list
use assist/std
use assist/tests/fake_tx
use assist/types/hashes.{ValidatorHash}
use cardano/assets.{AssetName, PolicyId}
use cardano/credential
use cardano/transaction.{Input, OutputReference}

/// Check if a specific input by output reference is being spent. This is useful
/// when a minting script requires a utxo to be spent but doesn't need any specific
/// information about that input.
///
/// ```aiken
/// tx.is_spending_input(tx.inputs, output_reference)
/// ```
pub fn is_spending_input(inputs: List<Input>, out_ref: OutputReference) -> Bool {
  // loop the inputs and find the output reference
  when inputs is {
    [input, ..rest] ->
      if input.output_reference == out_ref {
        // it is being spent
        True
      } else {
        is_spending_input(rest, out_ref)
      }
    // nothing is found so fail
    [] -> fail @"Input Not Spent"
  }
}

test found_spending_input() {
  let input: Input = fake_tx.test_input()
  let out_ref: OutputReference = std.out_ref(#"acab", 0)
  is_spending_input([input], out_ref) == True
}

test cant_found_spending_input() fail {
  let input: Input = fake_tx.test_input()
  let out_ref: OutputReference = std.out_ref(#"", 0)
  is_spending_input([input], out_ref) == False
}

/// Given a set of validator hashes prove that none of them are being spent. Assume
/// every address is not staked and that the is list is complete.
pub fn not_being_spent_from(
  validator_hashes: List<ValidatorHash>,
  inputs: List<Input>,
) -> Bool {
  when validator_hashes is {
    [vh, ..vhs] -> {
      // check if validator hash exist as an address inside the set of inputs
      let outcome: Bool =
        list.any(
          inputs,
          // may be cheaper to do ValidatorHash equality then Address equality?
          // either build up the address or break down the address
          fn(input) { input.output.address == credential.from_script(vh) },
        )
      // if true then not true else continue to the next validator hash
      if outcome {
        !outcome
      } else {
        not_being_spent_from(vhs, inputs)
      }
    }
    // if nothing ever hit then nothing is being spent
    [] -> True
  }
}

test nothing_being_spent_from() {
  let inputs: List<Input> =
    [fake_tx.test_script_input()]
  let vks: List<ValidatorHash> =
    [#""]
  not_being_spent_from(vks, inputs) == True
}

test something_being_spent_from() {
  let inputs: List<Input> =
    [fake_tx.test_script_input()]
  let vks: List<ValidatorHash> =
    [#"acab"]
  not_being_spent_from(vks, inputs) == False
}

/// Calculate the total amount of a token within the set of inputs for the 
/// transaction and check if it is at least equal to the provided threshold.
///
/// ```aiken
/// values.total_token_amount(tx.inputs, datum.pid, datum.tkn, datum.threshold)
/// ```
pub fn total_token_amount(
  inputs: List<Input>,
  pid: PolicyId,
  tkn: AssetName,
  threshold: Int,
) -> Bool {
  do_total_token_amount(inputs, pid, tkn, 0) >= threshold
}

fn do_total_token_amount(
  inputs: List<Input>,
  pid: PolicyId,
  tkn: AssetName,
  counter: Int,
) -> Int {
  when inputs is {
    [input, ..rest] -> {
      let amt: Int = assets.quantity_of(input.output.value, pid, tkn)
      do_total_token_amount(rest, pid, tkn, counter + amt)
    }
    [] -> counter
  }
}

test count_pid1() {
  let amt: Int = 1
  let inputs: List<Input> = fake_tx.test_inputs(amt)
  total_token_amount(inputs, #"acab", #"beef", amt * 100)
}

test count_pid2() {
  let amt: Int = 2
  let inputs: List<Input> = fake_tx.test_inputs(amt)
  total_token_amount(inputs, #"acab", #"beef", amt * 100)
}

test count_pid3() {
  let amt: Int = 4
  let inputs: List<Input> = fake_tx.test_inputs(amt)
  total_token_amount(inputs, #"acab", #"beef", amt * 100)
}

test count_pid4() {
  let amt: Int = 8
  let inputs: List<Input> = fake_tx.test_inputs(amt)
  total_token_amount(inputs, #"acab", #"beef", amt * 100)
}

test count_pid5() {
  let amt: Int = 16
  let inputs: List<Input> = fake_tx.test_inputs(amt)
  total_token_amount(inputs, #"acab", #"beef", amt * 100)
}
