use aiken/collection/list
use aiken/crypto.{VerificationKeyHash}
use aiken/primitive/bytearray

/// A wallet type for a non-smart contract address.
pub type Wallet {
  pkh: VerificationKeyHash,
  sc: VerificationKeyHash,
}

/// A list of wallets for non-smart contract addresses.
pub type Wallets =
  List<Wallet>

/// Convert a list of wallets into a list of public key hashes. This is useful
/// when doing multisig validation. The output order respects the input order.
///
/// ```aiken
/// wallet.to_vks(datum.wallets)
/// ```
pub fn to_vks(wallets: Wallets) -> List<VerificationKeyHash> {
  list.map(wallets, fn(w) { w.pkh })
}

test empty_to_vks() {
  to_vks([]) == []
}

test single_to_vks() {
  let w: Wallet =
    Wallet {
      pkh: #"abcdef0123456789abcdef0123456789abcdef0123456789abcdef01",
      sc: #"",
    }
  to_vks([w]) == [#"abcdef0123456789abcdef0123456789abcdef0123456789abcdef01"]
}

test multiple_to_vks() {
  let w: Wallet =
    Wallet {
      pkh: #"abcdef0123456789abcdef0123456789abcdef0123456789abcdef01",
      sc: #"",
    }
  let expected: List<VerificationKeyHash> =
    [
      #"abcdef0123456789abcdef0123456789abcdef0123456789abcdef01",
      #"abcdef0123456789abcdef0123456789abcdef0123456789abcdef01",
      #"abcdef0123456789abcdef0123456789abcdef0123456789abcdef01",
    ]
  to_vks([w, w, w]) == expected
}

/// Check if a wallet has a bad form and needs to be bypassed.
/// The pkh must be the length 56 hex string and the sc is either empty or
/// it is also a length 56 hex string.
///
/// ```aiken
/// wallet.is_valid(datum.wallet)
/// ```
pub fn is_valid(wallet: Wallet) -> Bool {
  and {
    // if pkh is 28 then true else false
    bytearray.length(wallet.pkh) == 28,
    // sc is either empty or 28
    or {
      bytearray.is_empty(wallet.sc),
      bytearray.length(wallet.sc) == 28,
    },
  }
}

test is_valid_pkh() {
  let w: Wallet =
    Wallet {
      pkh: #"abcdef0123456789abcdef0123456789abcdef0123456789abcdef01",
      sc: #"",
    }
  is_valid(w)
}

test is_valid_pkh_sc() {
  let w: Wallet =
    Wallet {
      pkh: #"abcdef0123456789abcdef0123456789abcdef0123456789abcdef01",
      sc: #"abcdef0123456789abcdef0123456789abcdef0123456789abcdef01",
    }
  is_valid(w)
}

test is_invalid_sc() {
  let w: Wallet =
    Wallet {
      pkh: #"abcdef0123456789abcdef0123456789abcdef0123456789abcdef01",
      sc: #"abcd89abcdef0123456789abcdef0123456789abcdef01",
    }
  is_valid(w) == False
}

test is_invalid_pkh() {
  let w: Wallet =
    Wallet { pkh: #"abcdef9abcdef0123456789abcdef0123456789abcdef0", sc: #"" }
  is_valid(w) == False
}
