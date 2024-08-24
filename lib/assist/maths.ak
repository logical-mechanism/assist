//// This module incorporates code for various mathematical operations.
////

use aiken/collection/list
use aiken/math
use aiken/primitive/bytearray

/// A large prime number. The value is near 4 x 10^114.
pub const large_prime: Int =
  0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab

/// Calculate `n` to the power of `e` modulo `q` using the exponentiation by 
/// squaring method. At each multiplication a modulo is calculated, allowing
/// very large `n` and `e` values.
///
/// ```aiken
/// maths.powmod(3, 2, 5)
/// ```
pub fn powmod(n: Int, e: Int, q: Int) -> Int {
  if or {
    e < 0,
    q == 0,
  } {
    // negative exponents and zero mod here
    // we can't handle this case so call it all zero
    0
  } else if e == 0 {
    // defined to be one, x^0 = 1 if x not zero but
    // when x is zero then you 0^0 = Nan, and one 
    // more validation check to run so to make it
    // cheaper just call it one
    1
  } else if e % 2 == 0 {
    // even case
    powmod(n * n % q, e / 2, q)
  } else {
    // odd case
    n * powmod(n * n % q, ( e - 1 ) / 2, q) % q
  }
}

test powmod_3_5_4() {
  powmod(3, 5, 4) == 3
}

test powmod_3__4_3() {
  // negative powers round to zero
  powmod(3, -4, 3) == 0
}

test pow_0_0_1() {
  // sorry math
  powmod(0, 0, 1) == 1
}

test powmod_513_3_7() {
  powmod(513, 3, 7) == 1
}

test powmod_54_123_0() {
  powmod(54, 123, 0) == 0
}

test powmod_54_123_1() {
  powmod(54, 123, 1) == 0
}

test powmod_very_large1() {
  powmod(2, 6298875231651707927, large_prime) == 619257508790463606920652988927719175328304037643924550063346200106231201391121814124765664556886167107742014416823
}

test powmod_very_large2() {
  powmod(11024141354654159834, 6298875231651707927, large_prime) == 1281252237043588814874358657648283885922247063951636571913626407612926025965286114877878077927294143587983649997167
}

test powmod_very_large3() {
  powmod(
    1281252237043588814874358657648283885922247063951636571913626407612926025965286114877878077927294143587983649997167,
    6298875231651707927,
    large_prime,
  ) == 1375787197462284242586537174662214468532791477308429144007255343030157255268351835798245451858532190874833597636080
}

/// Convert a integer `n` into some base `q`. This method
/// should scale with any integer and any logical base.
///
/// ```aiken
/// maths.base_q(123, 7)
/// ```
pub fn base_q(n: Int, q: Int) -> List<Int> {
  do_base_q(n, q, [])
}

// Internal only
fn do_base_q(number: Int, base: Int, holder: List<Int>) -> List<Int> {
  // if the number or base is zero return the holder list
  if or {
    number == 0,
    base == 0,
  } {
    holder
  } else {
    do_base_q(number / base, base, list.push(holder, number % base))
  }
}

test zero_in_base_zero() {
  base_q(0, 0) == []
}

test one_in_base_zero() {
  base_q(1, 0) == []
}

test simple_base_q() {
  base_q(17232, 4) == [1, 0, 0, 3, 1, 1, 0, 0]
}

test to_base_256() {
  base_q(78237623, 256) == [4, 169, 207, 183]
}

test to_base_large() {
  base_q(powmod(2, 15383577435643450949, large_prime), 15) == [
    12, 9, 14, 13, 5, 2, 11, 13, 5, 13, 10, 8, 5, 11, 10, 4, 7, 5, 11, 0, 10, 8,
    8, 8, 11, 6, 13, 3, 4, 14, 11, 10, 0, 12, 10, 11, 10, 0, 11, 8, 2, 3, 8, 13,
    0, 1, 5, 13, 0, 8, 13, 3, 10, 6, 4, 12, 14, 3, 7, 1, 11, 3, 7, 3, 14, 6, 8,
    4, 14, 3, 2, 7, 10, 14, 13, 10, 6, 8, 1, 7, 6, 13, 11, 10, 9, 12, 2, 13, 4,
    5, 14, 8, 5, 13, 3, 12, 12,
  ]
}

