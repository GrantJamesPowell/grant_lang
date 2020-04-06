defmodule Basex.Evaluator.ForTest do
  use ExUnit.Case, async: true

  [
    {"for $i <- [1,2,3] { $i + 1 }", [2, 3, 4]},
    {"for $index, $value <- [1,2,3] { $index + $value }", [1, 3, 5]}
  ]
  |> Enum.each(fn {code, result} ->
    test "code \"#{code}\" evaluates to (#{result})" do
      assert Basex.eval(unquote(code)) == {:ok, unquote(result)}
    end
  end)
end
