defmodule Basex.Parser.BasicTest do
  use ExUnit.Case, async: true

  [
    {"1;", [1]},
    {"1.0;", [1.0]},
    {"true;", [true]},
    {"false;", [false]},
    {"true; false;", [true, false]},
    {"1 > 2;", [{:>, 1, 2}]},
    {"3 < 4;", [{:<, 3, 4}]},
    {"5 >= 6;", [{:>=, 5, 6}]},
    {"7 <= 8;", [{:<=, 7, 8}]},
    {"9 == 10;", [{:==, 9, 10}]},
    {"1 - 2;", [{:-, 1, 2}]},
    {"3 + 4;", [{:+, 3, 4}]},
    {"5 * 6;", [{:*, 5, 6}]},
    {"7 / 8;", [{:/, 7, 8}]},
    {"true || false;", [{:||, true, false}]},
    {"false && true;", [{:&&, false, true}]},
    {"(2 + 3) * 4;", [{:*, {:+, 2, 3}, 4}]},
    {"((2 + 3) * 4) - 5;", [{:-, {:*, {:+, 2, 3}, 4}, 5}]},
    {"$a <- 2;", [{:<-, {:var, "$a"}, 2}]},
    {"[];", [[]]},
    {"[1];", [[1]]},
    {"[1, 2, 3];", [[1, 2, 3]]},
    {"[1, 2, (3 + 4)];", [[1, 2, {:+, 3, 4}]]}
  ]
  |> Enum.each(fn {code, expected} ->
    test "It can parse literal \"#{code}\" into #{inspect(Macro.escape(expected))}" do
      {:ok, parsed} = Basex.parse(unquote(code))
      assert parsed == unquote(Macro.escape(expected))
    end
  end)
end
