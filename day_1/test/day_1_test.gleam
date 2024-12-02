import day_1
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn main_test() {
  day_1.part_1("test.txt")
  |> should.equal(Ok(11))

  day_1.part_2("test.txt")
  |> should.equal(Ok(31))
}

pub fn solve_part_1_test() {
  day_1.part_1("day_1.txt")
  |> should.equal(Ok(2_113_135))

  day_1.part_2("day_1.txt")
  |> should.equal(Ok(19_097_157))
}
