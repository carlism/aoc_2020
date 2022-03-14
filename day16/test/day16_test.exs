defmodule Day16Test do
  use ExUnit.Case
  doctest Day16

  test "reads the data" do
    assert Day16.read_data("test/input.txt")
           |> Enum.count() == 3
  end

  test "parses the rules" do
    [rules, _ticket, _others] =
      Day16.read_data("test/input.txt")
      |> Enum.to_list()

    assert Day16.parse_rules(rules) == %{
             "class" => [{1, 3}, {5, 7}],
             "row" => [{6, 11}, {33, 44}],
             "seat" => [{13, 40}, {45, 50}]
           }
  end

  test "validates against rule" do
    assert Day16.is_valid(3, [{1, 3}, {5, 7}])
    refute Day16.is_valid(4, [{1, 3}, {5, 7}])
    refute Day16.is_valid(0, [{1, 3}, {5, 7}])
    refute Day16.is_valid(8, [{1, 3}, {5, 7}])
    assert Day16.is_valid(6, [{1, 3}, {5, 7}])
  end

  test "validates against rules" do
    [rules, _ticket, _others] =
      Day16.read_data("test/input.txt")
      |> Enum.to_list()

    rules = Day16.parse_rules(rules)
    assert Day16.matches_rules(3, rules)
    refute Day16.matches_rules(4, rules)
    refute Day16.matches_rules(0, rules)
    refute Day16.matches_rules(12, rules)
    assert Day16.matches_rules(50, rules)
  end

  test "expose invalid values" do
    [rules, _ticket, others] =
      Day16.read_data("test/input.txt")
      |> Enum.to_list()

    others = others |> Day16.parse_tickets()

    rules = Day16.parse_rules(rules)
    assert Day16.extract_invalid_values(others, rules) |> Enum.sum() == 71
  end

  test "get column" do
    [_rules, _ticket, others] =
      Day16.read_data("test/input.txt")
      |> Enum.to_list()

    others = others |> Day16.parse_tickets()

    assert Day16.get_column(others, 0) == [7, 40, 55, 38]
    assert Day16.get_column(others, 2) == [47, 50, 20, 12]
  end

  test "filter tickets" do
    [rules, _ticket, others] =
      Day16.read_data("test/input.txt")
      |> Enum.to_list()

    others = others |> Day16.parse_tickets()
    rules = Day16.parse_rules(rules)

    assert Day16.filter_invalid_tickets(others, rules) == [[7, 3, 47]]
  end

  test "match column to rules" do
    [rules, _ticket, others] =
      Day16.read_data("test/input.txt")
      |> Enum.to_list()

    rules = Day16.parse_rules(rules)

    others =
      others
      |> Day16.parse_tickets()
      |> Day16.filter_invalid_tickets(rules)

    assert 0..(length(others |> List.first()) - 1)
           |> Enum.map(fn column ->
             Day16.get_column(others, column) |> Day16.find_matching_rule(rules)
           end) == [["class", "row"], ["class"], ["seat"]]
  end

  test "build column mapping" do
    [rules, _ticket, others] =
      Day16.read_data("test/input.txt")
      |> Enum.to_list()

    rules = Day16.parse_rules(rules)

    others =
      others
      |> Day16.parse_tickets()
      |> Day16.filter_invalid_tickets(rules)

    assert 0..(length(others |> List.first()) - 1)
           |> Enum.map(fn column ->
             Day16.get_column(others, column) |> Day16.find_matching_rule(rules)
           end)
           |> Day16.build_column_map() == %{"row" => 0, "class" => 1, "seat" => 2}
  end

  test "get answer" do
    [rules, ticket, others] =
      Day16.read_data("test/input.txt")
      |> Enum.to_list()

    rules = Day16.parse_rules(rules)

    others =
      others
      |> Day16.parse_tickets()
      |> Day16.filter_invalid_tickets(rules)

    ticket = ticket |> Day16.parse_tickets() |> List.first()

    assert ticket == [7, 1, 14]

    0..(length(others |> List.first()) - 1)
    |> Enum.map(fn column ->
      Day16.get_column(others, column) |> Day16.find_matching_rule(rules)
    end)
    |> Day16.build_column_map()
    |> Enum.filter(fn {key, _v} -> String.starts_with?(key, "sea") end)
    |> Enum.map(fn {field, column} -> {field, Enum.at(ticket, column)} end)
    |> Map.new() ==
      %{"seat" => 14}
  end
end
