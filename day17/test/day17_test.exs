defmodule Day17Test do
  use ExUnit.Case
  doctest Day17

  @tag :skip
  test "loads initial state" do
    active_set = Day17.load_initial("test/input.txt")

    refute MapSet.member?(active_set, {0, 0, 0})
    assert MapSet.member?(active_set, {1, 0, 0})
    refute MapSet.member?(active_set, {1, 1, 0})
    assert MapSet.member?(active_set, {2, 2, 0})
  end

  test "loads initial state 4d" do
    active_set = Day17.load_initial("test/input.txt")

    refute MapSet.member?(active_set, {0, 0, 0, 0})
    assert MapSet.member?(active_set, {1, 0, 0, 0})
    refute MapSet.member?(active_set, {1, 1, 0, 0})
    assert MapSet.member?(active_set, {2, 2, 0, 0})
  end

  @tag :skip
  test "print set" do
    Day17.print(Day17.load_initial("test/input.txt"))
  end

  @tag :skip
  test "calculate universe" do
    active_set = Day17.load_initial("test/input.txt")

    assert Day17.universe(active_set) |> Enum.count() == 75
  end

  @tag :skip
  test "inspect neighborhood" do
    active_set = Day17.load_initial("test/input.txt")
    assert Day17.neighbors(active_set, {1, 3, -1}) == 3
    assert Day17.neighbors(active_set, {2, 2, -1}) == 3
    assert Day17.neighbors(active_set, {0, 1, -1}) == 3
    assert Day17.neighbors(active_set, {1, 1, -1}) == 5
    assert Day17.neighbors(active_set, {3, 1, -1}) == 2
    assert Day17.neighbors(active_set, {3, 2, -1}) == 2
  end

  @tag :skip
  test "take a step" do
    active_set = Day17.load_initial("test/input.txt")
    step1 = Day17.step(active_set)
    assert MapSet.member?(step1, {0, 1, -1})
    assert MapSet.member?(step1, {2, 2, -1})
    assert MapSet.member?(step1, {1, 3, -1})
    refute MapSet.member?(step1, {1, 0, -1})
    assert Enum.count(step1) == 11
    Day17.print(step1)
  end

  @tag :skip
  test "take 6 steps" do
    active_set = Day17.load_initial("test/input.txt")

    step6 = 0..5 |> Enum.reduce(active_set, fn _iter, current_set -> Day17.step(current_set) end)

    assert Enum.count(step6) == 112
  end

  test "take 6 steps 4d" do
    active_set = Day17.load_initial("test/input.txt")

    step6 = 0..5 |> Enum.reduce(active_set, fn _iter, current_set -> Day17.step(current_set) end)

    assert Enum.count(step6) == 848
  end

  @tag :skip
  test "calculate neighborhood" do
    assert Day17.neighborhood({5, 1, 1}) ==
             MapSet.new([
               {4, 0, 0},
               {5, 0, 0},
               {6, 0, 0},
               {4, 1, 0},
               {5, 1, 0},
               {6, 1, 0},
               {4, 2, 0},
               {5, 2, 0},
               {6, 2, 0},
               {4, 0, 1},
               {5, 0, 1},
               {6, 0, 1},
               {4, 1, 1},
               {6, 1, 1},
               {4, 2, 1},
               {5, 2, 1},
               {6, 2, 1},
               {4, 0, 2},
               {5, 0, 2},
               {6, 0, 2},
               {4, 1, 2},
               {5, 1, 2},
               {6, 1, 2},
               {4, 2, 2},
               {5, 2, 2},
               {6, 2, 2}
             ])
  end
end
