{pos, count} = File.read!("input.txt")
|> String.split("\n", trim: true)
|> Enum.map(&String.split_at(&1, 1))
|> Enum.reduce({50, 0}, fn item, {pos, count} ->
  newpos = case item do
    {"R", value} -> pos+String.to_integer(value)
    {"L", value} -> pos-String.to_integer(value)
  end
  {pos, count} = case {newpos, abs(div(newpos, 100))} do
    {newpos, num} when newpos == 0 -> {rem(newpos,100), count+num+1}
    {newpos, num} when pos >= 0 and newpos > 0 -> {rem(newpos,100), count+num}
    {newpos, num} when pos <= 0 and newpos < 0 -> {rem(newpos,100), count+num}
    {newpos, num} -> {rem(newpos,100), count+num+1}
  end
  {pos, count}
end)
IO.puts("#{count}")
