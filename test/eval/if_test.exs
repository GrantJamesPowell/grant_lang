defmodule Basex.Evaluator.IfTest do
  use ExUnit.Case, async: true

  [
    {"if (true) { 1; };", 1},
    {"if (false) { 1; };", nil},
  ]
  |> Enum.each(fn {code, result} ->
    test "code \"#{code}\" evaluates to (#{result})" do
      assert Basex.eval(unquote(code)) == {:ok, unquote(result)}
    end
  end)
end
