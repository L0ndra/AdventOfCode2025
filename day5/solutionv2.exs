[ranges, _] = File.read!("input.txt") |> String.split("\n\n")

String.split(ranges, "\n") |> Enum.reduce([], fn range, ranges ->
  [left, right] = String.split(range, "-") |> Enum.map(&String.to_integer(&1))
  Super.add_range(ranges, left, right)
end) |> IO.inspect() |> Enum.reduce(0, fn {left,right}, count ->
  diff = right - left + 1
  count + diff
end) |> IO.puts()

