defmodule Day11Test do
  use ExUnit.Case
  doctest Day11

  test "parses the file" do
    assert Day11.read_seats("test/input.txt") |> Enum.count() == 100
  end

  test "calculates a neighborhood" do
    assert Day11.neighborhood({0, 0}) |> Enum.count() == 8
  end

  test "calculates a step" do
    assert Day11.read_seats("test/input.txt") |> Day11.step() |> Map.fetch!({0, 0}) == "#"
    assert Day11.read_seats("test/input.txt") |> Day11.step() |> Map.fetch!({4, 1}) == "."
    assert Day11.read_seats("test/input.txt") |> Day11.step() |> Map.fetch!({5, 2}) == "#"
  end

  test "calculates occupied seats" do
    assert Day11.read_seats("test/input.txt") |> Day11.occupied_seats() == 0
    assert Day11.read_seats("test/input.txt") |> Day11.step() |> Day11.occupied_seats() == 71

    assert Day11.read_seats("test/input.txt")
           |> Day11.step()
           |> Day11.step()
           |> Day11.occupied_seats() == 20
  end

  test "find stabilization" do
    assert Day11.read_seats("test/input.txt") |> Day11.stabilize() |> Day11.occupied_seats() == 37
  end

  test "neighborhood the second" do
    assert Day11.read_seats("test/input.txt")
           |> Day11.neighborhood2({0, 0}) == [nil, nil, nil, nil, "L", nil, "L", "L"]

    assert Day11.read_seats("test/input.txt")
           |> Day11.neighborhood2({4, 6}) == ["L", "L", "L", "L", "L", "L", "L", "L"]
  end

  test "find stabilization the second" do
    assert Day11.read_seats("test/input.txt")
           |> Day11.stabilize(&Day11.step2/1)
           |> Day11.occupied_seats() == 26
  end
end
