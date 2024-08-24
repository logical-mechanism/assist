use aiken/interval.{
  Finite, Interval, IntervalBound, NegativeInfinity, PositiveInfinity,
}
use cardano/transaction.{ValidityRange}

/// A finite moment of time represented as simple start and end integers.
pub type Moment {
  start: Int,
  end: Int,
}

/// A finite list of moments of time.
pub type Moments =
  List<Moment>

/// Shifts a moment by some integer amount. This is great for incrementing
/// a fixed moment of time, maybe like an epoch boundary by five days.
///
/// ```aiken
/// moment.shift(this_moment, a_day)
/// ```
pub fn shift(m: Moment, t: Int) -> Moment {
  Moment { start: m.start + t, end: m.end + t }
}

test no_shift() {
  let m: Moment = Moment { start: 0, end: 0 }
  shift(m, 0) == m
}

test positive_shift() {
  let m1: Moment = Moment { start: 1, end: 5 }
  let m2: Moment = Moment { start: 11, end: 15 }
  shift(m1, 10) == m2
}

test negative_shift() {
  let m1: Moment = Moment { start: 11, end: 15 }
  let m2: Moment = Moment { start: 1, end: 5 }
  shift(m1, -10) == m2
}

/// Check if a moment data structure is logical. 
///
/// ```aiken
/// moment.is_logical(datum.moment)
/// ```
pub fn is_logical(m: Moment) -> Bool {
  and {
    m.end >= m.start,
    m.start >= 0,
    m.end >= 0,
  }
}

test an_empty_moment() {
  let m: Moment = Moment { start: 0, end: 0 }
  is_logical(m) == True
}

test a_singular_moment() {
  let m: Moment = Moment { start: 10, end: 10 }
  is_logical(m) == True
}

test a_nonvalid_moment() {
  let m: Moment = Moment { start: 10, end: 0 }
  is_logical(m) == False
}

test a_valid_moment() {
  let m: Moment = Moment { start: 1, end: 15 }
  is_logical(m) == True
}

/// Check if a validity range is contained within some moment.
/// This assumes inclusivity.
///
/// |start--|lower----upper|--end|
///
/// ```aiken
/// moment.is_contained(datum.moment, this_tx.validity_range)
/// ```
pub fn is_contained(m: Moment, vr: ValidityRange) -> Bool {
  when vr.lower_bound.bound_type is {
    // must be finite
    NegativeInfinity -> False
    // get the lower bound int
    Finite(lower_bound) ->
      when vr.upper_bound.bound_type is {
        // must be finite
        NegativeInfinity -> False
        // get the upper bound int
        Finite(upper_bound) -> and {
            // the lower bound is greater than or equal the start of the moment
            m.start <= lower_bound,
            // the upper bound is less or equal to the end of the moment
            upper_bound <= m.end,
          }
        // must be finite
        PositiveInfinity -> False
      }
    // must be finite
    PositiveInfinity -> False
  }
}

test infinite_bounds_not_allowed() {
  let vr: ValidityRange =
    Interval {
      lower_bound: IntervalBound {
        bound_type: NegativeInfinity,
        is_inclusive: True,
      },
      upper_bound: IntervalBound {
        bound_type: PositiveInfinity,
        is_inclusive: True,
      },
    }
  let m: Moment = Moment { start: 0, end: 0 }
  // the bounds can not be infinite
  is_contained(m, vr) == False
}

test infinite_bounds_not_allowed2() {
  let vr: ValidityRange =
    Interval {
      lower_bound: IntervalBound {
        bound_type: NegativeInfinity,
        is_inclusive: True,
      },
      upper_bound: IntervalBound {
        bound_type: PositiveInfinity,
        is_inclusive: True,
      },
    }
  let m: Moment = Moment { start: 1, end: 10 }
  // the bounds can not be infinite
  is_contained(m, vr) == False
}

test an_empty_validity_range_inside_a_moment() {
  let vr: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(1), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(1), is_inclusive: True },
    }
  let m: Moment = Moment { start: 0, end: 10 }
  is_contained(m, vr) == True
}

test a_moment_and_validity_range_are_equal() {
  let vr: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(0), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(10), is_inclusive: True },
    }
  let m: Moment = Moment { start: 0, end: 10 }
  is_contained(m, vr) == True
}

test a_validity_range_inside_a_moment() {
  let vr: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(3), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(5), is_inclusive: True },
    }
  let m: Moment = Moment { start: 0, end: 10 }
  is_contained(m, vr) == True
}

