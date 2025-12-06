defmodule Super do
  def add_range(ranges, left, right) do
    {ranges_to_merge, ranges} = Enum.reduce(ranges, {[{left, right}],[]}, fn {range_left, range_right}, {ranges_to_merge, ranges} ->
      if need_to_merge(range_left, range_right, left, right) do
        {ranges_to_merge++[{range_left, range_right}], ranges}
      else
      {ranges_to_merge, ranges++[{range_left, range_right}]}
      end
    end)
    ranges ++ [merge(ranges_to_merge, left, right)]
  end

  def need_to_merge(range_left, range_right, left, right) do
    left <= range_right && right >= range_left
  end

  def merge(ranges, left, right) do
    Enum.reduce(ranges, {left, right}, fn {range_left, range_right}, {left, right} ->
      left = if left < range_left do left else range_left end
      right = if range_right < right do right else range_right end
      {left, right}
    end)
  end
end

[ranges, _] = File.read!("input.txt") |> String.split("\n\n")

String.split(ranges, "\n") |> Enum.reduce([], fn range, ranges ->
  [left, right] = String.split(range, "-") |> Enum.map(&String.to_integer(&1))
  Super.add_range(ranges, left, right)
end) |> IO.inspect() |> Enum.reduce(0, fn {left,right}, count ->
  diff = right - left + 1
  count + diff
end) |> IO.puts()
