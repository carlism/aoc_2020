defmodule Day5Test do
  use ExUnit.Case
  doctest Day5

  test "converts to seat-id" do
    assert Day5.convert("FBFBBFFRLR") == 357
    assert Day5.convert("BFFFBBFRRR") == 567
    assert Day5.convert("FFFBBBFRRR") == 119
    assert Day5.convert("BBFFBBFRLL") == 820
  end
end
