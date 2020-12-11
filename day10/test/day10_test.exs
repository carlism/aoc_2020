defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  test "find differences" do
    assert Day10.read_input("test/input.txt")
           |> Day10.difference_distribution() ==
             [0, 7, 0, 4]
  end

  test "find differences 2" do
    assert Day10.read_input("test/input.1.txt")
           |> Day10.difference_distribution() ==
             [0, 22, 0, 9]
  end
end
