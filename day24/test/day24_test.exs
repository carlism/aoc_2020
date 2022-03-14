defmodule Day24Test do
  use ExUnit.Case
  doctest Day24

  test "read and parse" do
    assert Day24.read_input("test/input.txt") |> Enum.to_list() |> List.last() ==
             [:w, :se, :w, :e, :e, :e, :nw, :ne, :se, :nw, :w, :w, :sw, :ne, :w]
  end

  def is_odd(num) do
    rem(num, 2) != 0
  end

  test "walk each" do
    assert Day24.read_input("test/input.txt")
           |> Stream.map(&Day24.walk/1)
           |> Stream.map(&Day24.to_2d/1)
           |> Enum.sort()
           |> Stream.chunk_by(& &1)
           |> Stream.filter(fn visits -> is_odd(Enum.count(visits)) end)
           |> Enum.to_list()
           |> Enum.count() == 10
  end

  test "calc ranges" do
    black_tiles = Day24.initial_black_tiles("test/input.txt")

    {x_range, y_range} = Day24.space_ranges(black_tiles)
    assert {x_range, y_range} == {-6..6, -4..4}
  end

  test "neighborhood" do
    assert Day24.neighborhood({0, 0}) ==
             [{-1, 1}, {1, 1}, {-1, -1}, {-2, 0}, {1, -1}, {2, 0}]
  end

  test "days" do
    black_tiles = Day24.initial_black_tiles("test/input.txt")
    day1 = Day24.day(black_tiles)
    assert Enum.count(day1) == 15
    day2 = Day24.day(day1)
    assert Enum.count(day2) == 12
    day3 = Day24.day(day2)
    assert Enum.count(day3) == 25
    day4 = Day24.day(day3)
    assert Enum.count(day4) == 14
    day100 = Day24.days(black_tiles, 100)
    assert Enum.count(day100) == 2208
  end
end
