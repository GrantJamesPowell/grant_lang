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
    {"9 == 10;", [{:==, 9, 10}]}
  ]
  |> Enum.each(fn {code, expected} ->
    test "It can parse literal \"#{code}\" into #{inspect(Macro.escape(expected))}" do
      assert Basex.parse(unquote(code)) == unquote(Macro.escape(expected))
    end
  end)
end
