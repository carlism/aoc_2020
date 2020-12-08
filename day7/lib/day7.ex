defmodule Day7 do
  @moduledoc """
  Documentation for Day7.
  """

  def part1 do
    File.stream!("input.txt")
    |> Day7.parse_input()
    |> Day7.invert_map()
    |> Day7.walk_map("shiny gold")
    |> Enum.count()
    |> IO.puts()
  end

  def part2 do
    File.stream!("input.txt")
    |> Day7.parse_input()
    |> Day7.count_walk_map("shiny gold")
    |> IO.puts()
  end

  def parse_count(%{"count" => "no"} = spec) do
    spec |> Map.put("count", 0)
  end

  def parse_count(%{"count" => count} = spec) do
    spec |> Map.put("count", String.to_integer(count))
  end

  def parse_item(item) do
    ~r/(?<count>[0-9no]+)\s(?<type>[\w\s]+)\sbags?.?\s*/
    |> Regex.named_captures(item)
    |> parse_count()
  end

  def parse_input(stream) do
    stream
    |> Stream.map(fn line ->
      [bag, contents] = line |> String.split(~r/\sbags?\scontain\s/)

      {
        bag,
        contents
        |> String.split(", ")
        |> Enum.map(fn item ->
          parse_item(item)
        end)
      }
    end)
    |> Map.new()
  end

  def invert_map(data) do
    data
    |> Enum.reduce(%{}, fn {bag, contents}, map ->
      Map.merge(
        map,
        contents
        |> Enum.reduce(%{}, fn %{"type" => item}, new_map ->
          new_map |> Map.put(item, MapSet.new([bag]))
        end),
        fn _key, val1, val2 ->
          MapSet.union(val1, val2)
        end
      )
    end)
  end

  def walk_map(map, key) do
    container_set = Map.get(map, key, MapSet.new())

    container_set
    |> Enum.reduce(MapSet.new(), fn container, map_set ->
      walk_map(map, container) |> MapSet.union(map_set)
    end)
    |> MapSet.union(container_set)
  end

  def count_walk_map(map, key) do
    map
    |> Map.get(key, [])
    |> Enum.reduce(0, fn %{"type" => type, "count" => count}, counter ->
      counter + count * count_walk_map(map, type) + count
    end)
  end
end
