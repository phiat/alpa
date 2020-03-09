defmodule AlpaTest do
  use ExUnit.Case
  doctest Alpa

  test "greets the world" do
    assert Alpa.hello() == :world
  end
end
