defmodule Super do
  # 1. Generate all pairs, sort by Area DESC (Greedy approach)
  def solve(cords) do
    # Ensure loop is closed for easy iteration
    poly = cords ++ [hd(cords)]

    # Generate all pairs of corners
    pairs = for i <- 0..(length(cords)-2),
                j <- (i+1)..(length(cords)-1),
                p1 = Enum.at(cords, i),
                p2 = Enum.at(cords, j),
                do: {p1, p2, calculate_area(p1, p2)}

    # Sort descending and find the first valid one
    pairs
    |> Enum.sort_by(fn {_, _, area} -> area end, :desc)
    |> Enum.find(fn {p1, p2, _} -> valid_rectangle?(poly, p1, p2) end)
  end

  def calculate_area({x1, y1}, {x2, y2}) do
    (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)
  end

  # --- VALIDATION LOGIC ---

  def valid_rectangle?(poly, {x1, y1}, {x2, y2}) do
    # Normalize coordinates to min/max for easier logic
    xmin = min(x1, x2)
    xmax = max(x1, x2)
    ymin = min(y1, y2)
    ymax = max(y1, y2)
    rect = {xmin, xmax, ymin, ymax}

    # CONDITION 1: Center of rectangle must be inside the polygon
    # We use a float center point to avoid hitting edges exactly
    center = {xmin + (xmax - xmin) / 2.0, ymin + (ymax - ymin) / 2.0}

    # CONDITION 2: No polygon vertex can be strictly inside the rectangle
    # (This detects if the polygon "bites" into the rectangle)
    no_intrusions = !Enum.any?(poly, fn {px, py} ->
      px > xmin and px < xmax and py > ymin and py < ymax
    end)

    # CONDITION 3: No polygon edge can strictly cross a rectangle edge
    no_crossings = !edges_cross?(poly, rect)

    is_point_in_polygon?(center, poly) and no_intrusions and no_crossings
  end

  # Ray-casting algorithm to check if point is inside polygon
  def is_point_in_polygon?({x, y}, poly) do
    # Cast a ray to the right (x -> infinity)
    # Count how many polygon edges it crosses
    poly
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(0, fn [{x1, y1}, {x2, y2}], count ->
      # Check if edge straddles the ray's Y-coordinate
      cond do
        (y1 > y) != (y2 > y) and x < (x2 - x1) * (y - y1) / (y2 - y1) + x1 -> count + 1
        true -> count
      end
    end)
    |> rem(2) == 1
  end

  def edges_cross?(poly, {rmin_x, rmax_x, rmin_y, rmax_y}) do
    # Define the 4 segments of the rectangle
    rect_edges = [
      {{rmin_x, rmin_y}, {rmax_x, rmin_y}}, # Top
      {{rmax_x, rmin_y}, {rmax_x, rmax_y}}, # Right
      {{rmax_x, rmax_y}, {rmin_x, rmax_y}}, # Bottom
      {{rmin_x, rmax_y}, {rmin_x, rmin_y}}  # Left
    ]

    # Check every polygon edge against every rectangle edge
    poly
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.any?(fn {p_start, p_end} ->
      Enum.any?(rect_edges, fn {r_start, r_end} ->
        intersects_strictly?({p_start, p_end}, {r_start, r_end})
      end)
    end)
  end

  # Checks if two segments strictly cross each other (overlap/touching doesn't count as failure)
  def intersects_strictly?({{ax, ay}, {bx, by}}, {{cx, cy}, {dx, dy}}) do
    # Standard vector cross product method for intersection
    d1 = ccw({ax, ay}, {bx, by}, {cx, cy})
    d2 = ccw({ax, ay}, {bx, by}, {dx, dy})
    d3 = ccw({cx, cy}, {dx, dy}, {ax, ay})
    d4 = ccw({cx, cy}, {dx, dy}, {bx, by})

    # Strict intersection means endpoints are on opposite sides of the lines
    ((d1 > 0 and d2 < 0) or (d1 < 0 and d2 > 0)) and
    ((d3 > 0 and d4 < 0) or (d3 < 0 and d4 > 0))
  end

  def ccw({p1x, p1y}, {p2x, p2y}, {p3x, p3y}) do
    (p2x - p1x) * (p3y - p1y) - (p2y - p1y) * (p3x - p1x)
  end
end

# --- Execution ---

# Read Input
cords = File.read!("input.txt")
|> String.split("\n", trim: true)
|> Enum.map(fn line ->
  [x,y] = String.split(line, ",")
  {String.to_integer(String.trim(x)), String.to_integer(String.trim(y))}
end)

# Solve
result = Super.solve(cords)
IO.inspect(result, label: "Best Rectangle")
