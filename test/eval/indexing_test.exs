defmodule Basex.Evaluator.IndexingTest do
  use ExUnit.Case, async: true

  [
    # Maps
    # Bracket Access
    {"$foo <- &{ 1 => 2 }; $foo[1];", 2},
    {"$foo <- &{ 1 => 2 }; $foo[42];", nil},
    {"&{ 1 => 2 }[1];", 2},
    # Dot Access
    {"$foo <- &{ \"bar\" => 42 }; $foo.bar;", 42},
    # Arrays
    {"[1,2,3][0]", 1},
    {"[1 + 1][0]", 2},
    {"[1,2,3][1 + 1]", 3},
    {"$foo <- [1,2,3]; $foo[0]", 1}
  ]
  |> Enum.each(fn {code, result} ->
    test "code \"#{code}\" evaluates to (#{result})" do
      evaled = Basex.eval(unquote(code))
      assert evaled == {:ok, unquote(result)}
    end
  end)
end
