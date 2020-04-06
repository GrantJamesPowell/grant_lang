defmodule Basex.Evaluator.BasicTest do
  use ExUnit.Case, async: true

  [
    {"1 + 1;", 2},
    {"\"foo\";", "foo"},
    {"$foo <- &{ 1 => 1 + 2 }; $foo;", %{1 => 3}},
    {"(((3 * 4) + 6) / 2) ** 2;", 81},
    {"(1 != 2) || (3 == 4) || ((5 > 6) && (7 < 8)) || (10 <= 11) && (12 >= 13);", true},
    {"$a <- 1; $a + 2;", 3},
    {"$i <- 1; $i++; $i", 2},
    {"$i <- 1; $i--; $i", 0},
    {"$i <- 1; $i ||= 4; $i", 1},
    {"$i ||= 4; $i", 4},
    {"$i ||= (10 * 2); $i", 20},
    {"!true", false},
    {"$i <- false; !$i", true}
  ]
  |> Enum.each(fn {code, result} ->
    test "code \"#{code}\" evaluates to (#{inspect(result)})" do
      assert Basex.eval(unquote(code)) == {:ok, unquote(Macro.escape(result))}
    end
  end)
end
