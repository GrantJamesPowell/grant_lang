defmodule Basex.Tokenizer.BasicTest do
  use ExUnit.Case, async: true

  [
    # Literals
    {"1", [{:int, 1, 1}]},
    {"1.0", [{:float, 1, 1.0}]},
    {"  \n\s\t", []},
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
    {"5 == 5", [{:int, 1, 5}, {:==, 1}, {:int, 1, 5}]},
    # Assignment
    {"6 = 6", [{:int, 1, 6}, {:=, 1}, {:int, 1, 6}]}
  ]
  |> Enum.each(fn {test_case, expected} ->
    test "it tokenizes \"#{test_case}\" to be #{inspect(Macro.escape(expected))}" do
      {:ok, tokens, _} = Basex.tokenize(unquote(Macro.escape(test_case)))
      assert tokens == unquote(Macro.escape(expected))
    end
  end)
end
