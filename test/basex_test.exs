defmodule BasexTest do
  use ExUnit.Case
  doctest Basex

  test "greets the world" do
    assert Basex.hello() == :world
  end
end
