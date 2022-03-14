defmodule Day15Test do
  use ExUnit.Case
  doctest Day15

  test "adds turns" do
    state = Day15.record_turn(%{}, 1, 0)
    assert state == %{0 => [1]}

    state = Day15.record_turn(state, 2, 3)
    assert state == %{0 => [1], 3 => [2]}

    state = Day15.record_turn(state, 3, 6)
    assert state == %{0 => [1], 3 => [2], 6 => [3]}

    state = Day15.record_turn(state, 4, 0)
    assert state == %{0 => [4, 1], 3 => [2], 6 => [3]}

    state = Day15.record_turn(state, 5, 3)
    assert state == %{0 => [4, 1], 3 => [5, 2], 6 => [3]}

    state = Day15.record_turn(state, 6, 3)
    assert state == %{0 => [4, 1], 3 => [6, 5], 6 => [3]}

    state = Day15.record_turn(state, 7, 1)
    assert state == %{0 => [4, 1], 3 => [6, 5], 6 => [3], 1 => [7]}

    state = Day15.record_turn(state, 8, 0)
    assert state == %{0 => [8, 4], 3 => [6, 5], 6 => [3], 1 => [7]}

    state = Day15.record_turn(state, 9, 4)
    assert state == %{0 => [8, 4], 3 => [6, 5], 6 => [3], 1 => [7], 4 => [9]}
  end

  test "next turn" do
    state = Day15.record_turn(%{}, 1, 0)
    state = Day15.record_turn(state, 2, 3)
    state = Day15.record_turn(state, 3, 6)
    next_turn = Day15.next_turn(state, 6)
    state = Day15.record_turn(state, 4, next_turn)
    assert next_turn == 0
    next_turn = Day15.next_turn(state, next_turn)
    state = Day15.record_turn(state, 5, next_turn)
    assert next_turn == 3
    next_turn = Day15.next_turn(state, next_turn)
    state = Day15.record_turn(state, 6, next_turn)
    assert next_turn == 3
    next_turn = Day15.next_turn(state, next_turn)
    state = Day15.record_turn(state, 7, next_turn)
    assert next_turn == 1
    next_turn = Day15.next_turn(state, next_turn)
    state = Day15.record_turn(state, 8, next_turn)
    assert next_turn == 0
    next_turn = Day15.next_turn(state, next_turn)
    state = Day15.record_turn(state, 9, next_turn)
    assert next_turn == 4
    next_turn = Day15.next_turn(state, next_turn)
    _state = Day15.record_turn(state, 10, next_turn)
    assert next_turn == 0
  end

  test "run for 2020 turns" do
    assert Day15.play([0, 3, 6], 4) == 0
    assert Day15.play([0, 3, 6], 9) == 4
    assert Day15.play([0, 3, 6], 2020) == 436
    assert Day15.play([1, 3, 2], 2020) == 1
    assert Day15.play([2, 1, 3], 2020) == 10
    assert Day15.play([1, 2, 3], 2020) == 27
    assert Day15.play([2, 3, 1], 2020) == 78
    assert Day15.play([3, 2, 1], 2020) == 438
    assert Day15.play([3, 1, 2], 2020) == 1836
    assert Day15.play([8, 13, 1, 0, 18, 9], 2020) == 755
  end

  test "run for 30000000th number" do
    # assert Day15.play([0, 3, 6], 30_000_000) == 175_594
    # assert Day15.play([1, 3, 2], 30_000_000) == 2578
    # assert Day15.play([2, 1, 3], 30_000_000) == 3_544_142
    # assert Day15.play([1, 2, 3], 30_000_000) == 261_214
    # assert Day15.play([2, 3, 1], 30_000_000) == 6_895_259
    # assert Day15.play([3, 2, 1], 30_000_000) == 18
    # assert Day15.play([3, 1, 2], 30_000_000) == 362
    assert Day15.play([8, 13, 1, 0, 18, 9], 30_000_000) == 11962
  end
end
