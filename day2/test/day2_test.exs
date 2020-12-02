defmodule Day2Test do
  use ExUnit.Case
  doctest Day2

  test "reads and parses file" do
    assert Enum.count(Day2.stream_input("test/data/test_input.txt")) == 3
  end

  test "parsed data correctly" do
    line3 =
      Day2.stream_input("test/data/test_input.txt")
      |> Stream.drop(2)
      |> Stream.take(1)
      |> Enum.at(0)

    assert valid_last_line(line3)
  end

  test "validate items" do
    assert Day2.is_valid(%{"lb" => "1", "ub" => "3", "char" => "a", "password" => "abcde"})
    refute Day2.is_valid(%{"lb" => "1", "ub" => "3", "char" => "b", "password" => "cdefg"})
    assert Day2.is_valid(%{"lb" => "2", "ub" => "9", "char" => "c", "password" => "ccccccccc"})
  end

  test "validate items part 2" do
    assert Day2.is_valid2(%{"lb" => "1", "ub" => "3", "char" => "a", "password" => "abcde"})
    refute Day2.is_valid2(%{"lb" => "1", "ub" => "3", "char" => "b", "password" => "cdefg"})
    refute Day2.is_valid2(%{"lb" => "2", "ub" => "9", "char" => "c", "password" => "ccccccccc"})
  end

  def valid_last_line(%{"lb" => "2", "ub" => "9", "char" => "c", "password" => "ccccccccc"}) do
    true
  end

  def valid_last_line(_bad_line) do
    false
  end
end
