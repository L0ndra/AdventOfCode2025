defmodule Super do
  def parse_line(line) do
    [head | parts] = String.split(line, " ")
    head = remove_parenties(head)
    indicators = conver_indicators_to_binary(head)
    [_ | buttons] = Enum.reverse(parts)
    bin_buttons = Enum.map(buttons, fn button ->
      remove_parenties(button) |> String.split(",") |> Enum.map(&String.to_integer(&1)) |> convert_buttons_to_binary()
    end)
    {indicators, bin_buttons}
  end

  def remove_parenties(el) do
    String.slice(el, 1, String.length(el)-2)
  end

  def conver_indicators_to_binary(el) do
    String.graphemes(el) |> Enum.reverse() |> Enum.reduce("", fn chr, binary ->
      bin = if chr == "." do "0" else "1" end
      binary <> bin
    end) |> String.to_integer(2)
  end

  def convert_buttons_to_binary(button) do
    Enum.reduce(button, 0, fn exp, acc -> acc + Integer.pow(2,exp) end)
  end

  def check_comb(indicator, buttons, min) do
    if(length(buttons) == 0) do
      min
    else
    res = Enum.reduce(buttons, indicator, fn button, indicator ->
      Bitwise.bxor(indicator, button)
    end)
    min = if(res == 0) do
      length(buttons)
    else
      min
    end
    Enum.map(buttons, fn button ->
      check_comb(indicator, buttons -- [button], min)
    end) |> Enum.min()
  end
  end

  def checkcomb(indicator, buttons, pressed_buttons_comb, min) do
    IO.inspect({indicator, buttons, pressed_buttons_comb})
    res = Enum.map(pressed_buttons_comb, &check_buttons(indicator, &1)) |> Enum.any?()
    if res do
      min
    else
      pressed_buttons_comb = multiply(pressed_buttons_comb, buttons)
      checkcomb(indicator, buttons, pressed_buttons_comb, min+1)
    end
  end

  def multiply(pressed_buttons_comb, buttons) do
    Enum.reduce(pressed_buttons_comb, [], fn comb, new_combs->
      Enum.reduce(buttons, new_combs, fn button, new_combs ->
        [[button | comb] | new_combs]
      end)
    end)
  end

  def check_buttons(indicator, buttons) do
    0 == Enum.reduce(buttons, indicator, fn button, indicator -> Bitwise.bxor(button, indicator) end)
  end

end

File.read!("input.txt") |>
String.split("\n") |>
Enum.map(&Super.parse_line(&1)) |>
Enum.map(fn {indicator, buttons} ->
  Super.checkcomb(indicator, buttons, Enum.map(buttons, &[&1]), 1)
end) |> Enum.sum() |>
IO.inspect()
