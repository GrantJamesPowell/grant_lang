defmodule Basex.Tokenizer.BasicTest do
  use ExUnit.Case, async: true

  [
    # Program Constructs
    {"1; 2", [{:int, 1, 1}, {';', 1}, {:int, 1, 2}]},
    {"-1", [{:int, 1, -1}]},
    {"if (true) { 1; }",
     [
       {:if, 1},
       {:"(", 1},
       {:bool, 1, true},
       {:")", 1},
       {:"{", 1},
       {:int, 1, 1},
       {';', 1},
       {:"}", 1}
     ]},
    {"if (true || false) { 1; } else { 2; }",
     [
       {:if, 1},
       {:"(", 1},
       {:bool, 1, true},
       {:||, 1},
       {:bool, 1, false},
       {:")", 1},
       {:"{", 1},
       {:int, 1, 1},
       {';', 1},
       {:"}", 1},
       {:else, 1},
       {:"{", 1},
       {:int, 1, 2},
       {';', 1},
       {:"}", 1}
     ]},
    {"  \n\s\t", []},
    # Literals
    {"true", [{:bool, 1, true}]},
    {"false", [{:bool, 1, false}]},
    {"nil", [{nil, 1}]},
    {"1", [{:int, 1, 1}]},
    {"1.0", [{:float, 1, 1.0}]},
    # Maps
    {"&{ 1 => 2, 3 => 4}",
     [
       {:"&{", 1},
       {:int, 1, 1},
       {:"=>", 1},
       {:int, 1, 2},
       {:",", 1},
       {:int, 1, 3},
       {:"=>", 1},
       {:int, 1, 4},
       {:"}", 1}
     ]},
    # Dot Access
    {"$foo.bar", [{:var, 1, "$foo"}, {:dot, 1}, {:identifier, 1, "bar"}]},
    # Strings
    {"\"foo\"", [{:string, 1, "foo"}]},
    # Groupings
    {"(1)", [{:"(", 1}, {:int, 1, 1}, {:")", 1}]},
    {"[2]", [{:"[", 1}, {:int, 1, 2}, {:"]", 1}]},
    {"{3}", [{:"{", 1}, {:int, 1, 3}, {:"}", 1}]},
    {"[1, 2]", [{:"[", 1}, {:int, 1, 1}, {:",", 1}, {:int, 1, 2}, {:"]", 1}]},
    # Operators
    {"1 + 1", [{:int, 1, 1}, {:+, 1}, {:int, 1, 1}]},
    {"2 - 2", [{:int, 1, 2}, {:-, 1}, {:int, 1, 2}]},
    {"3 * 3", [{:int, 1, 3}, {:*, 1}, {:int, 1, 3}]},
    {"4 / 4", [{:int, 1, 4}, {:/, 1}, {:int, 1, 4}]},
    # Comparisons
    {"6 < 6", [{:int, 1, 6}, {:<, 1}, {:int, 1, 6}]},
    {"7 > 7", [{:int, 1, 7}, {:>, 1}, {:int, 1, 7}]},
    {"8 == 8", [{:int, 1, 8}, {:==, 1}, {:int, 1, 8}]},
    {"9 <= 9", [{:int, 1, 9}, {:<=, 1}, {:int, 1, 9}]},
    {"10 >= 10", [{:int, 1, 10}, {:>=, 1}, {:int, 1, 10}]},
    {"11 != 12", [{:int, 1, 11}, {:!=, 1}, {:int, 1, 12}]},
    # Boolean Logic
    {"true || true", [{:bool, 1, true}, {:||, 1}, {:bool, 1, true}]},
    {"false && true", [{:bool, 1, false}, {:&&, 1}, {:bool, 1, true}]},
    {"!false", [{:!, 1}, {:bool, 1, false}]},
    # Assignment
    {"$a", [{:var, 1, "$a"}]},
    {"$a123", [{:var, 1, "$a123"}]},
    {"$a <- 11", [{:var, 1, "$a"}, {:<-, 1}, {:int, 1, 11}]},
    {"$a <- $b", [{:var, 1, "$a"}, {:<-, 1}, {:var, 1, "$b"}]},
    # Comments
    {"//foo\n", []},
    {"1; //foo\n", [{:int, 1, 1}, {';', 1}]},
    {"1; //foo\n 2;", [{:int, 1, 1}, {';', 1}, {:int, 2, 2}, {';', 2}]},
    {"/**/", []},
    {"/* FOO /* NESTED */ BAR */", []},
    {"/* FOO /* // NESTED \n */ BAR */", []},
    {"1 /* TEST */ + 2", [{:int, 1, 1}, {:+, 1}, {:int, 1, 2}]},
    # Indexing
    {"$foo[1]", [{:var, 1, "$foo"}, {:"[", 1}, {:int, 1, 1}, {:"]", 1}]},
    # For loops
    {"for $i <- [1,2,3] { $i + 1 }",
     [
       {:for, 1},
       {:var, 1, "$i"},
       {:<-, 1},
       {:"[", 1},
       {:int, 1, 1},
       {:",", 1},
       {:int, 1, 2},
       {:",", 1},
       {:int, 1, 3},
       {:"]", 1},
       {:"{", 1},
       {:var, 1, "$i"},
       {:+, 1},
       {:int, 1, 1},
       {:"}", 1}
     ]},
    # While Loops
    {"while (true) { 1 }",
     [{:while, 1}, {:"(", 1}, {:bool, 1, true}, {:")", 1}, {:"{", 1}, {:int, 1, 1}, {:"}", 1}]},
    # Increment / Decrement
    {"$i++", [{:var, 1, "$i"}, {:++, 1}]},
    {"$i--", [{:var, 1, "$i"}, {:--, 1}]},
    # ||=
    {"$i ||= 2", [{:var, 1, "$i"}, {:"||=", 1}, {:int, 1, 2}]},
    {"$i ||= $j", [{:var, 1, "$i"}, {:"||=", 1}, {:var, 1, "$j"}]}
  ]
  |> Enum.each(fn {test_case, expected} ->
    test "it tokenizes \"#{test_case}\" correctly" do
      {:ok, tokens, _} = Basex.tokenize(unquote(Macro.escape(test_case)))
      assert tokens == unquote(Macro.escape(expected))
    end
  end)
end
