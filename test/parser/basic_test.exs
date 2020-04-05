defmodule Basex.Parser.BasicTest do
  use ExUnit.Case, async: true

  [
    {"1;", [1]},
    {"1.0;", [1.0]},
    {"true;", [true]},
    {"false;", [false]},
    {"true; false;", [true, false]}
  ]
  |> Enum.each(fn {code, expected} ->
    test "It can parse literal \"#{code}\" into #{inspect(expected)}" do
      assert Basex.parse(unquote(code)) == unquote(expected)
    end
  end)
end
