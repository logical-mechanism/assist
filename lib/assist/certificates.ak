//// This module incorporates code for generating valid certificates,
//// ensuring their correctness. 
////

use assist/types/hashes.{ValidatorHash}
use cardano/certificate.{
  Certificate, DelegateBlockProduction, DelegateCredential,
}
use cardano/credential.{Script, StakePoolId}

/// Creates a credential delegation for changing the location of the stake.
/// This certificate can be used to check if stake is being delegated to
/// a specific pool.
///
/// ```aiken
/// certificates.create_credential_delegation(datum.contract_hash, datum.pool_id)
/// ```
pub fn create_credential_delegation(
  sc: ValidatorHash,
  pool_id: StakePoolId,
) -> Certificate {
  DelegateCredential(
    Script(sc),
    DelegateBlockProduction { stake_pool: pool_id },
  )
}

test simple_credential_delegation() {
  let cred: Certificate =
    DelegateCredential(Script(#""), DelegateBlockProduction { stake_pool: #"" })
  create_credential_delegation(#"", #"") == cred
}
