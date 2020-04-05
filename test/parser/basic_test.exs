defmodule Basex.Parser.BasicTest do
  use ExUnit.Case, async: true

  [
    # Literals
    {"1;", [1]},
    {"1.0;", [1.0]},
    {"true;", [true]},
    {"false;", [false]},
    {"true; false;", [true, false]},
    # Strings
    {"\"foo\";", ["foo"]},
    # Arrays
    {"[];", [[]]},
    {"[1];", [[1]]},
    {"[1, 2, 3];", [[1, 2, 3]]},
    {"[1, 2, (3 + 4)];", [[1, 2, {:+, 3, 4}]]},
    # Operators
    {"1 > 2;", [{:>, 1, 2}]},
    {"3 < 4;", [{:<, 3, 4}]},
    {"5 >= 6;", [{:>=, 5, 6}]},
    {"7 <= 8;", [{:<=, 7, 8}]},
    {"9 == 10;", [{:==, 9, 10}]},
    {"11 != 12;", [{:!=, 11, 12}]},
    {"1 - 2;", [{:-, 1, 2}]},
    {"3 + 4;", [{:+, 3, 4}]},
    {"5 * 6;", [{:*, 5, 6}]},
    {"7 / 8;", [{:/, 7, 8}]},
    {"true || false;", [{:||, true, false}]},
    {"false && true;", [{:&&, false, true}]},
    # Parens
    {"(2 + 3) * 4;", [{:*, {:+, 2, 3}, 4}]},
    {"((2 + 3) * 4) - 5;", [{:-, {:*, {:+, 2, 3}, 4}, 5}]},
    {"$a <- 2;", [{:<-, {:var, "$a"}, 2}]},
    # Comments
    {"12 + /* COMMENT */ 13;", [{:+, 12, 13}]},
    {"12 + 13; // foo\n", [{:+, 12, 13}]},
    # blocks
    {"if (true) {};", [{:if_expression, true, [nil], [nil]}]},
    {"if (true) { 1 + 2; };", [{:if_expression, true, [{:+, 1, 2}], [nil]}]},
    {"if (false) {} else { 3 + 4; };", [{:if_expression, false, [nil], [{:+, 3, 4}]}]}
  ]
  |> Enum.each(fn {code, expected} ->
    test "It can parse literal \"#{code}\" into #{inspect(Macro.escape(expected))}" do
      {:ok, parsed} = Basex.parse(unquote(code))
      assert parsed == unquote(Macro.escape(expected))
    end
  end)
end