test a_validity_range_outside_a_moment() {
  let vr: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(13), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(15), is_inclusive: True },
    }
  let m: Moment = Moment { start: 0, end: 10 }
  is_contained(m, vr) == False
}

test a_validity_range_outside_a_moment2() {
  let vr: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(3), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(5), is_inclusive: True },
    }
  let m: Moment = Moment { start: 6, end: 17 }
  is_contained(m, vr) == False
}

/// Check if a validity range of a tx is after a moment.
/// This assumes exclusivity.
///
/// |start----end|--|lower----upper|
///
/// ```aiken
/// moment.is_after(datum.moment, this_tx.validity_range)
/// ```
pub fn is_after(m: Moment, vr: ValidityRange) -> Bool {
  when vr.lower_bound.bound_type is {
    // must be finite
    NegativeInfinity -> False
    // get the lower bound int
    Finite(lower_bound) -> m.end < lower_bound
    // must be finite
    PositiveInfinity -> False
  }
}

test a_validity_range_is_after_a_moment() {
  let vr: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(5), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(10), is_inclusive: True },
    }
  let m: Moment = Moment { start: 1, end: 4 }
  is_after(m, vr) == True
}

test a_validity_range_start_at_the_end_of_a_moment() {
  let vr: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(4), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(10), is_inclusive: True },
    }
  let m: Moment = Moment { start: 1, end: 4 }
  is_after(m, vr) == False
}

test a_validity_range_start_at_the_end_of_a_moment2() {
  let vr: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(4), is_inclusive: False },
      upper_bound: IntervalBound { bound_type: Finite(10), is_inclusive: True },
    }
  let m: Moment = Moment { start: 1, end: 4 }
  is_after(m, vr) == False
}

test a_validity_range_is_not_after_a_moment() {
  let vr: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(0), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(10), is_inclusive: True },
    }
  let m: Moment = Moment { start: 1, end: 13 }
  is_after(m, vr) == False
}

test a_validity_range_is_not_after_a_moment2() {
  let vr: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(0), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(4), is_inclusive: True },
    }
  let m: Moment = Moment { start: 4, end: 12 }
  is_after(m, vr) == False
}

test a_validity_range_is_not_after_a_moment3() {
  let vr: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(8), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(14), is_inclusive: True },
    }
  let m: Moment = Moment { start: 4, end: 12 }
  is_after(m, vr) == False
}

/// Check if a validity range of a tx is before a moment.
/// This assumes exclusivity.
///
/// |lower----upper|--|start----end|
///
/// ```aiken
/// moment.is_before(datum.moment, this_tx.validity_range)
/// ```
pub fn is_before(m: Moment, vr: ValidityRange) -> Bool {
  when vr.upper_bound.bound_type is {
    // must be finite
    NegativeInfinity -> False
    // get the upper bound int
    Finite(upper_bound) -> upper_bound < m.start
    // must be finite
    PositiveInfinity -> False
  }
}

test a_validity_range_is_before_a_moment() {
  let vr: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(0), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(10), is_inclusive: True },
    }
  let m: Moment = Moment { start: 11, end: 13 }
  is_before(m, vr) == True
}

test a_validity_range_is_not_before_a_moment() {
  let vr: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(10), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(12), is_inclusive: True },
    }
  let m: Moment = Moment { start: 5, end: 13 }
  is_before(m, vr) == False
}

test a_validity_range_is_not_before_a_moment2() {
  let vr: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(10), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(16), is_inclusive: True },
    }
  let m: Moment = Moment { start: 5, end: 13 }
  is_before(m, vr) == False
}

test a_validity_range_is_not_before_a_moment3() {
  let vr: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(15), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(17), is_inclusive: True },
    }
  let m: Moment = Moment { start: 5, end: 13 }
  is_before(m, vr) == False
}

test a_validity_range_is_not_before_a_moment4() {
  let vr: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(1), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(7), is_inclusive: True },
    }
  let m: Moment = Moment { start: 5, end: 13 }
  is_before(m, vr) == False
}

test a_validity_range_is_not_before_a_moment5() {
  let vr: ValidityRange =
    Interval {
      lower_bound: IntervalBound { bound_type: Finite(1), is_inclusive: True },
      upper_bound: IntervalBound { bound_type: Finite(5), is_inclusive: True },
    }
  let m: Moment = Moment { start: 5, end: 13 }
  is_before(m, vr) == False
}
