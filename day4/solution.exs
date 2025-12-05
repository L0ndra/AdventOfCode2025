defmodule Help do
  def checkrol(map, i, j) do
    el = Map.get(map, {i,j}, ".")
    if el == "@" do
    1
    else
    0
    end
  end
  def onerun(final_map, height, width) do
    {map, count} = Enum.to_list(0..height-1) |> Enum.reduce({final_map,0}, fn i, {map1, count} ->
    Enum.to_list(0..width-1) |> Enum.reduce({map1, count}, fn j, {map2, subcount} ->
      cur = Help.checkrol(final_map,i,j)
      if cur == 1 do
        rolcount = 0
        rolcount = rolcount + Help.checkrol(final_map, i-1, j-1)
        rolcount = rolcount + Help.checkrol(final_map, i-1, j)
        rolcount = rolcount + Help.checkrol(final_map, i-1, j+ 1)
        rolcount = rolcount + Help.checkrol(final_map, i, j-1)
        rolcount = rolcount + Help.checkrol(final_map, i, j+1)
        rolcount = rolcount + Help.checkrol(final_map, i+1, j-1)
        rolcount = rolcount + Help.checkrol(final_map, i+1, j)
        rolcount = rolcount + Help.checkrol(final_map, i+1, j+ 1)
        if rolcount < 4 do
          {Map.put(map2, {i,j}, "."),subcount+1}
        else
          {map2, subcount}
        end
      else
        {map2, subcount}
      end
  end)
end)
  if count > 0 do
    count + onerun(map, height, width)
  else
    count
  end
  end
end

{final_map, height, width} =
  File.read!("input.txt")
  |> String.split("\n", trim: true) # Split lines
  |> Enum.with_index()
  |> Enum.reduce({%{}, 0, 0}, fn {line, row_index}, {acc_map, _h, _w} ->
    # Get characters for this line
    chars = String.graphemes(line)
    line_width = length(chars)

    # Inner reduce to populate the map for this specific line
    updated_map_for_line =
      chars
      |> Enum.with_index()
      |> Enum.reduce(acc_map, fn {char, col_index}, inner_map_acc ->
        # We return the new map to the accumulator
        Map.put(inner_map_acc, {row_index, col_index}, char)
      end)

    # Return the updated tuple for the next iteration
    {updated_map_for_line, row_index + 1, line_width}
  end)

Help.onerun(final_map, height, width) |> IO.puts()
