defmodule Day13Test do
  use ExUnit.Case
  doctest Day13

  test "reads file correctly" do
    assert Day13.read_data("test/input.txt") == {939, [7, 13, -1, -1, 59, -1, 31, 19]}
  end

  test "compute departures at time" do
    assert Day13.departures_at(939, [7, 13, 59, 31, 19]) == [false, false, false, false, false]
    assert Day13.departures_at(944, [7, 13, 59, 31, 19]) == [false, false, true, false, false]
  end

  test "find next departure" do
    assert Day13.next_departure(939, [7, 13, 59, 31, 19]) == {944, [59]}
  end

  test "find sequenced departure" do
    {_, buses} = Day13.read_data("test/input.txt")

    assert Day13.find_sequenced_departures(buses) == 1_068_781
    assert Day13.find_sequenced_departures([17, -1, 13, 19]) == 3417
    assert Day13.find_sequenced_departures([67, 7, 59, 61]) == 754_018
    assert Day13.find_sequenced_departures([67, -1, 7, 59, 61]) == 779_210
    assert Day13.find_sequenced_departures([67, 7, -1, 59, 61]) == 1_261_476
    assert Day13.find_sequenced_departures([1789, 37, 47, 1889]) == 1_202_161_486

    assert Day13.find_sequenced_departures([17, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 37]) ==
             544

    # assert Day13.find_sequenced_departures([
    #          17, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 37, -1, -1, -1, -1, -1, 439
    #        ]) == 171_632

    # assert rem(171_632 - 544, 17 * 37) == 0

    # assert Day13.find_sequenced_departures([
    #          17, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 37, -1, -1, -1, -1, -1, 439, -1, 29
    #        ]) == 171_632

    # assert Day13.find_sequenced_departures([
    #          17, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 37, -1, -1, -1, -1, -1, 439, -1, 29, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 13
    #        ]) == 48_218_426

    assert BasicMath.lcm(7, 13) == 91
    assert BasicMath.lcm(7, 13) |> BasicMath.lcm(59) == 5369
    assert BasicMath.lcm([7, 13, 59]) == 5369
    assert BasicMath.lcm([7, 13, 59, 29]) == 155_701
    assert rem(48_218_426 - 171_632, BasicMath.lcm([17, 37, 439])) == 0
  end

  test "filter and offsets" do
    {_, buses} = Day13.read_data("test/input.txt")
    assert Day13.filter_and_add_offsets(buses) == [{7, 0}, {13, 1}, {59, 4}, {31, 6}, {19, 7}]
  end

  test "version 2" do
    {_, buses} = Day13.read_data("test/input.txt")

    assert Day13.find_sequenced_departures_2(buses) == 1_068_781
    assert Day13.find_sequenced_departures_2([17, -1, 13, 19]) == 3417
    assert Day13.find_sequenced_departures_2([67, 7, 59, 61]) == 754_018
    assert Day13.find_sequenced_departures_2([67, -1, 7, 59, 61]) == 779_210
    assert Day13.find_sequenced_departures_2([67, 7, -1, 59, 61]) == 1_261_476
    assert Day13.find_sequenced_departures_2([1789, 37, 47, 1889]) == 1_202_161_486

    assert Day13.find_sequenced_departures_2([17, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 37]) ==
             544

    assert Day13.find_sequenced_departures_2([
             17,
             -1,
             -1,
             -1,
             -1,
             -1,
             -1,
             -1,
             -1,
             -1,
             -1,
             37,
             -1,
             -1,
             -1,
             -1,
             -1,
             439
           ]) == 171_632

    #   assert rem(171_632 - 544, 17 * 37) == 0

    #   assert Day13.find_sequenced_departures_2([
    #            17,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            37,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            439,
    #            -1,
    #            29
    #          ]) == 171_632

    #   assert Day13.find_sequenced_departures_2([
    #            17,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            37,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            439,
    #            -1,
    #            29,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            -1,
    #            13
    #          ]) == 48_218_426
  end
end
