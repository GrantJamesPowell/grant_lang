defmodule Basex.Evaluator.ForTest do
  use ExUnit.Case, async: true

  [
    {"for $i <- [1,2,3] { $i + 1 }", [2, 3, 4]},
    {"for $index, $value <- [1,2,3] { $index + $value }", [1, 3, 5]},
    {"for $value <- &{ 1 => 2} { $value + 1 }", %{1 => 3}},
    {"for $key, $value <- &{ 1 => 2] { [$key, $value] }", %{1 => [1, 2]}}
  ]
  |> Enum.each(fn {code, result} ->
    test "code \"#{code}\" evaluates to (#{inspect(result)})" do
      assert Basex.eval(unquote(code)) == {:ok, unquote(Macro.escape(result))}
    end
  end)
end
