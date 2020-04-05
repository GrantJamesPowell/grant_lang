defmodule Basex.Evaluator.BasicTest do
  use ExUnit.Case, async: true

  [
    {"1 + 1;", 2},
    {"(((3 * 4) + 6) / 2) ** 2;", 81},
    {"(1 != 2) || (3 == 4) || ((5 > 6) && (7 < 8)) || (10 <= 11) && (12 >= 13);", true},
    {"$a <- 1; $a + 2;", 3}
  ]
  |> Enum.each(fn {code, result} ->
    test "code \"#{code}\" evaluates to (#{result})" do
      assert Basex.eval(unquote(code)) == {:ok, unquote(result)}
    end
  end)
end
