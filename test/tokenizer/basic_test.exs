defmodule Basex.Tokenizer.BasicTest do
  use ExUnit.Case, async: true

  [
    # Program Constructs
    {"1; 2", [{:int, 1, 1}, {:statement_end, 1}, {:int, 1, 2}]},
    {"  \n\s\t", []},
    # Literals
    {"true", [{:bool, 1, true}]},
    {"false", [{:bool, 1, false}]},
    {"1", [{:int, 1, 1}]},
    {"1.0", [{:float, 1, 1.0}]},
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
    {"6 < 6", [{:int, 1, 6}, {:comparator, 1, :<}, {:int, 1, 6}]},
    {"7 > 7", [{:int, 1, 7}, {:comparator, 1, :>}, {:int, 1, 7}]},
    {"8 == 8", [{:int, 1, 8}, {:comparator, 1, :==}, {:int, 1, 8}]},
    {"9 <= 9", [{:int, 1, 9}, {:comparator, 1, :<=}, {:int, 1, 9}]},
    {"10 >= 10", [{:int, 1, 10}, {:comparator, 1, :>=}, {:int, 1, 10}]},
    # Assignment
    {"11 = 11", [{:int, 1, 11}, {:=, 1}, {:int, 1, 11}]}
  ]
  |> Enum.each(fn {test_case, expected} ->
    test "it tokenizes \"#{test_case}\" to be #{inspect(Macro.escape(expected))}" do
      {:ok, tokens, _} = Basex.tokenize(unquote(Macro.escape(test_case)))
      assert tokens == unquote(Macro.escape(expected))
    end
  end)
end
