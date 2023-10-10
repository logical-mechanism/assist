window.Aiken.initSearch([{"doc":"assist/maths","title":"base_q","content":"base_q(n: Int, q: Int) -&gt; List&lt;Int&gt;\n Convert a integer `n` into some base `q`. This method\n should scale with any integer and any logical base.\n\n ```aiken\n maths.base_q(123, 7)\n ```","url":"assist/maths.html#base_q"},{"doc":"assist/maths","title":"decay","content":"decay(start_amt: Int, scale: Int, num: Int) -&gt; Int\n Decay some starting amount logarithmically until zero. The function evaluates\n `y = a - log(n)` and when `n &gt;= 2^a` the function equals zero but will return\n zero whenever the result is less than the scale. This is a great\n way to reduce some integer amount of something over time by incrementing `n`.\n\n ```aiken\n maths.decay(start_amount, lovelace_scaling, datum.current_int)\n ```","url":"assist/maths.html#decay"},{"doc":"assist/maths","title":"effective_ratio","content":"effective_ratio(amt: Int, pct: Int, scale: Int) -&gt; Int\n Calculates the ratio of the amount `amt` multiplied by the scale by the\n percentage `pct`. The scale allows for finer calculations.\n\n ```aiken\n maths.effective_ratio(123456789, 40, 1000) == 3086419725\n ```","url":"assist/maths.html#effective_ratio"},{"doc":"assist/maths","title":"from_int","content":"from_int(self: Int) -&gt; ByteArray\n Convert a integer into a hexadecimal bytearray. This works for all integers\n but odd length bytearrays will be prefixed with a zero. This function \n combined with the `to_int` function allows a string to represent a number\n and still be used for calculations, pushing the `2^64 - 1` integer boundary\n to `2^256 - 1`.\n\n ```aiken\n maths.from_int(44203)\n ```","url":"assist/maths.html#from_int"},{"doc":"assist/maths","title":"gcd","content":"gcd(a: Int, b: Int) -&gt; Int\n Computes greatest common divisor of two numbers.\n\n ```aiken\n maths.gcd(20, 15)\n ```","url":"assist/maths.html#gcd"},{"doc":"assist/maths","title":"is_in_range","content":"is_in_range(n: Int, lb: Int, ub: Int) -&gt; Bool\n Verify that some integer `n` is greater than the lower bound, `lb`, and\n less than or equal to the upper bound, `ub`. The function is exclusive\n for `lb` but inclusive for `lb + 1`.\n\n ```aiken\n maths.is_in_range(5, 0, 10)\n ```","url":"assist/maths.html#is_in_range"},{"doc":"assist/maths","title":"legendre_symbol","content":"legendre_symbol(a: Int, p: Int) -&gt; Int\n Calculate the Legendre symbol `(a/p)` using the Euler&#39;s criterion.\n This implementation assumes that &#39;a&#39; and &#39;p&#39; are positive integers.\n\n ```aiken\n maths.legendre_symbol(10, 19)\n ```","url":"assist/maths.html#legendre_symbol"},{"doc":"assist/maths","title":"list_powmod","content":"list_powmod(lst: List&lt;Int&gt;, g: Int, q: Int) -&gt; Int\n Computes the power mod product of a list of integers.\n\n ```aiken\n maths.list_pow_mod([1,2,3], 2, 19)\n ```","url":"assist/maths.html#list_powmod"},{"doc":"assist/maths","title":"list_product","content":"list_product(lst: List&lt;Int&gt;) -&gt; Int\n Computes the product of a list of integers.\n\n ```aiken\n maths.list_product([1,2,3])\n ```","url":"assist/maths.html#list_product"},{"doc":"assist/maths","title":"list_sum","content":"list_sum(lst: List&lt;Int&gt;) -&gt; Int\n Computes the sum of a list of integers.\n\n ```aiken\n maths.list_sum(list_of_integers)\n ```","url":"assist/maths.html#list_sum"},{"doc":"assist/maths","title":"powmod","content":"powmod(n: Int, e: Int, q: Int) -&gt; Int\n Calculate `n` to the power of `e` modulo `q` using the exponentiation by \n squaring method. At each multiplication a modulo is calculated, allowing\n very large `n` and `e` values.\n\n ```aiken\n maths.powmod(3, 2, 5)\n ```","url":"assist/maths.html#powmod"},{"doc":"assist/maths","title":"ratio","content":"ratio(amt: Int, pct: Int) -&gt; Int\n Calculates the ratio of the amount `amt` by a percentage `pct`. This can\n be used to calculate rough percentages. The function `ratio` is just a \n special case of the effective ratio function. \n\n ```aiken\n maths.ratio(123, 40)\n ```","url":"assist/maths.html#ratio"},{"doc":"assist/maths","title":"scaling","content":"scaling(amt: Int, pct: Int) -&gt; Int\n Find the optimal scaling for a number such that it\n has three trailing zeros. This should be used in combination\n with the effective ratio for optimal calculations.\n\n ```aiken\n maths.scaling(123, 40)\n ```","url":"assist/maths.html#scaling"},{"doc":"assist/maths","title":"to_int","content":"to_int(self: ByteArray) -&gt; Int\n Convert a hexadecimal bytearray into its base 10 representation. This\n only works with even length bytearrays so arbitrary numbers in hexadecimal\n form will not in general work.\n\n ```aiken\n maths.to_int(#&quot;acab&quot;)\n ```","url":"assist/maths.html#to_int"},{"doc":"assist/maths","title":"assist/maths","content":" This module incorporates code for various mathematical operations.\n","url":"assist/maths.html"},{"doc":"assist/addresses","title":"create_address","content":"create_address(\n  pkh: Hash&lt;Blake2b_224, VerificationKey&gt;,\n  sc: Hash&lt;Blake2b_224, VerificationKey&gt;,\n) -&gt; Address\n Creates a enterprise or base address from the public key hash and stake\n credential. An empty sc means enterpise address by default.\n\n ```aiken\n addresses.create_address(datum.wallet.pkh, datum.wallet.sc)\n ```","url":"assist/addresses.html#create_address"},{"doc":"assist/addresses","title":"create_script_address","content":"create_script_address(\n  pkh: Hash&lt;Blake2b_224, Script&gt;,\n  sc: Hash&lt;Blake2b_224, Script&gt;,\n) -&gt; Address\n Creates a script address for a smart contract. The type does not mix address\n types. Staked smart contracts are contracts as well. An empty sc is\n assumed to be not staked.\n\n ```aiken\n addresses.create_script_address(datum.script.pkh, datum.script.sc)\n ```","url":"assist/addresses.html#create_script_address"},{"doc":"assist/addresses","title":"assist/addresses","content":" This module incorporates code for generating valid wallet and script \n addresses, ensuring their correctness. Empty keys are treated as \n intentional, and address subtypes are not combined or mixed.\n","url":"assist/addresses.html"},{"doc":"assist/count","title":"inputs_by_addr","content":"inputs_by_addr(inputs: List&lt;Input&gt;, addr: Address, amount: Int) -&gt; Bool\n Verify that the number of inputs from a specific script is equal to the\n amount intended in the contract. The amount must be exactly the counter.\n\n ```aiken\n count.inputs_by_addr(tx.inputs, this_addr, 1)\n ```","url":"assist/count.html#inputs_by_addr"},{"doc":"assist/count","title":"inputs_by_datum","content":"inputs_by_datum(inputs: List&lt;Input&gt;, amount: Int) -&gt; Bool\n Verify that the number of inputs with an inline datum is equal to the\n number intended in the contract. The amount must be exactly the counter.\n\n ```aiken\n count.inputs_by_datum(tx.inputs, 1)\n ```","url":"assist/count.html#inputs_by_datum"},{"doc":"assist/count","title":"outputs_by_addr","content":"outputs_by_addr(outputs: List&lt;Output&gt;, addr: Address, amount: Int) -&gt; Bool\n Verify that the number of outputs from a specific script is equal the amount\n intended in the contract. The amount must be exact with the counter.\n\n ```aiken\n count.outputs_by_addr(tx.outputs, this_addr, 1)\n ```","url":"assist/count.html#outputs_by_addr"},{"doc":"assist/count","title":"outputs_by_datum","content":"outputs_by_datum(outputs: List&lt;Output&gt;, amount: Int) -&gt; Bool\n Verify that the number of outputs with an inline datum is equal to the\n number intended in the contract. The amount must be exactly the counter.\n\n ```aiken\n count.outputs_by_datum(tx.outputs, 1)\n ```","url":"assist/count.html#outputs_by_datum"},{"doc":"assist/count","title":"assist/count","content":" This module contains code to accurately count the number of inputs and\n outputs in a transaction for a specific address, assuming precise amounts.\n","url":"assist/count.html"},{"doc":"assist/signing","title":"verify_multisig","content":"verify_multisig(\n  sigs: List&lt;Hash&lt;Blake2b_224, VerificationKey&gt;&gt;,\n  vks: List&lt;Hash&lt;Blake2b_224, VerificationKey&gt;&gt;,\n  minimum: Int,\n) -&gt; Bool\n This counts the number of signatures inside a transaction that are from \n the list of signers then checks if its at least the minimum amount.\n\n ```aiken\n signing.verify_multisig(context.transaction, lst_of_sigs, sig_threshold)\n ```","url":"assist/signing.html#verify_multisig"},{"doc":"assist/signing","title":"verify_sig","content":"verify_sig(\n  vks: List&lt;Hash&lt;Blake2b_224, VerificationKey&gt;&gt;,\n  vk: Hash&lt;Blake2b_224, VerificationKey&gt;,\n) -&gt; Bool\n Check if the list of signatures inside a transaction contains the\n verification key.\n\n ```aiken\n signing.verify_sig(context.transaction, wallet_pkh)\n ```","url":"assist/signing.html#verify_sig"},{"doc":"assist/signing","title":"assist/signing","content":" This module contains code for verifying transaction signatures. \n It assumes that all signatures provided are verification keys.\n","url":"assist/signing.html"},{"doc":"assist/minting","title":"by_prefix","content":"by_prefix(\n  flat: List&lt;(ByteArray, ByteArray, Int)&gt;,\n  pid: ByteArray,\n  prefix: ByteArray,\n  amt: Int,\n) -&gt; Bool\n This checks if a specific policy id, prefix, and amount exist inside\n the flattened exact value. Instead of searching for exact match, it\n checks if the token name has the correct prefix. This works if\n every token name on the policy id is unique. If found then it returns\n True else False.\n\n ```aiken\n minting.by_prefix(flatten_mint_value, pid, tkn, 1)\n ```","url":"assist/minting.html#by_prefix"},{"doc":"assist/minting","title":"exact","content":"exact(\n  flat: List&lt;(ByteArray, ByteArray, Int)&gt;,\n  pid: ByteArray,\n  tkn: ByteArray,\n  amt: Int,\n) -&gt; Bool\n This checks if a specific policy id, token name, and amount exist inside\n the flattened exact value. It is searching for an exact match. If found\n then it returns True else False.\n\n ```aiken\n minting.exact(flatten_mint_value, pid, tkn, 1)\n ```","url":"assist/minting.html#exact"},{"doc":"assist/minting","title":"is_occurring","content":"is_occurring(\n  flat: List&lt;(ByteArray, ByteArray, Int)&gt;,\n  pid: ByteArray,\n  tkn: ByteArray,\n) -&gt; Bool\n Prove that a transaction is minting something from a specific policy id \n and token name but the amount does not matter. This is great for lock-n-mint\n style contracts where some logic just needs to check if a mint is occuring\n but not the specifics of the amount being minted or burned. If a mint is\n occurring then it will return True else False.\n\n ```aiken\n minting.is_occurring(flatten_mint_value, pid, tkn)\n ```","url":"assist/minting.html#is_occurring"},{"doc":"assist/minting","title":"assist/minting","content":"","url":"assist/minting.html"},{"doc":"assist/payout","title":"at_least","content":"at_least(\n  payout_address: Address,\n  payout_value: Value,\n  outputs: List&lt;Output&gt;,\n) -&gt; Bool\n Find the first occurrence of an output that contains at least some specific\n value at some address. If nothing is found then return False. This function\n does not search for an exact UTxO match.\n\n ```aiken\n payout.at_least(wallet_addr, just_token_value, tx.outputs)\n ```","url":"assist/payout.html#at_least"},{"doc":"assist/payout","title":"cont","content":"cont(payout_address: Address, outputs: List&lt;Output&gt;) -&gt; Bool\n Find the first occurrence of an output at some address. If nothing is \n found then return False. This function does not search by value.\n\n ```aiken\n payout.cont(that_script_addr, tx.outputs)\n ```","url":"assist/payout.html#cont"},{"doc":"assist/payout","title":"exact","content":"exact(\n  payout_address: Address,\n  payout_value: Value,\n  outputs: List&lt;Output&gt;,\n) -&gt; Bool\n Find the first occurrence of an exact output that matches a specific\n address and value. If nothing is found then return False.\n\n ```aiken\n payout.exact(wallet_addr, validating_value, tx.outputs)\n ```","url":"assist/payout.html#exact"},{"doc":"assist/payout","title":"assist/payout","content":" This module contains code that assists with payout logic. Payout\n functions are designed to return a boolean value instead of an error.\n","url":"assist/payout.html"},{"doc":"assist/std","title":"out_ref","content":"out_ref(tx_id_hash: ByteArray, idx: Int) -&gt; OutputReference\n Create an `OutputReference` from the `TxId#Idx` information. This is useful\n for building correct output references of specific UTxOs. It can be combined\n with the `find` module for some very convenient requests.\n\n ```aiken\n std.out_ref(that_tx_id, that_tx_idx)\n ```","url":"assist/std.html#out_ref"},{"doc":"assist/std","title":"assist/std","content":" This module incorporates additional code that expands the\n functionality of the standard library.\n","url":"assist/std.html"},{"doc":"assist/prefixes","title":"prefix_100","content":"prefix_100: ByteArray = #&quot;000643b0&quot;\n (100) Reference Token Prefix","url":"assist/prefixes.html#prefix_100"},{"doc":"assist/prefixes","title":"prefix_222","content":"prefix_222: ByteArray = #&quot;000de140&quot;\n (222) Non-Fungible Token Prefix","url":"assist/prefixes.html#prefix_222"},{"doc":"assist/prefixes","title":"prefix_333","content":"prefix_333: ByteArray = #&quot;0014df10&quot;\n (333) Fungible Token Prefix","url":"assist/prefixes.html#prefix_333"},{"doc":"assist/prefixes","title":"prefix_444","content":"prefix_444: ByteArray = #&quot;001bc280&quot;\n (444) Rich-Fungible Token Prefix","url":"assist/prefixes.html#prefix_444"},{"doc":"assist/prefixes","title":"prefix_callable","content":"prefix_callable: ByteArray = #&quot;ca11ab1e&quot;\n Callable Token Prefix","url":"assist/prefixes.html#prefix_callable"},{"doc":"assist/prefixes","title":"prefix_database","content":"prefix_database: ByteArray = #&quot;da7aba5e&quot;\n Database Token Prefix","url":"assist/prefixes.html#prefix_database"},{"doc":"assist/prefixes","title":"assist/prefixes","content":" This module provides the currently accepted token prefixes.\n","url":"assist/prefixes.html"},{"doc":"assist/certificates","title":"create_credential_delegation","content":"create_credential_delegation(\n  sc: Hash&lt;Blake2b_224, Script&gt;,\n  pool_id: PoolId,\n) -&gt; Certificate\n Creates a credential delegation for changing the location of the stake.\n This certificate can be used to check if stake is being delegated to\n a specific pool.\n\n ```aiken\n certificates.create_credential_delegation(datum.contract_hash, datum.pool_id)\n ```","url":"assist/certificates.html#create_credential_delegation"},{"doc":"assist/certificates","title":"assist/certificates","content":"","url":"assist/certificates.html"},{"doc":"assist/find","title":"first_input_index","content":"first_input_index(inputs: List&lt;Input&gt;) -&gt; Int\n Find the first input&#39;s output reference index.\n Output references have the form `TxId#Idx`, this function\n extracts the `Idx` part. If nothing is found then error.\n\n ```aiken\n find.first_input_index(tx.inputs)\n ```","url":"assist/find.html#first_input_index"},{"doc":"assist/find","title":"first_input_txid","content":"first_input_txid(inputs: List&lt;Input&gt;) -&gt; ByteArray\n Find the first input&#39;s output reference transaction id hash.\n Output references have the form `TxId#Idx`, this function\n extracts the `TxId` part. If nothing is found then error.\n\n ```aiken\n find.first_input_txid(tx.inputs)\n ```","url":"assist/find.html#first_input_txid"},{"doc":"assist/find","title":"first_output_datum","content":"first_output_datum(outputs: List&lt;Output&gt;) -&gt; Data\n Find the first output with an inline datum and return the data.\n If nothing is found then error. This works great for tx with a\n single output and datum or where ordering is irrelevant.\n\n ```aiken\n find.first_output_datum(tx.outputs)\n ```","url":"assist/find.html#first_output_datum"},{"doc":"assist/find","title":"input_by_addr","content":"input_by_addr(inputs: List&lt;Input&gt;, addr: Address) -&gt; Input\n Find the first occurrence of an input by a specific address. If nothing\n is found then error. The address here is an exact match, so both the\n pkh and sc need to be correct.\n\n ```aiken\n find.input_by_addr(tx.reference_inputs, ref_addr)\n ```","url":"assist/find.html#input_by_addr"},{"doc":"assist/find","title":"input_by_ref","content":"input_by_ref(inputs: List&lt;Input&gt;, out_ref: OutputReference) -&gt; Input\n Find an input by an output reference. If nothing is found then error. \n Similar to the builtin function in stdlib but auto errors instead of\n returning an `Option`.\n\n ```aiken\n find.input_by_ref(tx.inputs, out_ref)\n ```","url":"assist/find.html#input_by_ref"},{"doc":"assist/find","title":"output_by_addr","content":"output_by_addr(outputs: List&lt;Output&gt;, addr: Address) -&gt; Output\n Find the first occurrence of an output by a specific address. If nothing\n is found then error. The address here is an exact match.\n\n ```aiken\n find.output_by_addr(tx.outputs, your_address)\n ```","url":"assist/find.html#output_by_addr"},{"doc":"assist/find","title":"output_by_addr_value","content":"output_by_addr_value(\n  outputs: List&lt;Output&gt;,\n  addr: Address,\n  value: Value,\n) -&gt; Output\n Return the first occurrence of an output that contains at least some specific\n value at some address. If nothing is found then error. This function\n does not search for an exact UTxO match.\n\n ```aiken\n find.output_by_addr_value(tx.outputs, wallet_addr, just_token_value)\n ```","url":"assist/find.html#output_by_addr_value"},{"doc":"assist/find","title":"output_by_value","content":"output_by_value(outputs: List&lt;Output&gt;, value: Value) -&gt; Output\n Return the first occurrence of an output that contains at least some specific\n value. If nothing is found then error. This function\n does not search for an exact UTxO match.\n\n ```aiken\n find.output_by_value(tx.outputs, just_token_value)\n ```","url":"assist/find.html#output_by_value"},{"doc":"assist/find","title":"output_datum_by_addr","content":"output_datum_by_addr(outputs: List&lt;Output&gt;, addr: Address) -&gt; Data\n Find the first occurence of output datum by some address. If nothing is\n found then error.\n\n ```aiken\n expect datum: Datum = find.output_datum_by_addr(tx.outputs, this_addr)\n ```","url":"assist/find.html#output_datum_by_addr"},{"doc":"assist/find","title":"redeemer_by_ref","content":"redeemer_by_ref(\n  redeemers: Dict&lt;ScriptPurpose, Redeemer&gt;,\n  out_ref: OutputReference,\n) -&gt; Data\n Find a redeemer data by an output reference. This is good for checking\n if a specific redeemer is being used on some specific UTxO inside \n the transaction.\n\n ```aiken\n find.redeemer_by_ref(tx.redeemers, that_out_ref)\n ```","url":"assist/find.html#redeemer_by_ref"},{"doc":"assist/find","title":"stake_reward_by_sc","content":"stake_reward_by_sc(\n  withdraws: Dict&lt;StakeCredential, Int&gt;,\n  stake_credential: StakeCredential,\n) -&gt; Int\n Find the staking reward amount in loveace for some stake credential.\n If no rewards are available then error. This is a great method for\n checking on-chain staking rewards and withdrawal validation.\n\n ```aiken\n find.stake_reward_by_sc(tx.withdrawals, datum.wallet.sc)\n ```","url":"assist/find.html#stake_reward_by_sc"},{"doc":"assist/find","title":"assist/find","content":" This module contains code for identifying various aspects of \n a validating transaction.\n","url":"assist/find.html"},{"doc":"tests/fake_tx","title":"test_input","content":"test_input() -&gt; Input\n A fake input used for testing.","url":"tests/fake_tx.html#test_input"},{"doc":"tests/fake_tx","title":"test_inputs","content":"test_inputs(amt: Int) -&gt; List&lt;Input&gt;\n A fake input used for testing.","url":"tests/fake_tx.html#test_inputs"},{"doc":"tests/fake_tx","title":"test_out_ref","content":"test_out_ref() -&gt; OutputReference\n Creates an `OutputReference`","url":"tests/fake_tx.html#test_out_ref"},{"doc":"tests/fake_tx","title":"test_output","content":"test_output() -&gt; Output\n A fake output used for testing.","url":"tests/fake_tx.html#test_output"},{"doc":"tests/fake_tx","title":"test_signatories","content":"test_signatories() -&gt; List&lt;ByteArray&gt;\n A fake list of tx signers","url":"tests/fake_tx.html#test_signatories"},{"doc":"tests/fake_tx","title":"test_tx","content":"test_tx() -&gt; Transaction\n A fake transaction used for testing.","url":"tests/fake_tx.html#test_tx"},{"doc":"tests/fake_tx","title":"DataType","content":"DataType = Data\n A `Data`data type\n","url":"tests/fake_tx.html#DataType"},{"doc":"tests/fake_tx","title":"test_datum","content":"test_datum: ByteArray = #&quot;acabbeeffacecafe&quot;\n A test datum.","url":"tests/fake_tx.html#test_datum"},{"doc":"tests/fake_tx","title":"tests/fake_tx","content":" This is for testing only.\n","url":"tests/fake_tx.html"},{"doc":"assist/data","title":"input_datum","content":"input_datum(possible_input: Input) -&gt; Data\n Find the datum data on an input or error. The data is assumed\n to be an inline datum.\n\n ```aiken\n expect datum: Datum = data.input_datum(this_input)\n ```","url":"assist/data.html#input_datum"},{"doc":"assist/data","title":"output_datum","content":"output_datum(possible_output: Output) -&gt; Data\n Find the datum data on an output or error. The data is assumed\n to be an inline datum.\n\n ```aiken\n expect datum: Datum = data.output_datum(that_output)\n ```","url":"assist/data.html#output_datum"},{"doc":"assist/data","title":"assist/data","content":" This module contains code for extracting data from a potential inline \n datum found in either an input or output.\n","url":"assist/data.html"},{"doc":"assist/values","title":"compute_hash","content":"compute_hash(target: Value) -&gt; ByteArray\n Compute the sha3_256 hash of a value by merklizing the policy id, asset\n name, and quantity. Empty values return the empty by string.\n\n ```aiken\n values.compute_hash(validating_value)\n ```","url":"assist/values.html#compute_hash"},{"doc":"assist/values","title":"contains","content":"contains(target: Value, total: Value) -&gt; Bool\n Prove that the target value is contained inside another value. Each token\n inside the target must exist inside the total value. The quantity of each\n token must be at least the target amount or greater.\n\n ```aiken\n values.contains(payment_value, output_value)\n ```","url":"assist/values.html#contains"},{"doc":"assist/values","title":"multiply","content":"multiply(val: Value, n: Int) -&gt; Value\n Multiply some value by `n`. This is just a linear scaling to the quantity\n of each token.\n\n ```aiken\n values.multiply(bundle_value, bundle_size)\n ```","url":"assist/values.html#multiply"},{"doc":"assist/values","title":"prove_exact_nft","content":"prove_exact_nft(\n  nft_pid: PolicyId,\n  nft_tkn: AssetName,\n  total_value: Value,\n) -&gt; Bool\n Proves that inside some value there is a policy id with token\n name that has a quantity of 1. This will show that a value contains an\n NFT or something that is nft-like. Should be useful to prove that\n something is holding a token inside a transaction when the policy id and\n token name is known.\n\n ```aiken\n values.prove_exact_nft(pid, tkn, that_value)\n ```","url":"assist/values.html#prove_exact_nft"},{"doc":"assist/values","title":"prove_nft","content":"prove_nft(pid: PolicyId, total: Value) -&gt; Bool\n Proves that inside some value there is a policy id with a single token\n name that has a quantity of 1. This will show that a value contains an\n NFT or something that is nft-like. Should be useful to prove that\n something is holding a token inside a transaction when the token name\n is assumed to be unique.\n\n ```aiken\n values.prove_nft(pid, this_value)\n ```","url":"assist/values.html#prove_nft"},{"doc":"assist/values","title":"total_token_amount","content":"total_token_amount(\n  inputs: List&lt;Input&gt;,\n  pid: PolicyId,\n  tkn: AssetName,\n  counter: Int,\n) -&gt; Int\n Calculate the total amount of a token within the set of inputs for the \n transaction. This function is useful when needing to get a total amount\n of one token inside a given transaction, like estimating if a threshold\n has been met.\n\n ```aiken\n values.total_token_amount(tx.inputs, datum.pid, datum.tkn, 0)\n ```","url":"assist/values.html#total_token_amount"},{"doc":"assist/values","title":"unique_token_name","content":"unique_token_name(txid: ByteArray, idx: Int, prefix: ByteArray) -&gt; ByteArray\n Calculate a unique token name from a `TxId#Idx` and prefix. Can be combined\n with the `find` module to create unique token names from the first input\n utxo inside the transaction.\n\n ```aiken\n values.unique_token_name(tx_id, tx_idx, prefixes.prefix_333)\n ```","url":"assist/values.html#unique_token_name"},{"doc":"assist/values","title":"assist/values","content":" This module contains code that aids in various value \n manipulations and comparisons.\n","url":"assist/values.html"},{"doc":"assist/credentials","title":"create_stake_credential","content":"create_stake_credential(sc: Hash&lt;Blake2b_224, Script&gt;) -&gt; Referenced&lt;Credential&gt;\n Creates a stake credential from the hex encoding of a stake key.\n This can be used to find the reward amount from the withdrawals \n information inside the transaction of the form Dict&lt;StakeCredential, Int&gt;\n\n ```aiken\n credentials.create_stake_credential(datum.contract_hash)\n ```","url":"assist/credentials.html#create_stake_credential"},{"doc":"assist/credentials","title":"assist/credentials","content":" This module incorporates code for generating valid credentials,\n ensuring their correctness. \n","url":"assist/credentials.html"}]);