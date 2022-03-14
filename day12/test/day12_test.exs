defmodule Day12Test do
  use ExUnit.Case
  doctest Day12

  test "all turns are a multiple of 90deg" do
    Enum.each(["test/input.txt", "input.txt"], fn filename ->
      assert Day12.read_data(filename)
             |> Stream.filter(fn {x, _y} -> x == "R" || x == "L" end)
             |> Stream.filter(fn {_x, y} -> rem(y, 90) != 0 end)
             |> Enum.count() ==
               0
    end)
  end

  test "known turn values" do
    Day12.read_data("input.txt")
    |> Stream.filter(fn {x, _y} -> x == "R" || x == "L" end)
    |> Enum.uniq()
  end

  test "directional movement" do
    assert {{0, -1}, {"N", 5}} |> Day12.calc_change() == {{0, -1}, {5, 0}}
    assert {{0, -1}, {"S", 5}} |> Day12.calc_change() == {{0, -1}, {-5, 0}}
    assert {{0, -1}, {"E", 5}} |> Day12.calc_change() == {{0, -1}, {0, 5}}
    assert {{0, -1}, {"W", 5}} |> Day12.calc_change() == {{0, -1}, {0, -5}}

    assert {{0, -1}, {"F", 5}} |> Day12.calc_change() == {{0, -1}, {0, -5}}
    assert {{0, 1}, {"F", 5}} |> Day12.calc_change() == {{0, 1}, {0, 5}}
    assert {{1, 0}, {"F", 5}} |> Day12.calc_change() == {{1, 0}, {5, 0}}
    assert {{-1, 0}, {"F", 5}} |> Day12.calc_change() == {{-1, 0}, {-5, 0}}
  end

  test "turns" do
    assert {{0, -1}, {"R", 90}} |> Day12.calc_change() == {{1, 0}, {0, 0}}
    assert {{0, -1}, {"R", 180}} |> Day12.calc_change() == {{0, 1}, {0, 0}}
    assert {{0, -1}, {"R", 270}} |> Day12.calc_change() == {{-1, 0}, {0, 0}}
    assert {{0, -1}, {"R", 360}} |> Day12.calc_change() == {{0, -1}, {0, 0}}

    assert {{0, -1}, {"L", 90}} |> Day12.calc_change() == {{-1, 0}, {0, 0}}
    assert {{0, -1}, {"L", 180}} |> Day12.calc_change() == {{0, 1}, {0, 0}}
    assert {{0, -1}, {"L", 270}} |> Day12.calc_change() == {{1, 0}, {0, 0}}
    assert {{0, -1}, {"L", 360}} |> Day12.calc_change() == {{0, -1}, {0, 0}}
  end

  test "calc_all" do
    assert Day12.read_data("test/input.txt") |> Day12.calc_distances() |> Enum.to_list() == [
             {0, 10},
             {3, 0},
             {0, 7},
             {0, 0},
             {-11, 0}
           ]
  end

  test "sum up distances" do
    assert Day12.read_data("test/input.txt") |> Day12.calc_distances() |> Day12.sum_distances() ==
             {-8, 17}
  end

  test "waypoint rotate" do
    assert Position.rotate(%Position{x: 10, y: 1}, 90) == %Position{x: 1, y: -10}
    assert Position.rotate(%Position{x: 1, y: -10}, 90) == %Position{x: -10, y: -1}
    assert Position.rotate(%Position{x: -10, y: -1}, 90) == %Position{x: -1, y: 10}
    assert Position.rotate(%Position{x: -1, y: 10}, 90) == %Position{x: 10, y: 1}
  end

  test "waypoint nav" do
    assert Day12.read_data("test/input.txt") |> Day12.navigate() == %State{
             ship: %Position{x: 214, y: -72},
             waypoint: %Position{x: 4, y: -10}
           }
  end
end
