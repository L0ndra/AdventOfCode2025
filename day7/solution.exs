defmodule Super do
  def travers({map, depth, s_pos}) do
    {count, memory} = rec_travers(map, 0, s_pos, depth, %{})
    IO.inspect(memory)
    count
  end

  def rec_travers(map, i, j, depth, memory) do
    if(i != depth) do
      count = Map.get(memory, {i,j}, -1)
    if count != -1 do
      {count, memory}
    else
    if Map.get(map, {i,j}) do
      {left_count, memory} = rec_travers(map, i+1, j-1, depth, memory)
      {right_count, memory} = rec_travers(map, i+1, j+1, depth, memory)
      count = left_count+right_count
      memory = Map.put(memory, {i,j}, count)
      {count, memory}
    else
      {count, memory} = rec_travers(map, i+1, j, depth, memory)
      Map.put(memory, {i, j}, count)
      {count, memory}
    end
  end
  else
    {1, memory}
  end
end
end
File.read!("input.txt") |>
String.split("\n", trim: true) |>
Enum.reduce({%{},0, 0}, fn line, {map, i, s_pos} ->
  {map, _, s_pos} = String.graphemes(line) |> Enum.reduce({map, 0, s_pos}, fn el, {map, j, s_pos} ->
    s_pos = if el == "S" do
      j
    else
      s_pos
    end
    map = if el == "^" do
      Map.put(map, {i,j}, true)
    else
      map
    end
    {map, j+1, s_pos}
  end)
  {map, i+1, s_pos}
end) |>
Super.travers() |>
IO.inspect()
