defmodule Day17 do
  @moduledoc """
  Documentation for Day17.
  """

  @dimensions 4

  def part1 do
    active_set = load_initial("input.txt")

    step6 = 0..5 |> Enum.reduce(active_set, fn _iter, current_set -> step(current_set) end)

    IO.puts(Enum.count(step6))
  end

  def load_initial(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.graphemes/1)
    |> Stream.with_index()
    |> Enum.reduce(MapSet.new(), fn {row, y}, set ->
      row
      |> Enum.with_index()
      |> Enum.reduce(set, fn
        {"#", x}, set ->
          MapSet.put(
            set,
            Tuple.duplicate(0, @dimensions - 2) |> Tuple.insert_at(0, x) |> Tuple.insert_at(1, y)
          )

        {_, _}, set ->
          set
      end)
    end)
  end

  def universe_ranges(set) do
    0..(@dimensions - 1)
    |> Enum.map(fn dimension ->
      slice = set |> Enum.map(fn ranges -> elem(ranges, dimension) end)
      (Enum.min(slice) - 1)..(Enum.max(slice) + 1)
    end)
    |> List.to_tuple()
  end

  def world_ranges(set) do
    0..(@dimensions - 1)
    |> Enum.map(fn dimension ->
      slice = set |> Enum.map(fn ranges -> elem(ranges, dimension) end)
      Enum.min(slice)..Enum.max(slice)
    end)
    |> List.to_tuple()
  end

  def universe_list(ranges) do
    case tuple_size(ranges) do
      1 ->
        elem(ranges, 0) |> Enum.to_list()

      _ ->
        for current <- universe_list({elem(ranges, 0)}),
            rest <- universe_list(Tuple.delete_at(ranges, 0)) do
          [current, rest] |> List.flatten()
        end
    end
  end

  def universe(set) do
    universe_list(universe_ranges(set))
    |> Enum.map(&List.to_tuple/1)
    |> MapSet.new()
  end

  def neighborhood_list(loc) do
    case tuple_size(loc) do
      1 ->
        [elem(loc, 0) - 1, elem(loc, 0), elem(loc, 0) + 1]

      _ ->
        for current <- neighborhood_list({elem(loc, 0)}),
            rest <- neighborhood_list(Tuple.delete_at(loc, 0)) do
          [current, rest] |> List.flatten()
        end
    end
  end

  def neighborhood(loc) do
    neighborhood_list(loc)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.reject(fn neighbor -> neighbor == loc end)
    |> MapSet.new()
  end

  def neighbors(set, loc) do
    neighborhood(loc)
    |> Enum.map(fn point -> MapSet.member?(set, point) end)
    |> Enum.filter(& &1)
    |> Enum.count()
  end

  def step(set) do
    set
    |> universe()
    |> Enum.filter(fn loc ->
      case {MapSet.member?(set, loc), neighbors(set, loc)} do
        {true, 2} -> true
        {true, 3} -> true
        {true, _} -> false
        {false, 3} -> true
        _ -> false
      end
    end)
    |> MapSet.new()
  end

  def print(set) do
    ranges = world_ranges(set)

    for z <- elem(ranges, 2) do
      IO.puts("z = #{z}")

      for y <- elem(ranges, 1) do
        for x <- elem(ranges, 0) do
          if MapSet.member?(set, {x, y, z}) do
            IO.write("#")
          else
            IO.write(".")
          end
        end

        IO.puts("")
      end
    end
  end
end
