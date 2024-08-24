//// This module contains code to accurately count the number of inputs and
//// outputs in a transaction containing an address or a datum.
////

use aiken/collection/list
use assist/addresses
// for testing only
use assist/tests/fake_tx
use cardano/credential.{Address, Script}
use cardano/transaction.{DatumHash, InlineDatum, Input, Output, Transaction}

/// Verify that the number of inputs with an inline datum or datum hash is equal to the
/// number intended in the contract. The amount must be exactly the counter.
///
/// ```aiken
/// count.inputs_by_datum(tx.inputs, 1)
/// ```
pub fn inputs_by_datum(inputs: List<Input>, amount: Int) -> Bool {
  do_inputs_by_datum(inputs, 0) == amount
}

// Internal only
fn do_inputs_by_datum(inputs: List<Input>, counter: Int) -> Int {
  when inputs is {
    [input, ..rest] ->
      when input.output.datum is {
        // the actual datum value isn't important here
        InlineDatum(_) -> do_inputs_by_datum(rest, counter + 1)
        // the actual datum hash isn't important here
        DatumHash(_) -> do_inputs_by_datum(rest, counter + 1)
        // anything else just keep going
        _ -> do_inputs_by_datum(rest, counter)
      }
    // loop the list
    [] -> counter
  }
}

test single_input_datum() {
  let tx: Transaction = fake_tx.test_tx()
  inputs_by_datum(tx.inputs, 1) == True
}

test single_input_datum_hash() {
  let input: Input = fake_tx.test_input_with_datum_hash()
  inputs_by_datum([input], 1) == True
}

test single_input_with_mixed_datums() {
  let input1: Input = fake_tx.test_input_with_datum_hash()
  let input2: Input = fake_tx.test_input()
  inputs_by_datum([input1, input2], 2) == True
}

test not_enough_input_datums() {
  let tx: Transaction = fake_tx.test_tx()
  inputs_by_datum(tx.inputs, 2) == False
}

test not_enough_input_datum_hashes() {
  let input: Input = fake_tx.test_input_with_datum_hash()
  inputs_by_datum([input], 2) == False
}

test empty_input_datums() {
  inputs_by_datum([], 0) == True
}

/// Count the number of inputs with a payment credential that is a script.
/// This does not take in an address but is a general count of validator hashes.
///
/// ```aiken
/// count.inputs_by_vkh(tx.inputs, 1)
/// ```
pub fn inputs_by_vkh(inputs: List<Input>, amount: Int) -> Bool {
  do_inputs_by_vkh(inputs, 0) == amount
}

fn do_inputs_by_vkh(inputs: List<Input>, counter: Int) -> Int {
  when inputs is {
    [input, ..rest] ->
      // exact address match
      when input.output.address.payment_credential is {
        Script(_) -> do_inputs_by_vkh(rest, counter + 1)
        _ -> do_inputs_by_vkh(rest, counter)
      }
    [] -> counter
  }
}

test double_vkh_script_input() {
  let this_inputs: List<Input> = fake_tx.test_bad_inputs()
  inputs_by_vkh(this_inputs, 2) == True
}

test no_vkh_script_input() {
  let tx: Transaction = fake_tx.test_tx()
  inputs_by_vkh(tx.inputs, 1) == False
}

/// Count the number of outputs with a payment credential that is a script.
/// This does not take in an address but is a general count of validator hashes.
///
/// ```aiken
/// count.outputs_by_vkh(tx.outputs, 1)
/// ```
pub fn outputs_by_vkh(outputs: List<Output>, amount: Int) -> Bool {
  do_outputs_by_vkh(outputs, 0) == amount
}

fn do_outputs_by_vkh(outputs: List<Output>, counter: Int) -> Int {
  when outputs is {
    [output, ..rest] ->
      // exact address match
      when output.address.payment_credential is {
        Script(_) -> do_outputs_by_vkh(rest, counter + 1)
        _ -> do_outputs_by_vkh(rest, counter)
      }
    [] -> counter
  }
}

test single_vkh_script_output() {
  let this_outputs: List<Output> = fake_tx.test_bad_outputs()
  outputs_by_vkh(this_outputs, 1) == True
}

test no_vkh_script_output() {
  let tx: Transaction = fake_tx.test_tx()
  outputs_by_vkh(tx.outputs, 1) == False
}

