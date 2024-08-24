//// This is for testing only.
////

use aiken/collection/dict
use aiken/collection/list
use aiken/interval.{Interval, IntervalBound, NegativeInfinity, PositiveInfinity}
use assist/addresses
use cardano/assets.{Lovelace}
use cardano/credential.{Credential, VerificationKey}
use cardano/transaction.{
  DatumHash, InlineDatum, Input, NoDatum, Output, OutputReference, Spend,
  Transaction,
}

/// A test datum.
pub const test_datum: ByteArray = #"acabbeeffacecafe"

/// A `Data`data type
pub type DataType =
  Data

/// Creates an `OutputReference`
pub fn test_out_ref() -> OutputReference {
  let out_ref: OutputReference =
    OutputReference { transaction_id: #"acab", output_index: 0 }
  out_ref
}

/// Creates an `OutputReference`
pub fn test_bad_out_ref() -> OutputReference {
  let out_ref: OutputReference =
    OutputReference { transaction_id: #"", output_index: 1 }
  out_ref
}

/// A fake input used for testing.
pub fn test_inputs(amt: Int) -> List<Input> {
  let input: Input =
    Input {
      output_reference: OutputReference { transaction_id: #"", output_index: 0 },
      output: Output {
        address: addresses.create_address(#"acab", #""),
        value: assets.from_asset(#"acab", #"beef", 100),
        datum: InlineDatum(#""),
        reference_script: None,
      },
    }
  list.repeat(input, amt)
}

/// A fake input used for testing.
pub fn test_input() -> Input {
  let input: Input =
    Input {
      output_reference: OutputReference {
        transaction_id: #"acab",
        output_index: 0,
      },
      output: Output {
        address: addresses.create_address(#"acab", #""),
        value: assets.from_lovelace(100),
        datum: InlineDatum(test_datum),
        reference_script: None,
      },
    }
  input
}

/// A fake input used for testing.
pub fn test_script_input() -> Input {
  let input: Input =
    Input {
      output_reference: OutputReference { transaction_id: #"", output_index: 0 },
      output: Output {
        address: addresses.create_script_address(#"acab", #""),
        value: assets.from_lovelace(100),
        datum: InlineDatum(test_datum),
        reference_script: None,
      },
    }
  input
}

/// A fake input with a datum hash.
pub fn test_input_with_datum_hash() {
  let input: Input =
    Input {
      output_reference: OutputReference { transaction_id: #"", output_index: 0 },
      output: Output {
        address: addresses.create_address(#"acab", #""),
        value: assets.from_lovelace(100),
        datum: DatumHash(test_datum),
        reference_script: None,
      },
    }
  input
}

/// A fake input without datum used for testing.
pub fn test_bad_input() -> Input {
  let input: Input =
    Input {
      output_reference: OutputReference { transaction_id: #"", output_index: 0 },
      output: Output {
        address: addresses.create_address(#"acab", #""),
        value: assets.from_lovelace(100),
        datum: NoDatum,
        reference_script: None,
      },
    }
  input
}

pub fn test_one_lovelace_input() -> Input {
  Input {
    output_reference: OutputReference { transaction_id: #"", output_index: 1 },
    output: Output {
      address: addresses.create_address(#"face", #""),
      value: assets.from_lovelace(1),
      datum: NoDatum,
      reference_script: None,
    },
  }
}

pub fn test_bad_inputs() -> List<Input> {
  [
    Input {
      output_reference: OutputReference { transaction_id: #"", output_index: 1 },
      output: Output {
        address: addresses.create_script_address(#"acab", #""),
        value: assets.from_lovelace(100),
        datum: InlineDatum(test_datum),
        reference_script: None,
      },
    },
    Input {
      output_reference: OutputReference { transaction_id: #"", output_index: 1 },
      output: Output {
        address: addresses.create_address(#"face", #""),
        value: assets.from_lovelace(5),
        datum: NoDatum,
        reference_script: None,
      },
    },
    Input {
      output_reference: OutputReference { transaction_id: #"", output_index: 1 },
      output: Output {
        address: addresses.create_address(#"face", #""),
        value: assets.from_lovelace(1),
        datum: NoDatum,
        reference_script: None,
      },
    },
    Input {
      output_reference: OutputReference { transaction_id: #"", output_index: 1 },
      output: Output {
        address: addresses.create_script_address(#"cafe", #"acab"),
        value: assets.from_lovelace(100),
        datum: InlineDatum(test_datum),
        reference_script: None,
      },
    },
  ]
}

/// A fake output used for testing.
pub fn test_output() -> Output {
  let output: Output =
    Output {
      address: addresses.create_address(#"acab", #""),
      value: assets.from_asset(#"acab", #"beef", 40),
      datum: InlineDatum(test_datum),
      reference_script: None,
    }
  output
}

// A fake output with a datum hash used for testing.
pub fn test_output_with_datum_hash() -> Output {
  let output: Output =
    Output {
      address: addresses.create_address(#"acab", #""),
      value: assets.from_asset(#"acab", #"beef", 40),
      datum: DatumHash(test_datum),
      reference_script: None,
    }
  output
}

/// A fake output without datum used for testing.
pub fn test_bad_output() -> Output {
  let output: Output =
    Output {
      address: addresses.create_address(#"acab", #""),
      value: assets.from_asset(#"acab", #"beef", 40),
      datum: NoDatum,
      reference_script: None,
    }
  output
}

pub fn test_bad_outputs() -> List<Output> {
  [
    Output {
      address: addresses.create_address(#"acab", #""),
      value: assets.from_asset(#"acab", #"beef", 40),
      datum: InlineDatum(test_datum),
      reference_script: None,
    },
    Output {
      address: addresses.create_address(#"face", #""),
      value: assets.from_lovelace(40),
      datum: NoDatum,
      reference_script: None,
    },
    Output {
      address: addresses.create_address(#"face", #""),
      value: assets.from_lovelace(60),
      datum: NoDatum,
      reference_script: None,
    },
    Output {
      address: addresses.create_script_address(#"beef", #"beef"),
      value: assets.from_asset(#"fade", #"cafe", 1),
      datum: InlineDatum(test_datum),
      reference_script: None,
    },
    Output {
      address: addresses.create_address(#"cafe", #"beef"),
      value: assets.from_asset(#"fade", #"fade", 1),
      datum: NoDatum,
      reference_script: None,
    },
  ]
}

/// A fake list of tx signers
pub fn test_signatories() -> List<ByteArray> {
  [
    #"acab", #"beef", #"face", #"acba", #"befe", #"faec", #"caab", #"ebef",
    #"afce", #"acab00", #"beef00", #"face00", #"acba00", #"befe00", #"faec00",
    #"caab00", #"ebef00", #"afce00", #"acab0011", #"beef0011", #"face0011",
    #"acba0011", #"befe0011", #"faec0011", #"caab0011", #"ebef0011", #"afce0011",
    #"acab99", #"beef99", #"face99", #"acba99", #"befe99", #"faec99", #"caab99",
    #"ebef99", #"afce99", #"acab0099", #"beef0099", #"face0099", #"acba0099",
    #"befe0099", #"faec0099", #"caab0099", #"ebef0099", #"afce0099",
    #"acab001199", #"beef001199", #"face001199", #"acba001199", #"befe001199",
    #"faec001199", #"caab001199", #"ebef001199", #"afce001199",
  ]
}

/// A fake transaction used for testing.
pub fn test_tx() -> Transaction {
  let sc: Credential = VerificationKey(#"acab")
  let out_ref: OutputReference = test_out_ref()
  let withdrawal: Pairs<Credential, Lovelace> =
    [Pair(sc, 100)]
  let d: DataType = 1
  let redeem =
    [Pair(Spend(out_ref), d)]
  let tx =
    Transaction {
      inputs: [
        Input {
          output_reference: out_ref,
          output: Output {
            address: addresses.create_address(#"acab", #""),
            value: assets.from_lovelace(100),
            datum: InlineDatum(test_datum),
            reference_script: None,
          },
        },
        Input {
          output_reference: OutputReference {
            transaction_id: #"",
            output_index: 1,
          },
          output: Output {
            address: addresses.create_address(#"face", #""),
            value: assets.from_lovelace(5),
            datum: NoDatum,
            reference_script: None,
          },
        },
        Input {
          output_reference: OutputReference {
            transaction_id: #"",
            output_index: 1,
          },
          output: Output {
            address: addresses.create_address(#"face", #""),
            value: assets.from_lovelace(5),
            datum: NoDatum,
            reference_script: None,
          },
        },
      ],
      reference_inputs: [],
      outputs: [
        Output {
          address: addresses.create_address(#"acab", #""),
          value: assets.from_asset(#"acab", #"beef", 40),
          datum: InlineDatum(test_datum),
          reference_script: None,
        },
        Output {
          address: addresses.create_address(#"face", #""),
          value: assets.from_lovelace(40),
          datum: NoDatum,
          reference_script: None,
        },
        Output {
          address: addresses.create_address(#"face", #""),
          value: assets.from_lovelace(60),
          datum: NoDatum,
          reference_script: None,
        },
      ],
      fee: 0,
      mint: assets.zero(),
      certificates: [],
      withdrawals: withdrawal,
      validity_range: Interval {
        lower_bound: IntervalBound {
          bound_type: NegativeInfinity,
          is_inclusive: True,
        },
        upper_bound: IntervalBound {
          bound_type: PositiveInfinity,
          is_inclusive: True,
        },
      },
      extra_signatories: test_signatories(),
      redeemers: redeem,
      datums: dict.new(),
      id: #"",
      votes: [],
      proposal_procedures: [],
      current_treasury_amount: None,
      treasury_donation: None,
    }
  tx
}
