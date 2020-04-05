defmodule Basex.Evaluator.IndexingTest do
  use ExUnit.Case, async: true

  [
    {"$foo <- &{ 1 => 2 }; $foo[1];", 2},
    {"$foo <- &{ 1 => 2 }; $foo[42];", nil},
    {"&{ 1 => 2 }[1];", 2}
  ]
  |> Enum.each(fn {code, result} ->
    test "code \"#{code}\" evaluates to (#{result})" do
      assert Basex.eval(unquote(code)) == {:ok, unquote(result)}
    end
  end)
end
