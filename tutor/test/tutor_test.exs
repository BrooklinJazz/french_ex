defmodule TutorTest do
  use ExUnit.Case
  doctest Tutor

  test "greets the world" do
    assert Tutor.hello() == :world
  end
end
