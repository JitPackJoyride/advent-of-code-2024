import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/pair
import gleam/result
import gleam/string
import simplifile

pub fn part_1(path: String) {
  use lines <- result.try(
    simplifile.read(path)
    |> result.map(string.trim)
    |> result.map(string.split(_, "\n"))
    |> result.replace_error("could not read file"),
  )

  use #(left_list, right_list) <- result.try(list.try_fold(
    over: lines,
    from: #([], []),
    with: fold_line_part_1,
  ))

  list.map2(
    list.sort(left_list, int.compare),
    list.sort(right_list, int.compare),
    fn(a, b) { int.absolute_value(a - b) },
  )
  |> int.sum
  |> Ok
}

pub fn part_2(path: String) {
  use lines <- result.try(
    simplifile.read(path)
    |> result.map(string.trim)
    |> result.map(string.split(_, "\n"))
    |> result.replace_error("could not read file"),
  )

  use #(left_list, count_lookup) <- result.try(list.try_fold(
    over: lines,
    from: #([], dict.new()),
    with: fold_line_part_2,
  ))

  list.fold(over: left_list, from: 0, with: fn(acc, left) {
    let count = dict.get(count_lookup, left) |> result.unwrap(0)
    left * count + acc
  })
  |> Ok
}

fn fold_line_part_1(acc, line) {
  use ints_list <- result.try(
    string.split(line, "   ")
    |> list.map(int.parse)
    |> result.all
    |> result.replace_error("could not parse line"),
  )

  use #(left, right) <- result.try(case ints_list {
    [left_num, right_num] -> Ok(#(left_num, right_num))
    _ -> Error("malformed line")
  })

  Ok(#([left, ..pair.first(acc)], [right, ..pair.second(acc)]))
}

fn fold_line_part_2(acc, line) {
  use ints_list <- result.try(
    string.split(line, "   ")
    |> list.map(int.parse)
    |> result.all
    |> result.replace_error("could not parse line"),
  )

  use #(left, right) <- result.try(case ints_list {
    [left_num, right_num] -> Ok(#(left_num, right_num))
    _ -> Error("malformed line")
  })

  Ok(#(
    [left, ..pair.first(acc)],
    dict.upsert(pair.second(acc), right, fn(opt) {
      case opt {
        option.Some(count) -> count + 1
        option.None -> 1
      }
    }),
  ))
}
