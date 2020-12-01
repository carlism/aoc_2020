defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "reads a file" do
    assert Day1.read_lines("test/data/test_input.txt") != nil
  end

  test "reads a file of 6 values" do
    assert Enum.count(Day1.read_lines("test/data/test_input.txt")) == 6
  end

  test "reads a file of 6 numbers" do
    assert Enum.sum(Day1.read_numbers("test/data/test_input.txt")) == 5496
  end

  test "all pairs" do
    r =
      Day1.read_numbers("test/data/test_input.txt")
      |> Day1.all_pairs()

    assert Enum.count(r) == 36
  end

  test "find sum" do
    {x, y} =
      Day1.read_numbers("test/data/test_input.txt")
      |> Day1.all_pairs()
      |> Day1.find_sum(2020)

    assert x + y == 2020
  end

  test "answer" do
    {x, y} =
      Day1.read_numbers("test/data/test_input.txt")
      |> Day1.all_pairs()
      |> Day1.find_sum(2020)

    assert x * y == 514_579
  end

  test "part 2 answer" do
    {x, y, z} =
      Day1.read_numbers("test/data/test_input.txt")
      |> Day1.all_trios()
      |> Day1.find_sum(2020)

    assert x * y * z == 241_861_950
  end
end
