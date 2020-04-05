defmodule Basex.Evaluator.BasicTest do
  use ExUnit.Case, async: true

  [
    {"1 + 1;", 2},
    {"$a <- 1; $a + 2;", 3}
  ]
  |> Enum.each(fn {code, result} ->
    test "code \"#{code}\" evaluates to (#{result})" do
      assert Basex.eval(unquote(code)) == {:ok, unquote(result)}
    end
  end)
end
