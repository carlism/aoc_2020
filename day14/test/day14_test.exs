defmodule Day14Test do
  use ExUnit.Case
  doctest Day14

  test "does the thing" do
    assert Day14.process("test/input.txt") == 165
  end

  test "does the other thing" do
    assert Day14.process_v2("test/input_v2.txt") == 208
  end
end
