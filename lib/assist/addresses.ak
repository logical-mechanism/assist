//// This module incorporates code for generating valid wallet and script 
//// addresses, ensuring their correctness. Empty keys are treated as 
//// intentional, and address subtypes are not combined nor mixed. The key
//// lengths must be validated on their own as these functions are used to
//// just generate Address types assuming valid key lengths.
////

use aiken/primitive/bytearray
use assist/types/hashes.{PublicKeyHash, ValidatorHash}
use assist/types/wallet.{Wallet}
use cardano/credential.{Address, Inline, Script, VerificationKey}

/// Creates an address from the Wallet type. This should be used primairly for
/// creating an address as the Wallet type has a `is_valid` function that should
/// be used in the same validaiton.
///
/// ```aiken
/// let addr: Address = types.from_wallet(this_wallet)
/// ```
pub fn from_wallet(wallet: Wallet) -> Address {
  create_address(wallet.pkh, wallet.sc)
}

/// Creates a enterprise or base address from the public key hash and stake
/// credential. An empty sc means enterpise address by default. This function
/// assumes proper key lengths for `pkh` and `sc`. Again, this function does not
/// check if the stake credential has a proper length. Address
/// types should be generated from the Wallet type so proper length checks are
/// done with the `wallet.is_valid` function.
///
/// ```aiken
/// addresses.create_address(datum.wallet.pkh, datum.wallet.sc)
/// ```
pub fn create_address(pkh: PublicKeyHash, sc: PublicKeyHash) -> Address {
  // empty bytearrays means dont add the sc to the pkh
  if bytearray.is_empty(sc) {
    credential.from_verification_key(pkh)
  } else {
    credential.from_verification_key(pkh)
      |> credential.with_delegation_key(sc)
  }
}

test enterprise_wallet() {
  let addr: Address =
    Address {
      payment_credential: VerificationKey(#"acab"),
      stake_credential: None,
    }
  create_address(#"acab", #"") == addr
}

test base_wallet() {
  let addr: Address =
    Address {
      payment_credential: VerificationKey(#"acab"),
      stake_credential: Some(Inline(VerificationKey(#"face"))),
    }
  create_address(#"acab", #"face") == addr
}

test correct_wallet_sc() {
  let addr: Address =
    Address {
      payment_credential: VerificationKey(#"acab"),
      stake_credential: Some(Inline(VerificationKey(#""))),
    }
  create_script_address(#"acab", #"") != addr
}

/// Creates a script address for a smart contract. The type does not mix address
/// types. Staked smart contracts are contracts as well. An empty sc is
/// assumed to be not staked. This function assumes proper key lengths for `vkh`
/// and `sc`. Again, this function does not check if the stake credential has a
/// proper length. Address types should be generated from the Wallet type so 
/// proper length checks are done with the `wallet.is_valid` function.
///
/// ```aiken
/// addresses.create_script_address(datum.script.vkh, datum.script.sc)
/// ```
pub fn create_script_address(vkh: ValidatorHash, sc: ValidatorHash) -> Address {
  // empty bytearrays means dont add the sc to the pkh
  if bytearray.is_empty(sc) {
    credential.from_script(vkh)
  } else {
    credential.from_script(vkh)
      |> credential.with_delegation_script(sc)
  }
}

test enterprise_script() {
  let script_addr: Address =
    Address { payment_credential: Script(#"acab"), stake_credential: None }
  create_script_address(#"acab", #"") == script_addr
}

test base_script() {
  let script_addr: Address =
    Address {
      payment_credential: Script(#"acab"),
      stake_credential: Some(Inline(Script(#"face"))),
    }
  create_script_address(#"acab", #"face") == script_addr
}

test correct_script_sc() {
  let script_addr: Address =
    Address {
      payment_credential: Script(#"acab"),
      stake_credential: Some(Inline(Script(#""))),
    }
  create_script_address(#"acab", #"") != script_addr
}
