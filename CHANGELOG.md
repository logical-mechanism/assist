# v0.x.y

*This version is contains breaking changes.*

- Added minting.quantity_of to get prove that some form of minting is occurring then the quantity is returned
- Changing sha3_256 to blake2b_256, it is cheaper to compute
- value.unique_token_name has been changed to the v3 version, no more hashing and has a personal tag feature
- Updated aiken to v1.1.2 and stdlib to v2.1.0
- Added the registry type and related function
- stdlib 2.1.0 forces blake2b_224 upon us, this may change in the future
- If applicable stdlib list functions are used unless its faster to avoid them

# v0.5.0

- Updated toml to Aiken 1.1.0, stdlib main (v2.0.0 should be the tagged release)
- addresses.from_wallet check if wallet is valid else it fails
- All math related modules will be in the maths folder
- All cardano related modules will be in the cardano folder
- All validation related modules will be in the validation folder
- Removed assist top level folder to align with stdlib
- stdlib is tagged at v2.0.0
- Updated readme, Plutus v2 is staying on v0.4.11, v3+ is v0.5.x
- Updating cont integration file

# v0.4.11

*Plutus V2 support will stay on v0.4.x*
*Plutus V3+ support will continue on v0.5.x*

- Added a length check for the stake credential inside `addresses.create_address` and `addresses.create_script_address`
- Added compatibility matrix to readme in anticipation of Plutus V3
- Updated README with better usage suggestions
- Updated toml with new organization name
- Added compiler and plutus version to toml file.

# v0.4.10

- Added additional tests for the Moment type

# v0.4.9

*This version is contains breaking changes.*

- Updating Aiken to 1.0.28 and stdlib to 1.9.0
- Dicts are now Pairs where applicable, dict.get -> pairs.get_first
- Updated README with the `aiken packages add` function
- Fixed formatting in the CONTRIBUTING file

# v0.4.8

*This version is contains breaking changes.*

- Updating documentation
- Functions should be curryable, f |> g |> h. An updated list of functions are below.
    - values.contains
    - values.prove_nft
    - values.prove_exact_nft
    - token.exists
    - token.contains
- values.unique_token_name will remove the hash function in step one for versions of assist v0.5.0+
    - v0.4.x will keep the hash function to prevent breaking old code
- Addresses now have notes about key length validity checks. Please use Wallet types with `wallet.is_valid`.
- data.metadata has been removed. Use `CIP68.get` instead.
- maths.to_int and maths.from_int will use bytearray conversions in assist v0.5.0+
- Added additional tests for finding inputs and outputs using `values.contains`

# v0.4.7

- Updated to Aiken 1.0.26
- Updated to stdlib 1.8.0
- Update CIP68 Data Structure
- Changed cip68.get, it loops a list instead of doing a dict.get

# v0.4.6

- Added `input_by_nft` to the find submodule.
- Added additional power mod tests.
- A large prime number has been added to maths.
- Prefixes are now placed where they belong, the cip68 labels are now in cip68 sub type and prefixes are now custom prefixes.
- Added `seed` prefix.

# v0.4.5

- Added the `Wallets` type and `to_vks`  to the wallet submodule.
- Added `get` and `version` to the cip68 submodule.
- Added `shift` to the moment submodule.
- `tests/fake_tx` are now apart of `assist`.
- Added `contains` to the token submodule.

# v0.4.4

- Documentation is now hosted at logicalmechanism.io
- Added `from_value` to the token submodule.
- Updated `values.multiply`, it should be must faster now.
- Tested against Aiken 1.0.23

# v0.4.3

- Added `is_valid` to the wallet submodule.
- Changed `add_tokens_to_value` from private to public in the token type submodule.
- Added `multiply` and `subtraction_only` to the token type submodule.
- Added a `Moments` type to the moment submodule.
- Added `inputs_by_vkh` and `outputs_by_vkh` in count sub module.
- Updated `single_input_with_bypass` to check for vkh equality in the count sub module.
- Added additional functions to the token type submodule
- Added `from_tokens` to the value sub module.

# v0.4.2

- Updated moment `is_contained` to check if a validity range is inside a moment.
- Wrote additional tests for moment and payout
- Updated README
- Added `addition_only` to the token submodule.
- Added `CONTRIBUTING.md`

# v0.4.1

*This version is contains breaking changes.*

- Refactored types to prevent future name collisions
- Added `output_datum_by_nft` to the find submodule.
- All tests should be type annotated.
- Use stdlib 1.7.0 and not `main` branch.
- Readme suggests using tag versions instead of `main` branch.

# v0.4.0

*This version is contains breaking changes.*

- General data types from assist are now used in function definitions. See `types.ak`.
- Refactored how assist types are used in functions.
- `from_wallet` and `from_token` are now in addresses and values respectively.
- Added `is_spending_input` to check if an output reference is being spent.
- `total_token_amount` is moved to `tx.ak` and refactored.
- Fail messages are more specific to the function.
- All `&&` and `||` are now `and` and `or`.
- Added `metadata` to find data from a cip68 metadatum type.

# v0.3.4

- Improved the counting functions to account for datum hashes.
- Improved documentation.

# v0.3.3

- Added arithmetic circuit and boolean logic
- Added input / output datum by hash functions
- Added more functionality to the fake tx for testing.
- Upgraded aiken to 1.21

# v0.3.2

- Functions that fail now have tests that check for fails.
- Using `and` instead of `&&` inside `if-else` control flows.
- Improved the README.
- Upgrade to aiken 1.20.

# v0.3.1

- Upgrade to aiken 1.19 and stdlib 1.6.
- `prefixes.prefix_555` is removed.
- @nikhils9 added in `output_by_addr_value` and `output_by_value`
- `payout.atleast` is refactored using `value.contains`
- pub fn that are wrappers now use the do_fn syntax to align with stdlib.

# v0.3.0

- Upgrade to Aiken 1.14 and stdlib 1.5, list.and and list.or have been removed.

# v0.2.3

- Added in a function to calculate the total amount of some specific token inside all the transaction inputs. 
- Two new prefixes are now added, callable and database. 
- The 555 prefix is being depreciated and will be removed in v0.2.4.
- Added in a function to check if a mint is occurring inside a transaction.

# v0.2.2

- Added minting functions for exact mints and by_prefix mints. 
- A experimental cip68 prefix has been added to prefixes.

# v0.2.1

- CIP68 prefixes have been fixed. The unique token name function still produces correct names but any length checks needs to be adjusted. New prefix length is now 4.

# v0.1.6

- Does not work with Aiken versions below v1.0.7-alpha Aiken and v1.1.0 Stdlib.

## Changes

- Fake Tx is updated with new `MintedValue` type.
- Value add is now value merge. All Values functions have been updated.

# v0.1.5 and below

- Works with v1.0.6-alpha Aiken and v1.0.0 Stdlib