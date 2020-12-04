defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  test "reads test stream" do
    assert Enum.count(Day3.read_data("test/data/test_input.txt")) == 11
  end

  test "read parses terrain" do
    assert Day3.read_data("test/data/test_input.txt")
           |> Stream.take(1)
           |> Enum.to_list()
           |> List.first()
           |> Enum.count() ==
             11
  end

  test "make path" do
    assert Day3.read_data("test/data/test_input.txt")
           |> Day3.make_path(3)
           |> Enum.to_list() == [".", ".", "#", ".", "#", "#", ".", "#", "#", "#", "#"]
  end

  test "count trees" do
    assert Day3.read_data("test/data/test_input.txt")
           |> Day3.make_path(3)
           |> Enum.count(fn x -> x == "#" end) == 7
  end

  test "path with skip" do
    assert Day3.read_data("test/data/test_input.txt")
           |> Day3.make_path(1, 2)
           |> Enum.to_list() == [".", "#", ".", "#", ".", "."]
  end

  test "multiple paths" do
    assert [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
           |> Enum.map(fn {right, down} ->
             Day3.read_data("test/data/test_input.txt")
             |> Day3.make_path(right, down)
             |> Enum.count(fn x -> x == "#" end)
           end)
           |> Enum.reduce(&(&1 * &2)) == 336
  end
end
