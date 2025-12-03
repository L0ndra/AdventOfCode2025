File.read!("input.txt") |> String.split(",") |> Enum.map(fn item ->
  [left, right] = String.split(item, "-") |> Enum.map(&String.to_integer(&1))
  Enum.filter(Enum.to_list(left..right), fn num ->
  String.match?(Integer.to_string(num), ~r/^(\d+)\1+$/)
  end) |> Enum.sum()
end) |> Enum.sum() |> IO.puts()
