import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import simplifile

pub fn main(path: String) {
  use lines <- result.try(
    simplifile.read(path)
    |> result.map(string.trim)
    |> result.map(string.split(_, "\n"))
    |> result.replace_error("could not read file"),
  )

  use matrix <- result.try(list.try_fold(over: lines, from: [], with: fold_line))

  matrix
  |> list.map(safe_col)
  |> list.fold(0, fn(acc, col) {
    case col {
      True -> acc + 1
      False -> acc
    }
  })
  |> Ok
}

fn fold_line(acc, line) {
  use ints_list <- result.try(
    string.split(line, " ")
    |> list.map(int.parse)
    |> result.all
    |> result.replace_error("could not parse line"),
  )
  list.append(acc, [ints_list]) |> Ok
}

fn safe_col(col) -> Bool {
  case col {
    [] | [_] -> True
    [first, second, ..] -> {
      let is_increasing = second > first
      let is_all_differences_ok =
        list.window_by_2(col)
        |> list.all(fn(pair_nums) {
          int.absolute_value(pair.first(pair_nums) - pair.second(pair_nums))
          |> fn(x) { x >= 1 && x <= 3 }
        })
      let is_all_same_order =
        list.window_by_2(col)
        |> list.all(fn(pair_nums) {
          case is_increasing {
            True -> pair.first(pair_nums) <= pair.second(pair_nums)
            False -> pair.first(pair_nums) >= pair.second(pair_nums)
          }
        })
      is_all_differences_ok && is_all_same_order
    }
  }
}
