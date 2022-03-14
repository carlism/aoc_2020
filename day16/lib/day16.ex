defmodule Day16 do
  @moduledoc """
  Documentation for Day16.
  """

  def part1 do
    [rules, _ticket, others] =
      read_data("input.txt")
      |> Enum.to_list()

    rules = parse_rules(rules)
    extract_invalid_values(others |> Enum.slice(1..-1), rules) |> Enum.sum() |> IO.puts()
  end

  def part2 do
    [rules, ticket, others] =
      read_data("input.txt")
      |> Enum.to_list()

    rules = parse_rules(rules)

    others =
      others
      |> parse_tickets()
      |> filter_invalid_tickets(rules)

    ticket = ticket |> parse_tickets() |> List.first()

    0..(length(others |> List.first()) - 1)
    |> Enum.map(fn column ->
      get_column(others, column) |> find_matching_rule(rules)
    end)
    |> build_column_map()
    |> Enum.filter(fn {key, _v} -> String.starts_with?(key, "departure") end)
    |> Enum.map(fn {field, column} -> {field, Enum.at(ticket, column)} end)
    |> Map.new()
    |> Map.values()
    |> Enum.reduce(fn x, acc -> x * acc end)
    |> IO.inspect()
  end

  def read_data(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.chunk_by(fn line -> line == "" end)
    |> Stream.reject(fn chunk -> chunk == [""] end)
  end

  def parse_rules(rules) do
    rules
    |> Enum.map(fn rule ->
      [name, range_data] = String.split(rule, ~r/:\s*/)

      ranges =
        range_data
        |> String.split(~r/\s*or\s*/i)
        |> Enum.map(fn range_string ->
          String.split(range_string, "-") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
        end)

      {name, ranges}
    end)
    |> Map.new()
  end

  def is_valid(num, rule) do
    rule |> Enum.map(fn {lb, ub} -> Enum.member?(lb..ub, num) end) |> Enum.any?()
  end

  def matches_rules(num, rules) do
    rules |> Map.values() |> Enum.map(fn rule -> is_valid(num, rule) end) |> Enum.any?()
  end

  def extract_invalid_values(tickets, rules) do
    tickets
    |> Enum.map(fn values -> Enum.reject(values, fn value -> matches_rules(value, rules) end) end)
    |> List.flatten()
  end

  def filter_invalid_tickets(tickets, rules) do
    tickets
    |> Enum.filter(fn values -> Enum.all?(values, fn x -> matches_rules(x, rules) end) end)
  end

  def parse_tickets(ticket_lines) do
    ticket_lines
    |> Enum.slice(1..-1)
    |> Enum.map(fn ticket_line ->
      String.split(ticket_line, ",") |> Enum.map(&String.to_integer/1)
    end)
  end

  def get_column(tickets, column) do
    tickets
    |> Enum.map(fn values -> Enum.at(values, column) end)
  end

  def find_matching_rule(col_vals, rules) do
    rules
    |> Enum.filter(fn {_key, rule} ->
      col_vals |> Enum.map(fn num -> is_valid(num, rule) end) |> Enum.all?()
    end)
    |> Enum.map(fn match -> elem(match, 0) end)
  end

  def reduce_col_counts({1, col_map}, result_map) do
    col_map
    |> Enum.reduce(result_map, fn {rule_list, col}, map ->
      Map.put(map, rule_list |> List.first(), col)
    end)
  end

  def reduce_col_counts({_count, col_map}, result_map) do
    col_map
    |> Enum.map(fn {rule_list, column} ->
      {rule_list |> Enum.reject(fn rule -> Map.has_key?(result_map, rule) end), column}
    end)
    |> Enum.group_by(fn {matches, _column} -> Enum.count(matches) end)
    |> Enum.reduce(result_map, &reduce_col_counts/2)
  end

  def build_column_map(matches) do
    matches
    |> Enum.with_index()
    |> Enum.group_by(fn {matches, _column} -> Enum.count(matches) end)
    |> Enum.reduce(%{}, &reduce_col_counts/2)
  end
end
