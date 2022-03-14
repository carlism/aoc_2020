defmodule Day23Test do
  use ExUnit.Case
  doctest Day23

  test "build cups" do
    assert Day23.cups("389125467") ==
             {3, %{7 => 3, 6 => 7, 4 => 6, 5 => 4, 2 => 5, 1 => 2, 9 => 1, 8 => 9, 3 => 8}}

    assert Day23.cups("389125467") |> Day23.cups_to_string() == "389125467"
  end

  test "moves" do
    assert Day23.move(Day23.cups("389125467")) |> Day23.cups_to_string() == "289154673"

    assert Day23.move(Day23.move(Day23.cups("389125467"))) |> Day23.cups_to_string() ==
             "546789132"
  end

  test "move 10 and collect" do
    cups = Day23.cups("389125467")
    ten_moves = 1..10 |> Enum.reduce(cups, fn _i, cups -> Day23.move(cups) end)
    assert ten_moves |> Day23.cups_to_string() == "837419265"
    assert ten_moves |> Day23.collect() == "92658374"
  end

  test "move 100 and collect" do
    cups = Day23.cups("389125467")
    hun_moves = 1..100 |> Enum.reduce(cups, fn _i, cups -> Day23.move(cups) end)
    assert hun_moves |> Day23.collect() == "67384529"
  end

  test "move 100 and collect, actual" do
    cups = Day23.cups("792845136")
    hun_moves = 1..100 |> Enum.reduce(cups, fn _i, cups -> Day23.move(cups) end)
    assert hun_moves |> Day23.collect() == "98742365"
  end

  test "million cups" do
    cups = Day23.cups("389125467")
    cups = Day23.millionize(cups)
    assert cups |> elem(1) |> Enum.count() == 1_000_000
  end

  @tag timeout: :infinity
  test "all the rest" do
    cups = Day23.cups("389125467")
    cups = Day23.millionize(cups)

    all_moves =
      1..10_000_000
      |> Enum.reduce(cups, fn i, cups ->
        Day23.move(cups)
      end)

    {_start, map} = all_moves

    star1 = Map.get(map, 1)
    star2 = Map.get(map, 934_001)
    assert star2 == 159_792
    assert star1 == 934_001
  end
end
