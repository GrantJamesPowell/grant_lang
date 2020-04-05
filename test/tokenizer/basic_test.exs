defmodule Basex.Tokenizer.BasicTest do
  use ExUnit.Case, async: true

  [
    # Program Constructs
    {"1; 2", [{:int, 1, 1}, {:statement_end, 1}, {:int, 1, 2}]},
    {"if (true) { 1; }",
     [
       {:if_block, 1},
       {:"(", 1},
       {:bool, 1, true},
       {:")", 1},
       {:"{", 1},
       {:int, 1, 1},
       {:statement_end, 1},
       {:"}", 1}
     ]},
    {"if (true || false) { 1; } else { 2; }",
     [
       {:if_block, 1},
       {:"(", 1},
       {:bool, 1, true},
       {:operator, 1, :||},
       {:bool, 1, false},
       {:")", 1},
       {:"{", 1},
       {:int, 1, 1},
       {:statement_end, 1},
       {:"}", 1},
       {:else_block, 1},
       {:"{", 1},
       {:int, 1, 2},
       {:statement_end, 1},
       {:"}", 1}
     ]},
    {"  \n\s\t", []},
    # Literals
    {"true", [{:bool, 1, true}]},
    {"false", [{:bool, 1, false}]},
    {"1", [{:int, 1, 1}]},
    {"1.0", [{:float, 1, 1.0}]},
    # Strings
    {"\"foo\"", [{:string, 1, "foo"}]},
    # Groupings
    {"(1)", [{:"(", 1}, {:int, 1, 1}, {:")", 1}]},
    {"[2]", [{:"[", 1}, {:int, 1, 2}, {:"]", 1}]},
    {"{3}", [{:"{", 1}, {:int, 1, 3}, {:"}", 1}]},
    {"[1, 2]", [{:"[", 1}, {:int, 1, 1}, {:",", 1}, {:int, 1, 2}, {:"]", 1}]},
    # Operators
    {"1 + 1", [{:int, 1, 1}, {:operator, 1, :+}, {:int, 1, 1}]},
    {"2 - 2", [{:int, 1, 2}, {:operator, 1, :-}, {:int, 1, 2}]},
    {"3 * 3", [{:int, 1, 3}, {:operator, 1, :*}, {:int, 1, 3}]},
    {"4 / 4", [{:int, 1, 4}, {:operator, 1, :/}, {:int, 1, 4}]},
    # Comparisons
    {"6 < 6", [{:int, 1, 6}, {:operator, 1, :<}, {:int, 1, 6}]},
    {"7 > 7", [{:int, 1, 7}, {:operator, 1, :>}, {:int, 1, 7}]},
    {"8 == 8", [{:int, 1, 8}, {:operator, 1, :==}, {:int, 1, 8}]},
    {"9 <= 9", [{:int, 1, 9}, {:operator, 1, :<=}, {:int, 1, 9}]},
    {"10 >= 10", [{:int, 1, 10}, {:operator, 1, :>=}, {:int, 1, 10}]},
    {"11 != 12", [{:int, 1, 11}, {:operator, 1, :!=}, {:int, 1, 12}]},
    # Boolean Logic
    {"true || true", [{:bool, 1, true}, {:operator, 1, :||}, {:bool, 1, true}]},
    {"false && true", [{:bool, 1, false}, {:operator, 1, :&&}, {:bool, 1, true}]},
    # Assignment
    {"$a", [{:var, 1, "$a"}]},
    {"$a123", [{:var, 1, "$a123"}]},
    {"$a <- 11", [{:var, 1, "$a"}, {:operator, 1, :<-}, {:int, 1, 11}]},
    {"$a <- $b", [{:var, 1, "$a"}, {:operator, 1, :<-}, {:var, 1, "$b"}]},
    # Comments
    {"//foo\n", []},
    {"1; //foo\n", [{:int, 1, 1}, {:statement_end, 1}]},
    {"1; //foo\n 2;", [{:int, 1, 1}, {:statement_end, 1}, {:int, 2, 2}, {:statement_end, 2}]},
    {"/**/", []},
    {"/* FOO /* NESTED */ BAR */", []},
    {"/* FOO /* // NESTED \n */ BAR */", []},
    {"1 /* TEST */ + 2", [{:int, 1, 1}, {:operator, 1, :+}, {:int, 1, 2}]}
  ]
  |> Enum.each(fn {test_case, expected} ->
    test "it tokenizes \"#{test_case}\" correctly" do
      {:ok, tokens, _} = Basex.tokenize(unquote(Macro.escape(test_case)))
      assert tokens == unquote(Macro.escape(expected))
    end
  end)
end
