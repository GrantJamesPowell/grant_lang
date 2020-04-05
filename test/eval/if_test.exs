defmodule Basex.Evaluator.IfTest do
  use ExUnit.Case, async: true

  [
    {"if (true) { 1; };", 1},
    {"if (true) { 1; } else {};", 1},
    {"if (false) { 1; };", nil},
    {"if (false) { 1; } else { 2; };", 2},
    {"if (false) { 1; } else { 2 + 10; };", 12}
  ]
  |> Enum.each(fn {code, result} ->
    test "code \"#{code}\" evaluates to (#{result})" do
      assert Basex.eval(unquote(code)) == {:ok, unquote(result)}
    end
  end)
end
