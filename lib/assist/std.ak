//// This module incorporates additional code that expands the
//// functionality of the standard library.
////

use aiken/builtin.{serialise_data}
// used for testing
use assist/tests/fake_tx
use cardano/transaction.{OutputReference, TransactionId}

/// Create an `OutputReference` from the `TxId#Idx` information. This is useful
/// for building correct output references of specific UTxOs. It can be combined
/// with the `find` module for some very convenient requests.
///
/// ```aiken
/// std.out_ref(that_tx_id, that_tx_idx)
/// ```
pub fn out_ref(tx_id_hash: ByteArray, idx: Int) -> OutputReference {
  OutputReference { transaction_id: tx_id_hash, output_index: idx }
}

test correct_out_ref() {
  let correct_out_ref: OutputReference = fake_tx.test_out_ref()
  out_ref(#"acab", 0) == correct_out_ref
}

test bad_out_ref() {
  let correct_out_ref: OutputReference = fake_tx.test_out_ref()
  out_ref(#"", 0) != correct_out_ref
}

test data_structure() {
  // this can be anything in aiken
  let tx_id: TransactionId = #""
  let test_data_structure =
    OutputReference { transaction_id: tx_id, output_index: 0 }
  // now show the cbor
  let cbor_representation =
    test_data_structure
      |> serialise_data
  cbor_representation == #"d8799f4000ff"
}