/// Verify that the number of inputs from a specific script is equal to the
/// amount intended in the contract. The amount must be exactly the counter.
///
/// ```aiken
/// count.inputs_by_addr(tx.inputs, this_addr, 1)
/// ```
pub fn inputs_by_addr(inputs: List<Input>, addr: Address, amount: Int) -> Bool {
  do_inputs_by_addr(inputs, addr, 0) == amount
}

// Internal only
fn do_inputs_by_addr(inputs: List<Input>, addr: Address, counter: Int) -> Int {
  when inputs is {
    [input, ..rest] ->
      // exact address match
      if input.output.address == addr {
        do_inputs_by_addr(rest, addr, counter + 1)
      } else {
        do_inputs_by_addr(rest, addr, counter)
      }
    [] -> counter
  }
}

test single_script_input() {
  let tx: Transaction = fake_tx.test_tx()
  let addr: Address = addresses.create_address(#"acab", #"")
  inputs_by_addr(tx.inputs, addr, 1) == True
}

test not_enough_inputs_by_addr() {
  let tx: Transaction = fake_tx.test_tx()
  let addr: Address = addresses.create_address(#"acab", #"")
  inputs_by_addr(tx.inputs, addr, 2) == False
}

test multiple_inputs_by_addr() {
  let tx: Transaction = fake_tx.test_tx()
  let addr: Address = addresses.create_address(#"face", #"")
  inputs_by_addr(tx.inputs, addr, 2) == True
}

test empty_input_addr() {
  let addr: Address = addresses.create_address(#"acab", #"")
  inputs_by_addr([], addr, 0) == True
}

/// Verify that the number of outputs from a specific script is equal the amount
/// intended in the contract. The amount must be exact with the counter.
///
/// ```aiken
/// count.outputs_by_addr(tx.outputs, this_addr, 1)
/// ```
pub fn outputs_by_addr(
  outputs: List<Output>,
  addr: Address,
  amount: Int,
) -> Bool {
  do_outputs_by_addr(outputs, addr, 0) == amount
}

// Internal only
fn do_outputs_by_addr(outputs: List<Output>, addr: Address, counter: Int) -> Int {
  when outputs is {
    [output, ..rest] ->
      // exact address match
      if output.address == addr {
        do_outputs_by_addr(rest, addr, counter + 1)
      } else {
        do_outputs_by_addr(rest, addr, counter)
      }
    // loop entire list then return counter
    [] -> counter
  }
}

test single_script_output() {
  let tx: Transaction = fake_tx.test_tx()
  let addr: Address = addresses.create_address(#"acab", #"")
  outputs_by_addr(tx.outputs, addr, 1) == True
}

test not_enough_outputs_by_addr() {
  let tx: Transaction = fake_tx.test_tx()
  let addr: Address = addresses.create_address(#"acab", #"")
  outputs_by_addr(tx.outputs, addr, 2) == False
}

test multiple_outputs_by_addr() {
  let tx: Transaction = fake_tx.test_tx()
  let addr: Address = addresses.create_address(#"face", #"")
  outputs_by_addr(tx.outputs, addr, 2) == True
}

test empty_output_addr() {
  let addr: Address = addresses.create_address(#"acab", #"")
  outputs_by_addr([], addr, 0) == True
}

/// Verify that the number of outputs with an inline datum or datum hash is equal to the
/// number intended in the contract. The amount must be exactly the counter.
///
/// ```aiken
/// count.outputs_by_datum(tx.outputs, 1)
/// ```
pub fn outputs_by_datum(outputs: List<Output>, amount: Int) -> Bool {
  do_outputs_by_datum(outputs, 0) == amount
}

// Internal only
fn do_outputs_by_datum(outputs: List<Output>, counter: Int) -> Int {
  when outputs is {
    [output, ..rest] ->
      when output.datum is {
        // the actual datum value is not important here
        InlineDatum(_) -> do_outputs_by_datum(rest, counter + 1)
        // the actual datum hash is not important here
        DatumHash(_) -> do_outputs_by_datum(rest, counter + 1)
        // anything else just keep going
        _ -> do_outputs_by_datum(rest, counter)
      }
    // loop entire list then return counter
    [] -> counter
  }
}

test single_output_datum() {
  let tx: Transaction = fake_tx.test_tx()
  outputs_by_datum(tx.outputs, 1) == True
}

test not_enough_output_datums() {
  let tx: Transaction = fake_tx.test_tx()
  outputs_by_datum(tx.outputs, 2) == False
}

test single_output_datum_hash() {
  let output: Output = fake_tx.test_output_with_datum_hash()
  outputs_by_datum([output], 1) == True
}

test single_output_with_mixed_datums() {
  let output1 = fake_tx.test_output_with_datum_hash()
  let output2 = fake_tx.test_output()
  outputs_by_datum([output1, output2], 2) == True
}

test not_enough_output_datum_hashes() {
  let output: Output = fake_tx.test_output_with_datum_hash()
  outputs_by_datum([output], 2) == False
}

test empty_output_datums() {
  outputs_by_datum([], 0) == True
}

/// The contract can only be spent by itself or along side some list of know 
/// addresses. Loop all the inputs and count how many datums belong to this 
/// address. If any of those addresses exists then pass right over them but if 
/// anything else is found then fail. This should prevent unregulated contracts
/// from being spent along side this script.
///
/// ```aiken
/// count.single_input_with_bypass(this_tx.inputs, this_addr, [that_addr])
/// ```
///
pub fn single_input_with_bypass(
  inputs: List<Input>,
  this_addr: Address,
  those_addrs: List<Address>,
) -> Bool {
  do_single_input_with_bypass(inputs, 0, this_addr, those_addrs)
}

fn vkh_addr_eq(a: Address, b: Address) -> Bool {
  when a.payment_credential is {
    Script(avkh) ->
      when b.payment_credential is {
        Script(bvkh) -> avkh == bvkh
        _ -> False
      }
    _ -> False
  }
}

test vkh_addr_eq_works1() {
  let a: Address = addresses.create_script_address(#"acab", #"")
  let b: Address = addresses.create_script_address(#"acab", #"")
  vkh_addr_eq(a, b)
}

test vkh_addr_eq_works2() {
  let a: Address = addresses.create_address(#"acab", #"")
  let b: Address = addresses.create_address(#"acab", #"")
  vkh_addr_eq(a, b) == False
}

// Internal only
fn do_single_input_with_bypass(
  inputs: List<Input>,
  counter: Int,
  this_addr: Address,
  those_addrs: List<Address>,
) -> Bool {
  when inputs is {
    [input, ..rest] ->
      when input.output.datum is {
        // the actual datum value isn't important here
        InlineDatum(_) ->
          if vkh_addr_eq(input.output.address, this_addr) {
            // count it
            do_single_input_with_bypass(
              rest,
              counter + 1,
              this_addr,
              those_addrs,
            )
          } else if list.any(
            those_addrs,
            fn(n) { vkh_addr_eq(input.output.address, n) },
          ) {
            // all good
            do_single_input_with_bypass(rest, counter, this_addr, those_addrs)
          } else {
            False
          }
        // the actual datum hash isn't important here
        DatumHash(_) ->
          if vkh_addr_eq(input.output.address, this_addr) {
            // count it
            do_single_input_with_bypass(
              rest,
              counter + 1,
              this_addr,
              those_addrs,
            )
          } else if list.any(
            those_addrs,
            fn(n) { vkh_addr_eq(input.output.address, n) },
          ) {
            // all good
            do_single_input_with_bypass(rest, counter, this_addr, those_addrs)
          } else {
            False
          }
        _ -> do_single_input_with_bypass(rest, counter, this_addr, those_addrs)
      }
    // there can be only this address and any amount of those addresses but nothing else
    [] -> counter == 1
  }
}

test single_input_with_no_bypass() {
  let this_inputs: List<Input> = fake_tx.test_bad_inputs()
  let addr1: Address = addresses.create_script_address(#"acab", #"")
  let addr2: Address = addresses.create_script_address(#"cafe", #"acab")
  single_input_with_bypass(this_inputs, addr1, [addr2]) == True
}

test single_input_with_a_bad_bypass() {
  let this_inputs: List<Input> = fake_tx.test_bad_inputs()
  let addr: Address = addresses.create_script_address(#"acab", #"")
  single_input_with_bypass(this_inputs, addr, []) == False
}
