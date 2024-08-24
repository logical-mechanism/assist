//// This module contains code for extracting data from a potential inline 
//// datum found in either an input or output.
////

use aiken/builtin
use aiken/collection/dict.{Dict}
use aiken/hash.{Blake2b_256, Hash}
// for testing only
use assist/tests/fake_tx
use cardano/transaction.{DatumHash, InlineDatum, Input, Output}

/// Find the datum data on an input or error. The data is assumed
/// to be an inline datum.
///
/// ```aiken
/// expect datum: Datum = data.input_datum(this_input)
/// ```
pub fn input_datum(possible_input: Input) -> Data {
  when possible_input.output.datum is {
    InlineDatum(inbound_datum) -> inbound_datum
    _ -> fail @"No Input Datum"
  }
}

test find_input_datum() {
  let input: Input = fake_tx.test_input()
  expect datum: ByteArray = input_datum(input)
  datum == fake_tx.test_datum
}

test cant_find_input_datum() fail {
  let input: Input = fake_tx.test_bad_input()
  expect datum: ByteArray = input_datum(input)
  // this will fail
  datum == fake_tx.test_datum
}

/// Find the datum data on a input by the datum hash or error. The
/// data is assumed to be embedded data and must be referenced by
/// its hash.
///
/// ```aiken
/// expect datum: Datum = data.input_datum_by_hash(this_input, these_datums)
/// ```
pub fn input_datum_by_hash(
  possible_input: Input,
  datums: Dict<Hash<Blake2b_256, Data>, Data>,
) -> Data {
  when possible_input.output.datum is {
    DatumHash(inbound_datum_hash) ->
      when dict.get(datums, inbound_datum_hash) is {
        Some(inbound_datum) -> inbound_datum
        _ -> fail @"No Input Datum Attached"
      }
    _ -> fail @"No Input Datum"
  }
}

test find_input_datum_hash() {
  let input: Input = fake_tx.test_input_with_datum_hash()
  let datums: Dict<ByteArray, Data> =
    dict.new()
      |> dict.insert(key: fake_tx.test_datum, value: builtin.i_data(1))
  expect datum: Int = input_datum_by_hash(input, datums)
  datum == 1
}

test cant_find_input_datum_hash() fail {
  let input: Input = fake_tx.test_input_with_datum_hash()
  let datums: Dict<ByteArray, Data> =
    dict.new()
      |> dict.insert(key: #"acab", value: builtin.i_data(1))
  expect datum: Int = input_datum_by_hash(input, datums)
  // this will fail
  datum == 1
}

/// Find the datum data on an output or error. The data is assumed
/// to be an inline datum.
///
/// ```aiken
/// expect datum: Datum = data.output_datum(that_output)
/// ```
pub fn output_datum(possible_output: Output) -> Data {
  when possible_output.datum is {
    InlineDatum(outbound_datum) -> outbound_datum
    _ -> fail @"No Output Datum"
  }
}

test find_output_datum() {
  let output: Output = fake_tx.test_output()
  expect datum: ByteArray = output_datum(output)
  datum == fake_tx.test_datum
}

test cant_find_output_datum() fail {
  let output: Output = fake_tx.test_bad_output()
  expect datum: ByteArray = output_datum(output)
  // this will fail
  datum == fake_tx.test_datum
}

/// Find the datum data on an output or error. The data is assumed
/// to be embedded.
///
/// ```aiken
/// expect datum: Datum = data.output_datum_by_hash(that_output, these_datums)
/// ```
pub fn output_datum_by_hash(
  possible_output: Output,
  datums: Dict<Hash<Blake2b_256, Data>, Data>,
) -> Data {
  when possible_output.datum is {
    DatumHash(outbound_datum_hash) ->
      when dict.get(datums, outbound_datum_hash) is {
        Some(outbound_datum) -> outbound_datum
        _ -> fail @"No Output Datum Attached"
      }
    _ -> fail @"No Output Datum"
  }
}

test find_output_datum_hash() {
  let output: Output = fake_tx.test_output_with_datum_hash()
  let datums: Dict<ByteArray, Data> =
    dict.new()
      |> dict.insert(key: fake_tx.test_datum, value: builtin.i_data(1))
  expect datum: Int = output_datum_by_hash(output, datums)
  datum == 1
}

test cant_find_output_datum_hash() fail {
  let output: Output = fake_tx.test_output_with_datum_hash()
  let datums: Dict<ByteArray, Data> =
    dict.new()
      |> dict.insert(key: #"acab", value: builtin.i_data(1))
  expect datum: Int = output_datum_by_hash(output, datums)
  // this will fail
  datum == 1
}
