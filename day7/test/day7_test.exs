defmodule Day7Test do
  use ExUnit.Case
  doctest Day7

  test "parses the input" do
    parsed =
      File.stream!("test/test_input.txt")
      |> Day7.parse_input()

    assert Enum.count(parsed) == 9
    assert parsed |> Map.get("dark orange") |> Enum.count() == 2
  end

  test "inverted map" do
    invert =
      File.stream!("test/test_input.txt")
      |> Day7.parse_input()
      |> Day7.invert_map()

    assert invert |> Map.get("shiny gold") |> Enum.count() == 2
  end

  test "walk inverted map" do
    walked =
      File.stream!("test/test_input.txt")
      |> Day7.parse_input()
      |> Day7.invert_map()
      |> Day7.walk_map("shiny gold")

    assert walked |> Enum.count() == 4
  end

  test "walk parsed map" do
    count =
      File.stream!("test/test_input.txt")
      |> Day7.parse_input()
      |> Day7.count_walk_map("shiny gold")

    assert count == 32
  end

  test "walk parsed map (alternate)" do
    count =
      File.stream!("test/alternate_input.txt")
      |> Day7.parse_input()
      |> Day7.count_walk_map("shiny gold")

    assert count == 126
  end
end
