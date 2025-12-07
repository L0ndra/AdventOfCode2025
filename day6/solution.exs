defmodule SuperModule do
  def operate({nums, op}) do
    case op do
      "*" -> Enum.reduce(nums, 1, fn num, res -> num * res end)
      "+" -> Enum.reduce(nums, 0, fn num, res -> num + res end)
    end
  end

  def parse_operations(line) do
    operations = String.split(line, " ", trim: true)
    {_, line} = String.split_at(line, 1)
    lengthes = String.split(line, ["*", "+"]) |> Enum.map(fn section -> String.length(section) end)
    {operations, lengthes}
  end

  def parse_numbers(line, [cur | lengthes]) do
      {el, line} = String.split_at(line, cur + 1)
      [el | parse_numbers(line, lengthes)]
  end

  def parse_numbers(line, []) do
    []
  end

  def zip(numbers) do
    Enum.reduce(numbers, [], fn line, zipped ->
      if zipped == [] do
        Enum.map(line, fn el -> [el] end)
      else
        Enum.zip_with(zipped, line, fn z,l -> [l | z] end)
      end
    end)
  end

  def column_to_numbers(column) do
    Enum.map(column, &String.graphemes(&1)) |> zip() |>
    Enum.map(fn number ->
      Enum.reverse(number) |> Enum.reduce("", fn digit, number ->
        number <> digit
      end) |>
      String.trim()
    end) |>
    Enum.filter(fn str -> str != "" end) |>
    Enum.map(&String.to_integer(&1))
  end
end

[operations | numbers] = File.read!("input.txt") |>
String.split("\n", trim: true) |>
Enum.reverse()

{operations, lengthes} = SuperModule.parse_operations(operations)

Enum.map(numbers, fn line -> SuperModule.parse_numbers(line, lengthes) end) |>
SuperModule.zip() |>
Enum.map(&SuperModule.column_to_numbers(&1)) |>
Enum.zip(operations) |>
IO.inspect() |>
Enum.map(&SuperModule.operate(&1)) |>
Enum.sum() |>
IO.inspect()
