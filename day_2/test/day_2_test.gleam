import day_2
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn example_test() {
  day_2.main("test.txt")
  |> should.equal(Ok(2))
}

pub fn part_1_test() {
  day_2.main("input.txt")
  |> should.equal(Ok(483))
}
