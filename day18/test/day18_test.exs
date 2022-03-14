defmodule Day18Test do
  use ExUnit.Case
  doctest Day18

  @tag :skip
  test "initial evaluation" do
    assert Day18.eval("1 + 2 * 3 + 4 * 5 + 6") == "71"
  end

  test "initial evaluation v2" do
    assert Day18.eval("1 + 2 * 3 + 4 * 5 + 6") == "231"
  end

  @tag :skip
  test "paren processing" do
    assert Day18.eval("1 + (2 * 3) + (4 * (5 + 6))") == "51"
    assert Day18.eval("2 * 3 + (4 * 5)") == "26"
  end

  test "paren processing v2" do
    assert Day18.eval("1 + (2 * 3) + (4 * (5 + 6))") == "51"
    assert Day18.eval("2 * 3 + (4 * 5)") == "46"
  end

  @tag :skip
  test "other expressions" do
    assert Day18.eval("5 + (8 * 3 + 9 + 3 * 4 * 3)") == "437"
    assert Day18.eval("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == "12240"
    assert Day18.eval("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == "13632"
  end

  test "other expressions v2" do
    assert Day18.eval("5 + (8 * 3 + 9 + 3 * 4 * 3)") == "1445"
    assert Day18.eval("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == "669060"
    assert Day18.eval("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == "23340"
  end
end
