defmodule CortExTest do
  use ExUnit.Case
  doctest CortEx

  test "greets the world" do
    assert CortEx.hello() == :world
  end
end
