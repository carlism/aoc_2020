defmodule Day25Test do
  use ExUnit.Case
  doctest Day25

  test "determine loops" do
    assert Day25.loops(5_764_801) == 8
    assert Day25.loops(17_807_724) == 11
    assert Day25.loops(14_897_079) == 88
    assert Day25.loop(5_764_801, 11) == 14_897_079
    assert Day25.loop(17_807_724, 8) == 14_897_079
  end

  test "part1" do
    assert Day25.loops(11_349_501) == 1_583_436
    assert Day25.loops(5_107_328) == 5_920_134
    assert Day25.loop(11_349_501, 5_920_134) == 7_936_032
  end
end
