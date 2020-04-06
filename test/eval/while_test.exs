defmodule Basex.Evaluator.WhileTest do
  use ExUnit.Case, async: true

  [
    {"$i <- 1; while false { $i <- 2 }; $i", 1},
    {"$i <- 1; while true { break }; $i", 1},
    {"$i <- 1; while $i < 4 { $i <- $i + 1 }; $i", 4},
    {"$i <- 1; while true { $i <- $i + 1; if $i > 4 { break } }; $i", 5}
  ]
  |> Enum.each(fn {code, result} ->
    test "code \"#{code}\" evaluates to (#{result})" do
      assert Basex.eval(unquote(code)) == {:ok, unquote(result)}
    end
  end)
end
