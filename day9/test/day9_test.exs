defmodule Day9Test do
  use ExUnit.Case
  doctest Day9

  test "pairs" do
    assert Day9.pairs([1, 2, 3]) == [{1, 2}, {1, 3}, {2, 3}]
  end

  test "check preamble" do
    preamble = :queue.from_list([1, 2, 3])
    assert Day9.check_preamble(preamble, 1) == [1]
    assert Day9.check_preamble(preamble, 2) == [2]
    assert Day9.check_preamble(preamble, 3) == []
    assert Day9.check_preamble(preamble, 4) == []
    assert Day9.check_preamble(preamble, 5) == []
    assert Day9.check_preamble(preamble, 6) == [6]
    assert Day9.check_preamble(preamble, 346) == [346]
  end

  test "solution" do
    assert Day9.find_invalid(Day9.getXmas("test/input.txt"), 5) == [127]
  end

  test "idea" do
    str = Stream.iterate(1, fn e -> e + 1 end)
    assert str |> Stream.take(3) |> Enum.to_list() == [1, 2, 3]
    assert str |> Stream.take(3) |> Enum.to_list() == [1, 2, 3]
    assert str |> Stream.drop(3) |> Stream.take(3) |> Enum.to_list() == [4, 5, 6]
    str = Day9.getXmas("test/input.txt")
    assert str |> Stream.take(3) |> Enum.to_list() == [35, 20, 15]
    assert str |> Stream.drop(3) |> Stream.take(3) |> Enum.to_list() == [25, 47, 40]
  end

  test "find 127" do
    str = Day9.getXmas("test/input.txt")
    assert Day9.find_contiguous_sum(str, 127) == [15, 25, 47, 40]
    assert Day9.add_smallest_to_largest([15, 25, 47, 40]) == 62
  end
end
