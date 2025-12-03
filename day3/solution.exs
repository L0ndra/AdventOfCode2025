defmodule Math do
  def update_list([n1], n2) do
    cond do
      n2 > n1 -> {[n2], true}
      true -> {[n1], false}
    end
  end

  def update_list(list, n2) do
    n1 = hd(list)
    {updated_list, up} = update_list(tl(list), n1)
    cond do
      n2 > n1 || up -> {[n2]++updated_list, true}
      true -> {[n1]++updated_list, false}
    end
  end
end

File.read!("input.txt") |>
String.split("\n") |>
Enum.map(fn line ->\
  empty_list = Enum.to_list(1..12) |> Enum.map(fn _ -> "0" end)
  String.graphemes(line) |>
  Enum.reduce(empty_list, fn num, result ->
    {out, _} = Math.update_list(result, num)
    out
  end) |>
  Enum.reverse() |>
  List.to_string() |>
  String.to_integer()
end) |>
Enum.sum() |> IO.puts()
