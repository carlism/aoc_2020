defmodule Day6Test do
  use ExUnit.Case
  doctest Day6

  test "counts answers" do
    assert Day6.count_groups_any(File.stream!("test/test_input.txt")) == [3, 3, 3, 1, 1]
    assert Day6.count_groups_any(File.stream!("test/test_input.txt")) |> Enum.sum() == 11
  end

  test "count alls" do
    assert Day6.count_groups_all(File.stream!("test/test_input.txt")) == [3, 0, 1, 1, 1]
    assert Day6.count_groups_all(File.stream!("test/test_input.txt")) |> Enum.sum() == 6
  end
end
