defmodule Super do
  def traverse(map, item) do
    if item == "out" do
      1
    else
      Map.get(map, item) |>
      Enum.reduce(0, fn output, count -> count + traverse(map, output) end)
    end
  end
end

File.read!("input.txt") |>
String.split("\n") |>
Enum.map(fn line ->
  [input , outputs] = String.split(line, ": ")
  outputs = String.split(outputs, " ")
  {input, outputs}
end) |>
Enum.reduce(%{}, fn {input, outputs}, map ->
  Map.put(map, input, outputs)
end) |>
Super.traverse("you") |>
IO.inspect()