/// Convert a hexadecimal bytearray into its base 10 representation. This
/// only works with even length bytearrays so arbitrary numbers in hexadecimal
/// form will not in general work.
///
/// ```aiken
/// maths.to_int(#"acab")
/// ```
pub fn to_int(self: ByteArray) -> Int {
  // use bytearray.bytearray_to_integer
  // base 10 value of a hexadecimal number as a bytearray
  bytearray.foldl(self, 0, fn(byte, acc) { acc * 256 + byte })
}

test empty_string_to_int() {
  to_int(#"") == 0
}

test string_to_int() {
  to_int(#"acab") == 44203
}

/// Convert a integer into a hexadecimal bytearray. This works for all integers
/// but odd length bytearrays will be prefixed with a zero. This function 
/// combined with the `to_int` function allows a string to represent a number
/// and still be used for calculations, pushing the `2^64 - 1` integer boundary.
///
/// ```aiken
/// maths.from_int(44203)
/// ```
pub fn from_int(self: Int) -> ByteArray {
  // use bytearray.integer_to_bytearray
  let base_256: List<Int> = base_q(self, 256)
  list.foldr(base_256, #"", fn(n, total) { bytearray.push(total, n) })
}

test odd_from_int() {
  let n: Int = 46118402439
  // odd length get prepended with a zero
  from_int(n) == #"0abcdef987"
}

test empty_from_int() {
  let str: ByteArray = #""
  let n: Int = to_int(str)
  from_int(n) == str
}

test simple_from_int() {
  let str: ByteArray = #"acab"
  let n: Int = to_int(str)
  from_int(n) == str
}

test complex_from_int() {
  let str: ByteArray = #"acabbeeffacecafe"
  let n: Int = to_int(str)
  from_int(n) == str
}

test from_big_int() {
  let str: ByteArray =
    #"0f69bd90956d98ace782567be7bb23ce2aecf6a525ba451795d21feb13220703b48b295a42cc7a86776cc9ad543f610f"
  let n: Int =
    2372285326153189929528332103442483377705667947278803297593729812983050665252776619156384486056106192189240939340047
  from_int(n) == str
}

test to_big_int() {
  let str: ByteArray =
    #"0f69bd90956d98ace782567be7bb23ce2aecf6a525ba451795d21feb13220703b48b295a42cc7a86776cc9ad543f610f"
  let n: Int =
    2372285326153189929528332103442483377705667947278803297593729812983050665252776619156384486056106192189240939340047
  to_int(str) == n
}

/// Computes greatest common divisor of two numbers.
///
/// ```aiken
/// maths.gcd(20, 15)
/// ```
pub fn gcd(a: Int, b: Int) -> Int {
  when b is {
    0 -> a
    _ -> gcd(b, a % b)
  }
}

test gcd_20_15() {
  gcd(20, 15) == 5
}

test gcd_124_8() {
  gcd(124, 8) == 4
}

test gcd_48_18() {
  gcd(48, 18) == 6
}

test gcd_0_0() {
  gcd(0, 0) == 0
}

/// Calculate the Legendre symbol `(a/p)` using the Euler's criterion.
/// This implementation assumes that 'a' and 'p' are positive integers.
///
/// ```aiken
/// maths.legendre_symbol(10, 19)
/// ```
pub fn legendre_symbol(a: Int, p: Int) -> Int {
  if a % p == 0 {
    0
  } else if powmod(a, ( p - 1 ) / 2, p) == 1 {
    1
  } else {
    -1
  }
}

test ls_2_3() {
  legendre_symbol(2, 3) == -1
}

test ls_7_7() {
  legendre_symbol(7, 7) == 0
}

test ls_7_3() {
  legendre_symbol(7, 3) == 1
}

/// Computes the product of a list of integers.
///
/// ```aiken
/// maths.list_product([1,2,3])
/// ```
pub fn list_product(lst: List<Int>) -> Int {
  list.foldr(lst, 1, fn(n, total) { n * total })
}

test empty_list_product() {
  list_product([]) == 1
}

test simple_list_product() {
  list_product([1, 2, 3]) == 6
}

/// Computes the power mod product of a list of integers.
///
/// ```aiken
/// maths.list_pow_mod([1,2,3], 2, 19)
/// ```
pub fn list_powmod(lst: List<Int>, g: Int, q: Int) -> Int {
  list.foldr(lst, 1, fn(n, total) { total * powmod(g, n, q) }) % q
}

test empty_list_power_mod() {
  list_powmod([], 2, 19) == 1
}

test simple_list_power_mod() {
  list_powmod([1, 2, 3], 2, 19) == 7
}

/// Computes the sum of a list of integers.
///
/// ```aiken
/// maths.list_sum(list_of_integers)
/// ```
pub fn list_sum(lst: List<Int>) -> Int {
  list.foldr(lst, 0, fn(n, total) { total + n })
}

test empty_list_sum() {
  list_sum([]) == 0
}

test simple_list_sum() {
  list_sum([1, 2, 3]) == 6
}

test complex_list_sum() {
  list_sum([1, 2, 3, -3, -2, -1]) == 0
}

/// Decay some starting amount logarithmically until zero. The function evaluates
/// `y = a - log(n)` and when `n >= 2^a` the function equals zero but will return
/// zero whenever the result is less than the scale. This is a great
/// way to reduce some integer amount of something over time by incrementing `n`.
///
/// ```aiken
/// maths.decay(start_amount, lovelace_scaling, datum.current_int)
/// ```
pub fn decay(start_amt: Int, scale: Int, num: Int) -> Int {
  let val: Int = ( start_amt - math.log(num, 2) ) * scale
  if val <= scale {
    0
  } else {
    val
  }
}

test no_decay() {
  decay(18, 1, 0) == 18
}

test small_decay() {
  decay(18, 1, 123) == 12
}

test large_decay() {
  decay(18, 1, 123456) == 2
}

test perfect_decay() {
  decay(18, 1, math.pow(2, 18)) == 0
}

test total_decay() {
  decay(18, 1, 1234567) == 0
}

/// Verify that some integer `n` is greater than the lower bound, `lb`, and
/// less than or equal to the upper bound, `ub`. The function is exclusive
/// for `lb` but inclusive for `lb + 1`.
///
/// ```aiken
/// maths.is_in_range(5, 0, 10)
/// ```
pub fn is_in_range(n: Int, lb: Int, ub: Int) -> Bool {
  and {
    n > lb,
    n <= ub,
  }
}

test inclusive_range() {
  and {
    is_in_range(0, 0, 10) == False,
    is_in_range(10, 0, 10) == True,
  }
}

test it_is_in_range() {
  is_in_range(123, 0, 1000) == True
}

test it_is_not_in_range() {
  is_in_range(123, 0, 100) == False
}

/// Calculates the ratio of the amount `amt` by a percentage `pct`. This can
/// be used to calculate rough percentages. The function `ratio` is just a 
/// special case of the effective ratio function. 
///
/// ```aiken
/// maths.ratio(123, 40)
/// ```
pub fn ratio(amt: Int, pct: Int) -> Int {
  effective_ratio(amt, pct, 1)
}

test zero_ratio() {
  and {
    ratio(0, 1) == 0,
    ratio(1, 0) == 0,
  }
}

// 2.5%
test simple_ratio() {
  ratio(123, 40) == 3
}

// 25%
test complex_ratio() {
  ratio(125000000, 4) == 31250000
}

/// Calculates the ratio of the amount `amt` multiplied by the scale by the
/// percentage `pct`. The scale allows for finer calculations.
///
/// ```aiken
/// maths.effective_ratio(123456789, 40, 1000) == 3086419725
/// ```
pub fn effective_ratio(amt: Int, pct: Int, scale: Int) -> Int {
  if pct <= 0 {
    0
  } else {
    scale * amt / pct
  }
}

test zero_effective_ratio() {
  and {
    effective_ratio(0, 1, 1) == 0,
    effective_ratio(1, 0, 1) == 0,
    effective_ratio(1, 1, 0) == 0,
  }
}

test simple_effective_ratio() {
  and {
    effective_ratio(123, 40, 1) == 3,
    effective_ratio(123, 40, 10) == 30,
    effective_ratio(123, 40, 100) == 307,
    effective_ratio(123, 40, 1000) == 3075,
    effective_ratio(123, 40, 10000) == 30750,
    effective_ratio(123, 40, 100000) == 307500,
    effective_ratio(123, 40, 1000000) == 3075000,
  }
}

test complex_effective_ratio() {
  effective_ratio(123456789, 40, 1000) == 3086419725
}

/// Find the optimal scaling for a number such that it
/// has three trailing zeros. This should be used in combination
/// with the effective ratio for optimal calculations.
///
/// ```aiken
/// maths.scaling(123, 40)
/// ```
pub fn scaling(amt: Int, pct: Int) -> Int {
  calculate_scale(amt, pct, 1, 3, 0)
}

test simple_scaling() {
  scaling(123, 40) == 1000000
}

test complex_scaling() {
  scaling(123456789, 40) == 1000000
}

test complex_scaling2() {
  scaling(583872739578289, 4) == 100000
}

test even_scaling() {
  scaling(125000000, 4) == 1
}

test never_ending_scaling() {
  // 15 here is the max depth
  scaling(123456789, 39) == math.pow(10, 15)
}

test never_ending_scaling2() {
  // 15 here is the max depth
  scaling(123456789, 13) == math.pow(10, 15)
}

test simple_digit_count() {
  math.log(12345, 10) == 5 - 1
}

test moderate_digit_count() {
  math.log(123456789, 10) == 9 - 1
}

// Internal only
fn calculate_scale(
  amt: Int,
  pct: Int,
  scale: Int,
  bound: Int,
  depth: Int,
) -> Int {
  let er: Int = effective_ratio(amt, pct, scale)
  let max_depth: Int = 15
  // the max depth determines irrationals, largest scaling is then 10^max_depth
  if or {
    er == 0,
    depth >= max_depth,
  } {
    scale
  } else {
    if er % 10 == 0 {
      if count_zeros(er, 0) >= bound {
        scale
      } else {
        calculate_scale(amt, pct, 10 * scale, bound, depth + 1)
      }
    } else {
      calculate_scale(amt, pct, 10 * scale, bound, depth + 1)
    }
  }
}

test simple_calculate_scale() {
  calculate_scale(123, 40, 1, 3, 0) == 1000000
}

test complex_calculate_scale() {
  calculate_scale(123456789, 40, 1, 5, 0) == 100000000
}

test even_calculate_scale() {
  calculate_scale(125000000, 4, 1, 3, 0) == 1
}

test zero_calculate_scale() {
  calculate_scale(0, 4, 1, 3, 0) == 1
}

// count the number of zeros at the end of a number
// Internal only
fn count_zeros(number: Int, counter: Int) -> Int {
  if number % 10 == 0 {
    count_zeros(number / 10, counter + 1)
  } else {
    counter
  }
}

test zero_zeros() {
  count_zeros(3, 0) == 0
}

test one_zeros() {
  count_zeros(30, 0) == 1
}

test three_zeros() {
  count_zeros(3075000, 0) == 3
}
