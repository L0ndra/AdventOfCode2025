defmodule Super do
  def findClosest([head | tail]) do
    next = hd(tail)
    base = calcdistance(head, next)

    {dist, cord} = Enum.reduce(tail, {base, next}, fn cord, {min, mincord} ->
      dist = calcdistance(head, cord)
      if dist < min do
        {dist, cord}
      else
        {min, mincord}
      end
    end)
    if length(tail) == 1 do
      {base, head, next}
    else
      {min, start, finish} = findClosest(tail)
      if(dist < min) do
        {dist, head, cord}
      else
        {min, start, finish}
      end
    end
  end

  def build_distances([head | tail]) do
    if length(tail) == 0 do
      []
    else
      distances = Enum.reduce(tail, [], fn cord, distances ->
        distance = calcdistance(head, cord)
        [{head, cord, distance} | distances]
      end)
      distances ++ build_distances(tail)
    end
  end

  def calcdistance({x1 , y1 , z1}, {x2, y2, z2}) do
    Float.pow(Float.pow(x1-x2,2) + Float.pow(y1-y2, 2) + Float.pow(z1-z2,2), 0.5)
  end

  def add_to_union(unions, cord1, cord2) do
    union1 = Enum.find(unions, nil, fn union ->
      cord1 in union
    end)
    union2 = Enum.find(unions, nil, fn union ->
      cord2 in union
    end)
    case {union1, union2} do
      {nil, nil} -> [[cord1, cord2] | unions]
      {union1, nil} -> add_element(unions, union1, cord2)
      {nil, union2} -> add_element(unions, union2, cord1)
      _ when union1 == union2 -> unions
      {union1, union2} when union1 != union2 -> merge_unions(unions, union1, union2)
    end
  end

  def add_element(unions, union, cord) do
    unions = unions -- [union]
    [[cord | union] | unions]
  end

  def merge_unions(unions, union1, union2) do
    unions = unions -- [union1]
    unions = unions -- [union2]
    [union1 ++ union2 | unions]
  end

  def to_one_union([{cord1, cord2, _} | tail], unions, cords) do
    unions = add_to_union(unions, cord1, cord2)
    cords = cords -- [cord1 , cord2]
    if cords == [] and length(unions) == 1 do
      {cord1, cord2}
    else
      to_one_union(tail, unions, cords)
    end
  end

end

cords =
File.read!("input.txt") |>
String.split("\n") |>
Enum.map(fn line ->
  [{x,_},{y,_},{z,_}] = String.split(line, ",") |> Enum.map(&Float.parse(&1))
  {x,y,z}
end)

{{x1, _, _}, {x2, _, _}} = Super.build_distances(cords) |>
Enum.sort_by(fn {_, _, distance} -> distance end) |>
Super.to_one_union([], cords)
IO.inspect(x1*x2)
