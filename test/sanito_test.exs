defmodule SanitoTest do
  use ExUnit.Case
  doctest Sanito

  test "greets the world" do
    assert Sanito.hello() == :world
  end
end
