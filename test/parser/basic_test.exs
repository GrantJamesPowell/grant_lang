defmodule Basex.Parser.BasicTest do
  use ExUnit.Case, async: true

  [
    # Literals
    {"1;", [1]},
    {"1.0;", [1.0]},
    {"true;", [true]},
    {"false;", [false]},
    {"true; false;", [true, false]},
    {"nil;", [nil]},
    # Maps 
    {"&{};", [{:map, []}]},
    {"&{ 1 => 2, 3 => 4};", [{:map, [{1, 2}, {3, 4}]}]},
    {"&{ (1 + 1) => (2 + 2)};", [{:map, [{{:+, 1, 1}, {:+, 2, 2}}]}]},
    {"$foo[1];", [{:index, {:var, "$foo"}, 1}]},
    {"&{1 => 2}[1];", [{:index, {:map, [{1, 2}]}, 1}]},
    {"&{\"foo\" => 2}.foo;", [{:dot, {:map, [{"foo", 2}]}, "foo"}]},
    # Strings
    {"\"foo\";", ["foo"]},
    # Arrays
    {"[];", [{:array, []}]},
    {"[1];", [{:array, [1]}]},
    {"[1, 2, 3];", [{:array, [1, 2, 3]}]},
    {"[1, 2, (3 + 4)];", [{:array, [1, 2, {:+, 3, 4}]}]},
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
    # Blocks
    {"if (true) {};", [{:if, true, [nil], [nil]}]},
    {"if (true) { 1 + 2; };", [{:if, true, [{:+, 1, 2}], [nil]}]},
    {"if (false) {} else { 3 + 4; };", [{:if, false, [nil], [{:+, 3, 4}]}]},
    # For Loops
    {"for $i <- [1,2,3] { $i + 1 }",
     [{:for, {{:var, "$i"}, {:var, :unused}}, {:array, [1, 2, 3]}, [{:+, {:var, "$i"}, 1}]}]},
    {"for $i, $v <- [1,2] { $i + $v }",
     [{:for, {{:var, "$i"}, {:var, "$v"}}, {:array, [1, 2]}, [{:+, {:var, "$i"}, {:var, "$v"}}]}]},
    # While Loops
    {"while (true) { 1 }", [{:while, true, [1]}]}
  ]
  |> Enum.each(fn {code, expected} ->
    test "It can parse literal \"#{code}\" into #{inspect(Macro.escape(expected))}" do
      {:ok, parsed} = Basex.parse(unquote(code))
      assert parsed == unquote(Macro.escape(expected))
    end
  end)
end
