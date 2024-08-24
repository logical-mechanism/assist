use aiken/hash.{Blake2b_224, Blake2b_256, Hash}
use cardano/credential.{Script, VerificationKey}
use cardano/transaction.{Transaction}

/// The public key hash, vkey, of an wallet address. Expected to be length 56 and
/// is network agnostic. This is a non-smart contract hash. 
pub type PublicKeyHash =
  Hash<Blake2b_224, VerificationKey>

/// The validator hash of a smart contract. Expected to be length 56 and
/// is network agnostic. This is a smart contract hash. 
pub type ValidatorHash =
  Hash<Blake2b_224, Script>

/// The transaction hash. Its the blake2b 256 of a tx body.
pub type TxHash =
  Hash<Blake2b_256, Transaction>
