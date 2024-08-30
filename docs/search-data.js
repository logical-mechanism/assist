window.Aiken.initSearch([{"doc":"maths/circuits","title":"and_","content":"and_(x: Int, y: Int, p: Int) -&gt; Int\n Performs a logical `AND` operation on two integer values within an arithmetic circuit.\n\n ```aiken\n circuits.and_(1, 1, p)\n ```","url":"maths/circuits.html#and_"},{"doc":"maths/circuits","title":"or_","content":"or_(x: Int, y: Int, p: Int) -&gt; Int\n Performs a logical `OR` operation on two integer values within an arithmetic circuit..\n \n ```aiken\n circuits.or_(0, 1, p)\n ```","url":"maths/circuits.html#or_"},{"doc":"maths/circuits","title":"not_","content":"not_(x: Int, p: Int) -&gt; Int\n Performs a logical `NOT` operation on an integer value within an arithmetic circuit.\n\n ```aiken\n circuits.not_(1, p)\n ```","url":"maths/circuits.html#not_"},{"doc":"maths/circuits","title":"xor_","content":"xor_(x: Int, y: Int, p: Int) -&gt; Int\n Performs a logical `XOR` operation on two integer values within an arithmetic circuit.\n\n ```aiken\n circuits.xor_(0, 1, p)\n ```","url":"maths/circuits.html#xor_"},{"doc":"maths/circuits","title":"nand_","content":"nand_(x: Int, y: Int, p: Int) -&gt; Int\n Performs a logical `NAND` operation on two integer values within an arithmetic circuit.\n \n ```aiken\n circuits.nand_(1, 1, p)\n ```","url":"maths/circuits.html#nand_"},{"doc":"maths/circuits","title":"nor_","content":"nor_(x: Int, y: Int, p: Int) -&gt; Int\n Performs a logical `NOR` operation on two integer values within an arithmetic circuit.\n \n ```aiken\n circuits.nor_(0, 0, p)\n ```","url":"maths/circuits.html#nor_"},{"doc":"maths/circuits","title":"xnor_","content":"xnor_(x: Int, y: Int, p: Int) -&gt; Int\n Performs a logical `XNOR` operation on two integer values within an arithmetic circuit.\n \n ```aiken\n circuits.xnor_(1, 1, p)\n ```","url":"maths/circuits.html#xnor_"},{"doc":"maths/circuits","title":"imply_","content":"imply_(x: Int, y: Int, p: Int) -&gt; Int\n Performs a logical implication operation on two integer values within an arithmetic circuit.\n \n ```aiken\n circuits.imply_(1, 0, p)\n ```","url":"maths/circuits.html#imply_"},{"doc":"maths/circuits","title":"maths/circuits","content":" This module contains code to do arithmetic circuit logic on integers.\n All values are assumed to be positive and p is a prime.\n","url":"maths/circuits.html"},{"doc":"maths/routines","title":"powmod","content":"powmod(n: Int, e: Int, q: Int) -&gt; Int\n Calculate `n` to the power of `e` modulo `q` using the exponentiation by \n squaring method. At each multiplication a modulo is calculated, allowing\n very large `n` and `e` values.\n\n ```aiken\n maths.powmod(3, 2, 5)\n ```","url":"maths/routines.html#powmod"},{"doc":"maths/routines","title":"base_q","content":"base_q(n: Int, q: Int) -&gt; List&lt;Int&gt;\n Convert a integer `n` into some base `q`. This method\n should scale with any integer and any logical base.\n\n ```aiken\n maths.base_q(123, 7)\n ```","url":"maths/routines.html#base_q"},{"doc":"maths/routines","title":"to_int","content":"to_int(self: ByteArray) -&gt; Int\n Convert a hexadecimal bytearray into its base 10 representation. This\n only works with even length bytearrays so arbitrary numbers in hexadecimal\n form will not in general work.\n\n ```aiken\n maths.to_int(#&quot;acab&quot;)\n ```","url":"maths/routines.html#to_int"},{"doc":"maths/routines","title":"from_int","content":"from_int(self: Int) -&gt; ByteArray\n Convert a integer into a hexadecimal bytearray. This works for all integers\n but odd length bytearrays will be prefixed with a zero. This function \n combined with the `to_int` function allows a string to represent a number\n and still be used for calculations, pushing the `2^64 - 1` integer boundary.\n\n ```aiken\n maths.from_int(44203)\n ```","url":"maths/routines.html#from_int"},{"doc":"maths/routines","title":"maths/routines","content":"","url":"maths/routines.html"},{"doc":"maths/boolean","title":"and_","content":"and_(x: Int, y: Int) -&gt; Int\n Performs a logical `AND` operation on two integer values.\n Expects both inputs as binary (0 or 1) and returns 1 if both are 1, otherwise returns 0.\n\n ```aiken\n boolean.and_(1, 1)\n ```","url":"maths/boolean.html#and_"},{"doc":"maths/boolean","title":"or_","content":"or_(x: Int, y: Int) -&gt; Int\n Performs a logical `OR` operation on two integer values.\n Expects both inputs as binary (0 or 1) and returns 1 if at least one input is 1, otherwise returns 0.\n \n ```aiken\n boolean.or_(0, 1)\n ```","url":"maths/boolean.html#or_"},{"doc":"maths/boolean","title":"not_","content":"not_(x: Int) -&gt; Int\n Performs a logical `NOT` operation on an integer value.\n Expects the input as binary (0 or 1) and returns the inverse (1 becomes 0, 0 becomes 1).\n\n ```aiken\n boolean.not_(1)\n ```","url":"maths/boolean.html#not_"},{"doc":"maths/boolean","title":"xor_","content":"xor_(x: Int, y: Int) -&gt; Int\n Performs a logical `XOR` operation on two integer values.\n Expects both inputs as binary (0 or 1) and returns 1 if the inputs are different, otherwise returns 0.\n\n ```aiken\n boolean.xor_(0, 1)\n ```","url":"maths/boolean.html#xor_"},{"doc":"maths/boolean","title":"nand_","content":"nand_(x: Int, y: Int) -&gt; Int\n Performs a logical `NAND` operation on two integer values.\n Returns 1 if at least one input is 0, otherwise returns 0.\n \n ```aiken\n boolean.nand_(1, 1)\n ```","url":"maths/boolean.html#nand_"},{"doc":"maths/boolean","title":"nor_","content":"nor_(x: Int, y: Int) -&gt; Int\n Performs a logical `NOR` operation on two integer values.\n Returns 1 if both inputs are 0, otherwise returns 0.\n \n ```aiken\n boolean.nor_(0, 0)\n ```","url":"maths/boolean.html#nor_"},{"doc":"maths/boolean","title":"xnor_","content":"xnor_(x: Int, y: Int) -&gt; Int\n Performs a logical `XNOR` operation on two integer values.\n Returns 1 if the inputs are the same, otherwise returns 0.\n \n ```aiken\n boolean.xnor_(1, 1)\n ```","url":"maths/boolean.html#xnor_"},{"doc":"maths/boolean","title":"imply_","content":"imply_(x: Int, y: Int) -&gt; Int\n Performs a logical implication operation on two integer values.\n Returns 1 if the first input is false or both inputs are true, otherwise returns 0.\n \n ```aiken\n boolean.imply_(1, 0)\n ```","url":"maths/boolean.html#imply_"},{"doc":"maths/boolean","title":"maths/boolean","content":" This module contains code to do boolean logic on integers.\n Boolean logic here is the special case of arithmetic circuit logic with p = 2.\n","url":"maths/boolean.html"},{"doc":"cardano/tx","title":"output_reference","content":"output_reference(tx_id_hash: ByteArray, idx: Int) -&gt; OutputReference\n Create an `OutputReference` from the `TxId#Idx` information. This is useful\n for building correct output references of specific UTxOs. It can be combined\n with the `find` module for some very convenient requests.\n\n ```aiken\n tx.output_reference(that_tx_id, that_tx_idx)\n ```","url":"cardano/tx.html#output_reference"},{"doc":"cardano/tx","title":"verify_signature","content":"verify_signature(\n  vks: List&lt;VerificationKeyHash&gt;,\n  vk: VerificationKeyHash,\n) -&gt; Bool\n Check if the list of signatures inside a transaction contains the\n verification key.\n\n ```aiken\n signing.verify_signature(context.transaction, wallet_pkh)\n ```","url":"cardano/tx.html#verify_signature"},{"doc":"cardano/tx","title":"verify_multisig","content":"verify_multisig(\n  sigs: List&lt;VerificationKeyHash&gt;,\n  vks: List&lt;VerificationKeyHash&gt;,\n  minimum: Int,\n) -&gt; Bool\n This counts the number of signatures inside a transaction that are from \n the list of signers then checks if its at least the minimum amount.\n\n ```aiken\n signing.verify_multisig(context.transaction, lst_of_sigs, sig_threshold)\n ```","url":"cardano/tx.html#verify_multisig"},{"doc":"cardano/tx","title":"is_spending_input","content":"is_spending_input(inputs: List&lt;Input&gt;, out_ref: OutputReference) -&gt; Bool\n Check if a specific input by output reference is being spent. This is useful\n when a minting script requires a utxo to be spent but doesn&#39;t need any specific\n information about that input.\n\n ```aiken\n tx.is_spending_input(tx.inputs, output_reference)\n ```","url":"cardano/tx.html#is_spending_input"},{"doc":"cardano/tx","title":"not_being_spent_from","content":"not_being_spent_from(\n  validator_hashes: List&lt;ScriptHash&gt;,\n  inputs: List&lt;Input&gt;,\n) -&gt; Bool\n Given a set of validator hashes prove that none of them are being spent. Assume\n every address is not staked and that the is list is complete.","url":"cardano/tx.html#not_being_spent_from"},{"doc":"cardano/tx","title":"total_token_amount","content":"total_token_amount(\n  inputs: List&lt;Input&gt;,\n  pid: PolicyId,\n  tkn: AssetName,\n  threshold: Int,\n) -&gt; Bool\n Calculate the total amount of a token within the set of inputs for the \n transaction and check if it is at least equal to the provided threshold.\n\n ```aiken\n values.total_token_amount(tx.inputs, datum.pid, datum.tkn, datum.threshold)\n ```","url":"cardano/tx.html#total_token_amount"},{"doc":"cardano/tx","title":"cardano/tx","content":" This module incorporates additional code that expands the\n functionality of the standard library.\n","url":"cardano/tx.html"},{"doc":"cardano/datum","title":"input_datum","content":"input_datum(possible_input: Input) -&gt; Data\n Find the datum data on an input or error. The data is assumed\n to be an inline datum.\n\n ```aiken\n expect datum: Datum = data.input_datum(this_input)\n ```","url":"cardano/datum.html#input_datum"},{"doc":"cardano/datum","title":"input_datum_by_hash","content":"input_datum_by_hash(\n  possible_input: Input,\n  datums: Dict&lt;Hash&lt;Blake2b_256, Data&gt;, Data&gt;,\n) -&gt; Data\n Find the datum data on a input by the datum hash or error. The\n data is assumed to be embedded data and must be referenced by\n its hash.\n\n ```aiken\n expect datum: Datum = data.input_datum_by_hash(this_input, these_datums)\n ```","url":"cardano/datum.html#input_datum_by_hash"},{"doc":"cardano/datum","title":"output_datum","content":"output_datum(possible_output: Output) -&gt; Data\n Find the datum data on an output or error. The data is assumed\n to be an inline datum.\n\n ```aiken\n expect datum: Datum = data.output_datum(that_output)\n ```","url":"cardano/datum.html#output_datum"},{"doc":"cardano/datum","title":"output_datum_by_hash","content":"output_datum_by_hash(\n  possible_output: Output,\n  datums: Dict&lt;Hash&lt;Blake2b_256, Data&gt;, Data&gt;,\n) -&gt; Data\n Find the datum data on an output or error. The data is assumed\n to be embedded.\n\n ```aiken\n expect datum: Datum = data.output_datum_by_hash(that_output, these_datums)\n ```","url":"cardano/datum.html#output_datum_by_hash"},{"doc":"cardano/datum","title":"cardano/datum","content":" This module contains code for extracting data from a potential inline \n datum found in either an input or output.\n","url":"cardano/datum.html"},{"doc":"cardano/addresses","title":"from_wallet","content":"from_wallet(wallet: Wallet) -&gt; Address\n Creates an address from the Wallet type. This should be used primairly for\n creating an address as the Wallet type has a `is_valid` function that should\n be used in the same validaiton.\n\n ```aiken\n let addr: Address = types.from_wallet(this_wallet)\n ```","url":"cardano/addresses.html#from_wallet"},{"doc":"cardano/addresses","title":"create_address","content":"create_address(pkh: VerificationKeyHash, sc: VerificationKeyHash) -&gt; Address\n Creates a enterprise or base address from the public key hash and stake\n address. An empty sc means enterpise address by default. This function\n assumes proper key lengths for `pkh`.Address types should be generated from\n the Wallet type so proper length checks are done with the `wallet.is_valid`\n function located in `types/wallet.ak`.\n\n\n ```aiken\n addresses.create_address(datum.wallet.pkh, datum.wallet.sc)\n ```","url":"cardano/addresses.html#create_address"},{"doc":"cardano/addresses","title":"create_script_address","content":"create_script_address(vkh: ScriptHash, sc: ScriptHash) -&gt; Address\n Creates a script address for a smart contract. The type does not mix\n address types. Staking credentials are assumed to be smart contracts. An \n empty stake credential or bad length stake credential is invalid and will\n be assumed to be not staked. This function assumes proper key lengths for `vkh`.\n\n ```aiken\n addresses.create_script_address(datum.script.vkh, datum.script.sc)\n ```","url":"cardano/addresses.html#create_script_address"},{"doc":"cardano/addresses","title":"cardano/addresses","content":" This module incorporates code for generating valid wallet and script \n addresses, ensuring their correctness. Empty keys are treated as \n intentional, and address subtypes are not combined nor mixed. The key\n lengths must be valid as these functions will ignore invalid key\n keys when generating Address types.\n","url":"cardano/addresses.html"},{"doc":"types/cip68","title":"get","content":"get(cip68: CIP68, key: Data) -&gt; Data\n Attempt to find a data structure by a key inside the cip68 metadatum. If\n nothing is found then fail.\n\n ```aiken\n cip68.get(metadatum, some_key)\n ```","url":"types/cip68.html#get"},{"doc":"types/cip68","title":"version","content":"version(metadata: CIP68) -&gt; Int\n Return the version of the metadata.\n\n ```aiken\n metadatum |&gt; cip68.version\n ```","url":"types/cip68.html#version"},{"doc":"types/cip68","title":"CIP68","content":"CIP68 {\n  metadata: Pairs&lt;Data, Data&gt;,\n  version: Int,\n}\n The generic CIP68 metadatum type as defined in the CIP at\n https://cips.cardano.org/cips/cip68/.\nCIP68 { metadata: Pairs&lt;Data, Data&gt;, version: Int }\n","url":"types/cip68.html#CIP68"},{"doc":"types/cip68","title":"prefix_100","content":"prefix_100: ByteArray = #&quot;000643b0&quot;\n (100) Reference Token Prefix\n https://developers.cardano.org/docs/governance/cardano-improvement-proposals/cip-0068/#222-nft-standard","url":"types/cip68.html#prefix_100"},{"doc":"types/cip68","title":"prefix_222","content":"prefix_222: ByteArray = #&quot;000de140&quot;\n (222) Non-Fungible Token Prefix\n https://developers.cardano.org/docs/governance/cardano-improvement-proposals/cip-0068/#222-nft-standard","url":"types/cip68.html#prefix_222"},{"doc":"types/cip68","title":"prefix_333","content":"prefix_333: ByteArray = #&quot;0014df10&quot;\n (333) Fungible Token Prefix\n https://developers.cardano.org/docs/governance/cardano-improvement-proposals/cip-0068/#333-ft-standard","url":"types/cip68.html#prefix_333"},{"doc":"types/cip68","title":"prefix_444","content":"prefix_444: ByteArray = #&quot;001bc280&quot;\n (444) Rich-Fungible Token Prefix\n https://developers.cardano.org/docs/governance/cardano-improvement-proposals/cip-0068/#333-ft-standard","url":"types/cip68.html#prefix_444"},{"doc":"types/cip68","title":"types/cip68","content":"","url":"types/cip68.html"},{"doc":"types/prefixes","title":"callable","content":"callable: ByteArray = #&quot;ca11ab1e&quot;\n Callable Token Prefix","url":"types/prefixes.html#callable"},{"doc":"types/prefixes","title":"database","content":"database: ByteArray = #&quot;da7aba5e&quot;\n Database Token Prefix","url":"types/prefixes.html#database"},{"doc":"types/prefixes","title":"seed","content":"seed: ByteArray = #&quot;5eed0e1f&quot;\n Seed Token Prefix","url":"types/prefixes.html#seed"},{"doc":"types/prefixes","title":"types/prefixes","content":" This module provides token prefixes for labeling unique tokens.\n","url":"types/prefixes.html"},{"doc":"types/token","title":"negative","content":"negative(tkn: Token) -&gt; Token\n Give the negative of a token.\n\n ```aiken\n token.negative(this_token)\n ```","url":"types/token.html#negative"},{"doc":"types/token","title":"negate","content":"negate(tokens: Tokens) -&gt; Tokens\n Negate all the tokens in the list.\n\n ```aiken\n token.negate(these_tokens)\n ```","url":"types/token.html#negate"},{"doc":"types/token","title":"divide","content":"divide(token: Token, n: Int) -&gt; Token\n Divide a token by some integer. The divisor must be positive. This is\n integer division so the token amount will be rounded towards negative \n infinity.\n\n ```aiken\n token.divide(that_token, 2)\n ```","url":"types/token.html#divide"},{"doc":"types/token","title":"multiply","content":"multiply(token: Token, n: Int) -&gt; Token\n Multiply a token by some integer. This linearly scales the token amount\n on the token.\n\n ```aiken\n token.multiply(that_token, 4)\n ```","url":"types/token.html#multiply"},{"doc":"types/token","title":"subtraction_only","content":"subtraction_only(tokens: Tokens) -&gt; Bool\n Check that each token is less than zero in a list tokens.\n\n ```aiken\n token.subtraction_only(redeemer.tokens)\n ```","url":"types/token.html#subtraction_only"},{"doc":"types/token","title":"addition_only","content":"addition_only(tokens: Tokens) -&gt; Bool\n Check that each token is greater than zero in a list tokens.\n\n ```aiken\n token.addition_only(redeemer.tokens)\n ```","url":"types/token.html#addition_only"},{"doc":"types/token","title":"add_token_to_value","content":"add_token_to_value(the_value: Value, token: Token) -&gt; Value\n Add a Token type to a Value type. This should be a very safe way to\n increment a value on a UTxO. The other option is having the redeemer be \n the general Value type and potentially allow badly formed values to be used.\n\n ```aiken\n add_token_to_value(token, this_value)\n ```","url":"types/token.html#add_token_to_value"},{"doc":"types/token","title":"add_tokens_to_value","content":"add_tokens_to_value(the_value: Value, tokens: Tokens) -&gt; Value\n Add a list of Token types to a Value type. This should be a very safe way to\n increment a value on a UTxO. The other option is having the redeemer be \n the general Value type and potentially allow badly formed values to be used.\n\n ```aiken\n add_tokens_to_value(redeemer.tokens, this_value)\n ```","url":"types/token.html#add_tokens_to_value"},{"doc":"types/token","title":"from_value","content":"from_value(v: Value) -&gt; Tokens\n Convert a value into a list of tokens. This conversation is a fast way\n to be able to do multiplication on a assets.\n\n ```aiken\n token.from_value(this_value)\n ```","url":"types/token.html#from_value"},{"doc":"types/token","title":"exists","content":"exists(total: Tokens, target: Token) -&gt; Bool\n Check if a Token exists in a list of Tokens. The amount has to be greater\n than or equal to the target.\n\n ```aiken\n token.exists(total_tokens, target_token )\n ```","url":"types/token.html#exists"},{"doc":"types/token","title":"contains","content":"contains(total: Tokens, target: Tokens) -&gt; Bool\n Check if a target list of tokens exist inside another list of tokens.\n The token amount must be greater than or equal to the target amount. If\n nothing is found then it returns False.\n\n ```aiken\n token.contains(total, target)\n ```","url":"types/token.html#contains"},{"doc":"types/token","title":"Token","content":"Token {\n  pid: PolicyId,\n  tkn: AssetName,\n  amt: Int,\n}\n A token type for a safe single policy id and asset name assets.\nToken { pid: PolicyId, tkn: AssetName, amt: Int }\n","url":"types/token.html#Token"},{"doc":"types/token","title":"Tokens","content":"Tokens = List&lt;Token&gt;\n A tokens type for a safe value as a list of Tokens.\n","url":"types/token.html#Tokens"},{"doc":"types/token","title":"types/token","content":" A Token is a safe type for some asset on Cardano. A Token can be combined\n with another Token to form Tokens, a list of Token.  This should be a safe\n and clean way to build out the value type inside of datums and redeemers \n instead of building out the value type directly which could be harmful.\n","url":"types/token.html"},{"doc":"cardano/value","title":"from_token","content":"from_token(token: Token) -&gt; Value\n Creates a Value type from a token.\n\n ```aiken\n values.from_token(this_token)\n ```","url":"cardano/value.html#from_token"},{"doc":"cardano/value","title":"from_tokens","content":"from_tokens(tokens: Tokens) -&gt; Value\n Creates a Value type from a list of tokens.\n\n ```aiken\n values.from_tokens(redeemer.tokens)\n ```","url":"cardano/value.html#from_tokens"},{"doc":"cardano/value","title":"multiply","content":"multiply(val: Value, n: Int) -&gt; Value\n Multiply some value by `n`. This is just a linear scaling to the quantity\n of each token.\n\n ```aiken\n values.multiply(bundle_value, bundle_size)\n ```","url":"cardano/value.html#multiply"},{"doc":"cardano/value","title":"contains","content":"contains(total: Value, target: Value) -&gt; Bool\n Prove that the target value is contained inside another assets. Each token\n inside the target must exist inside the total assets. The quantity of each\n token must be at least the target amount or greater.\n\n ```aiken\n values.contains(total_value, target_value)\n ```","url":"cardano/value.html#contains"},{"doc":"cardano/value","title":"compute_hash","content":"compute_hash(target: Value) -&gt; ByteArray\n Compute the sha3_256 hash of a value by merklizing the policy id, asset\n name, and quantity. Empty values return the empty by string.\n\n ```aiken\n values.compute_hash(validating_value)\n ```","url":"cardano/value.html#compute_hash"},{"doc":"cardano/value","title":"unique_token_name","content":"unique_token_name(txid: TransactionId, idx: Int, prefix: ByteArray) -&gt; AssetName\n Calculate a unique token name from a `TxId#Idx` and prefix. Can be combined\n with the `find` module to create unique token names from the first input\n utxo inside the transaction.\n\n ```aiken\n values.unique_token_name(tx_id, tx_idx, cip68.prefix_333)\n ```","url":"cardano/value.html#unique_token_name"},{"doc":"cardano/value","title":"prove_nft","content":"prove_nft(total: Value, pid: PolicyId) -&gt; Bool\n Proves that inside some value there is a policy id with a single token\n name that has a quantity of 1. This will show that a value contains an\n NFT or something that is nft-like. Should be useful to prove that\n something is holding a token inside a transaction when the token name\n is assumed to be unique.\n\n ```aiken\n values.prove_nft(this_value, pid)\n ```","url":"cardano/value.html#prove_nft"},{"doc":"cardano/value","title":"prove_exact_nft","content":"prove_exact_nft(\n  total_value: Value,\n  nft_pid: PolicyId,\n  nft_tkn: AssetName,\n) -&gt; Bool\n Proves that inside some value there is a policy id with token\n name that has a quantity of 1. This will show that a value contains an\n NFT or something that is nft-like. Should be useful to prove that\n something is holding a token inside a transaction when the policy id and\n token name is known.\n\n ```aiken\n values.prove_exact_nft(that_value, pid, tkn)\n ```","url":"cardano/value.html#prove_exact_nft"},{"doc":"cardano/value","title":"cardano/value","content":" This module contains code that aids in various value \n manipulations and comparisons.\n","url":"cardano/value.html"},{"doc":"cardano/certificates","title":"delegate_credential","content":"delegate_credential(sc: ScriptHash, pool_id: StakePoolId) -&gt; Certificate\n Creates a credential delegation for changing the location of the stake.\n This certificate can be used to check if stake is being delegated to\n a specific pool.\n\n ```aiken\n certificates.create_credential_delegation(datum.contract_hash, datum.pool_id)\n ```","url":"cardano/certificates.html#delegate_credential"},{"doc":"cardano/certificates","title":"cardano/certificates","content":" This module incorporates code for generating valid certificates,\n ensuring their correctness. \n","url":"cardano/certificates.html"},{"doc":"tests/fake_tx","title":"test_out_ref","content":"test_out_ref() -&gt; OutputReference\n Creates an `OutputReference`","url":"tests/fake_tx.html#test_out_ref"},{"doc":"tests/fake_tx","title":"test_bad_out_ref","content":"test_bad_out_ref() -&gt; OutputReference\n Creates an `OutputReference`","url":"tests/fake_tx.html#test_bad_out_ref"},{"doc":"tests/fake_tx","title":"test_inputs","content":"test_inputs(amt: Int) -&gt; List&lt;Input&gt;\n A fake input used for testing.","url":"tests/fake_tx.html#test_inputs"},{"doc":"tests/fake_tx","title":"test_input","content":"test_input() -&gt; Input\n A fake input used for testing.","url":"tests/fake_tx.html#test_input"},{"doc":"tests/fake_tx","title":"test_script_input","content":"test_script_input() -&gt; Input\n A fake input used for testing.","url":"tests/fake_tx.html#test_script_input"},{"doc":"tests/fake_tx","title":"test_input_with_datum_hash","content":"test_input_with_datum_hash() -&gt; Input\n A fake input with a datum hash.","url":"tests/fake_tx.html#test_input_with_datum_hash"},{"doc":"tests/fake_tx","title":"test_bad_input","content":"test_bad_input() -&gt; Input\n A fake input without datum used for testing.","url":"tests/fake_tx.html#test_bad_input"},{"doc":"tests/fake_tx","title":"test_one_lovelace_input","content":"test_one_lovelace_input() -&gt; Input\n","url":"tests/fake_tx.html#test_one_lovelace_input"},{"doc":"tests/fake_tx","title":"test_bad_inputs","content":"test_bad_inputs() -&gt; List&lt;Input&gt;\n","url":"tests/fake_tx.html#test_bad_inputs"},{"doc":"tests/fake_tx","title":"test_output","content":"test_output() -&gt; Output\n A fake output used for testing.","url":"tests/fake_tx.html#test_output"},{"doc":"tests/fake_tx","title":"test_output_with_datum_hash","content":"test_output_with_datum_hash() -&gt; Output\n","url":"tests/fake_tx.html#test_output_with_datum_hash"},{"doc":"tests/fake_tx","title":"test_bad_output","content":"test_bad_output() -&gt; Output\n A fake output without datum used for testing.","url":"tests/fake_tx.html#test_bad_output"},{"doc":"tests/fake_tx","title":"test_bad_outputs","content":"test_bad_outputs() -&gt; List&lt;Output&gt;\n","url":"tests/fake_tx.html#test_bad_outputs"},{"doc":"tests/fake_tx","title":"test_signatories","content":"test_signatories() -&gt; List&lt;ByteArray&gt;\n A fake list of tx signers","url":"tests/fake_tx.html#test_signatories"},{"doc":"tests/fake_tx","title":"test_tx","content":"test_tx() -&gt; Transaction\n A fake transaction used for testing.","url":"tests/fake_tx.html#test_tx"},{"doc":"tests/fake_tx","title":"DataType","content":"DataType = Data\n A `Data`data type\n","url":"tests/fake_tx.html#DataType"},{"doc":"tests/fake_tx","title":"test_datum","content":"test_datum: ByteArray = #&quot;acabbeeffacecafe&quot;\n A test datum.","url":"tests/fake_tx.html#test_datum"},{"doc":"tests/fake_tx","title":"tests/fake_tx","content":" This is for testing only.\n","url":"tests/fake_tx.html"},{"doc":"cardano/minting","title":"exact","content":"exact(\n  flat: List&lt;(PolicyId, AssetName, Int)&gt;,\n  pid: PolicyId,\n  tkn: AssetName,\n  amt: Int,\n) -&gt; Bool\n This checks if a specific policy id, token name, and amount exist inside\n the flattened exact assets. It is searching for an exact match. If found\n then it returns True else False.\n\n ```aiken\n minting.exact(flatten_mint_value, pid, tkn, 1)\n ```","url":"cardano/minting.html#exact"},{"doc":"cardano/minting","title":"by_prefix","content":"by_prefix(\n  flat: List&lt;(PolicyId, AssetName, Int)&gt;,\n  pid: PolicyId,\n  prefix: AssetName,\n  amt: Int,\n) -&gt; Bool\n This checks if a specific policy id, prefix, and amount exist inside\n the flattened exact assets. Instead of searching for exact match, it\n checks if the token name has the correct prefix. This works if\n every token name on the policy id is unique. If found then it returns\n True else False.\n\n ```aiken\n minting.by_prefix(flatten_mint_value, pid, tkn, 1)\n ```","url":"cardano/minting.html#by_prefix"},{"doc":"cardano/minting","title":"is_occurring","content":"is_occurring(\n  flat: List&lt;(PolicyId, AssetName, Int)&gt;,\n  pid: PolicyId,\n  tkn: AssetName,\n) -&gt; Bool\n Prove that a transaction is minting something from a specific policy id \n and token name but the amount does not matter. This is great for lock-n-mint\n style contracts where some logic just needs to check if a mint is occuring\n but not the specifics of the amount being minted or burned. If a mint is\n occurring then it will return True else False.\n\n ```aiken\n minting.is_occurring(flatten_mint_value, pid, tkn)\n ```","url":"cardano/minting.html#is_occurring"},{"doc":"cardano/minting","title":"cardano/minting","content":" This module incorporates code for various minting and burning validations.\n","url":"cardano/minting.html"},{"doc":"types/wallet","title":"to_vks","content":"to_vks(wallets: Wallets) -&gt; List&lt;VerificationKeyHash&gt;\n Convert a list of wallets into a list of public key hashes. This is useful\n when doing multisig validation. The output order respects the input order.\n\n ```aiken\n wallet.to_vks(datum.wallets)\n ```","url":"types/wallet.html#to_vks"},{"doc":"types/wallet","title":"is_valid","content":"is_valid(wallet: Wallet) -&gt; Bool\n Check if a wallet has a bad form and needs to be bypassed.\n The pkh must be the length 56 hex string and the sc is either empty or\n it is also a length 56 hex string.\n\n ```aiken\n wallet.is_valid(datum.wallet)\n ```","url":"types/wallet.html#is_valid"},{"doc":"types/wallet","title":"Wallet","content":"Wallet {\n  pkh: VerificationKeyHash,\n  sc: VerificationKeyHash,\n}\n A wallet type for a non-smart contract address.\nWallet { pkh: VerificationKeyHash, sc: VerificationKeyHash }\n","url":"types/wallet.html#Wallet"},{"doc":"types/wallet","title":"Wallets","content":"Wallets = List&lt;Wallet&gt;\n A list of wallets for non-smart contract addresses.\n","url":"types/wallet.html#Wallets"},{"doc":"types/wallet","title":"types/wallet","content":"","url":"types/wallet.html"},{"doc":"maths/constants","title":"large_prime","content":"large_prime: Int = 0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab\n A large prime number. The value is near 4 x 10^114.","url":"maths/constants.html#large_prime"},{"doc":"maths/constants","title":"maths/constants","content":"","url":"maths/constants.html"}]);