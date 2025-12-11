defmodule Super do
  def build_areas([head | tail]) do
    if length(tail) == 0 do
      []
    else
      areas = Enum.reduce(tail, [], fn cord, areas ->
        area = calculatearea(head,cord)
        [{head, cord, area} | areas]
      end)
      areas ++ build_areas(tail)
    end
  end
  def calculatearea({x1, y1}, {x2, y2}) do
    len = abs(x1-x2)
    width = abs(y1-y2)
    (len+1)*(width+1)
  end

  def findbigestrect([{cord1, cord2, area} | tail], cords) do
    if(checkrectangle(cords, cord1, cord2)) do
      {cord1, cord2, area}
    else
      findbigestrect(tail, cords)
    end
  end

  def checkrectangle(cords, {x1, y1}, {x2, y2}) do
    check_side(cords, {x1, y1}, {x1, y2}) && check_side(cords, {x2, y1}, {x2, y2}) && check_side(cords, {x1, y1}, {x2, y1}) && check_side(cords, {x1, y2}, {x2, y2})
  end

  def check_side([head | cords], cord1, cord2) do
    if length(cords) == 1 do
      true
    else
      next = hd(cords)
      if is_coligion(head, next, cord1, cord2) do
        IO.inspect({:false_coligion, head, next, cord1, cord2})
        false
      else
        check_side(cords, cord1, cord2)
      end
    end
  end

  def is_coligion({x1, y1}, {x2, y2}, {x3, y3}, {x4, y4}) do
    if is_parallel({x1, y1}, {x2, y2}, {x3, y3}, {x4, y4}) do
      !is_inband({x1, y1}, {x2, y2}, {x3, y3}, {x4, y4})
    else
      if(x1 == x2) do
        xmin = min(x3, x4)
        xmax = max(x3, x4)
        ymin = min(y1, y2)
        ymax = max(y1, y2)
        x1 > xmin && x1 < xmax && y3 > ymin && y3 < ymax
      else
        xmin = min(x1, x2)
        xmax = max(x1, x2)
        ymin = min(y3, y4)
        ymax = max(y3, y4)
        x3 > xmin && x3 < xmax && y1 > ymin && y1 < ymax
      end
    end
  end

  def is_parallel({x1, y1}, {x2, y2}, {x3, y3}, {x4, y4}) do
    (x1 == x2 && x3 == x4) || (y1 == y2 && y3 == y4)
  end

  def is_inband({x1, y1}, {x2, y2}, {x3, y3}, {x4, y4}) do
    if x1 == x2 && x3 == x4 && x1 == x3 do
      ymin = min(y1, y2)
      ymax = max(y1, y2)
      (y3 >= ymin && y3 <= ymax && y4 >= ymin && y4 <= ymax) || (y3 >= ymax && y4 >= ymax) || (y3 <= ymin && y4 <= ymin)
    else
    if y1 == y2 && y3 == y4 && y1 == y3 do
      xmin = min(x1, x2)
      xmax = max(x1, x2)
      IO.inspect({xmin, xmax, x3, x4})
      (x3 >= xmin && x3 <= xmax && x4 >= xmin && x4 <= xmax) || (x3 >= xmax && x4 >= xmax) || (x3 <= xmin && x4 <= xmin)
    else
      true
    end
  end
end
end

cords = File.read!("input.txt") |> String.split("\n") |>
Enum.map(fn line ->
  [x,y] = String.split(line, ",")
  {String.to_integer(x),String.to_integer(y)}
end)

cords = cords ++ [hd(cords)]

Super.is_inband({7,1},{11,1}, {11,1},{2,1}) |> IO.inspect()

cords |> Super.build_areas() |>
Enum.sort_by(fn {_,_,area} -> area end, :desc) |>
Super.findbigestrect(cords) |>
IO.inspect()
