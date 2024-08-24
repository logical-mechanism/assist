//// This module contains code for verifying transaction signatures. 
//// It assumes that all signatures provided are verification keys.
////

use aiken/collection/list
// for testing only
use assist/tests/fake_tx
use assist/types/hashes.{PublicKeyHash}

/// Check if the list of signatures inside a transaction contains the
/// verification key.
///
/// ```aiken
/// signing.verify_sig(context.transaction, wallet_pkh)
/// ```
pub fn verify_sig(vks: List<PublicKeyHash>, vk: PublicKeyHash) -> Bool {
  list.has(vks, vk)
}

test no_signature() {
  let sigs: List<PublicKeyHash> = fake_tx.test_signatories()
  verify_sig(sigs, #"") == False
}

test bad_signature() {
  let sigs: List<PublicKeyHash> = fake_tx.test_signatories()
  verify_sig(sigs, #"cafe") == False
}

test has_signature() {
  let sigs: List<PublicKeyHash> = fake_tx.test_signatories()
  verify_sig(sigs, #"acab") == True
}

test lots_of_signatures() {
  let sigs: List<PublicKeyHash> = fake_tx.test_signatories()
  list.all(list.map(sigs, fn(n) { verify_sig(sigs, n) }), fn(n) { n == True }) == True
}

/// This counts the number of signatures inside a transaction that are from 
/// the list of signers then checks if its at least the minimum amount.
///
/// ```aiken
/// signing.verify_multisig(context.transaction, lst_of_sigs, sig_threshold)
/// ```
pub fn verify_multisig(
  sigs: List<PublicKeyHash>,
  vks: List<PublicKeyHash>,
  minimum: Int,
) -> Bool {
  // assume greater than or equal
  do_multisig(sigs, vks, 0) >= minimum
}

// Internal only
fn do_multisig(
  sigs: List<PublicKeyHash>,
  vks: List<PublicKeyHash>,
  counter: Int,
) -> Int {
  // loop who has to sign tx, count how many signatures have signed.
  when vks is {
    [vk, ..rest] ->
      if verify_sig(sigs, vk) {
        // signature found
        do_multisig(sigs, rest, counter + 1)
      } else {
        // signature not found
        do_multisig(sigs, rest, counter)
      }
    // At the end of the list return how many signed
    [] -> counter
  }
}

test no_multisig() {
  let sigs: List<PublicKeyHash> = fake_tx.test_signatories()
  verify_multisig(sigs, [], 1) == False
}

test bad_multisig() {
  let sigs: List<PublicKeyHash> = fake_tx.test_signatories()
  verify_multisig(sigs, [#"acab"], 2) == False
}

test has_multisig() {
  let sigs: List<PublicKeyHash> = fake_tx.test_signatories()
  verify_multisig(sigs, [#"acab", #"beef"], 2) == True
}

test big_multisig() {
  let sigs: List<PublicKeyHash> = fake_tx.test_signatories()
  verify_multisig(sigs, sigs, 25) == True
}
