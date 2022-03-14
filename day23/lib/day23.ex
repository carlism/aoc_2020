defmodule Day23 do
  @moduledoc """
  Documentation for Day23.
  """

  def part1 do
    cups = cups("792845136")
    hun_moves = 1..100 |> Enum.reduce(cups, fn _i, cups -> move(cups) end)
    hun_moves |> collect() |> IO.puts()
  end

  def part2 do
    cups = Day23.cups("792845136")
    cups = Day23.millionize(cups)

    all_moves =
      1..10_000_000
      |> Enum.reduce(cups, fn _i, cups ->
        Day23.move(cups)
      end)

    {_start, map} = all_moves

    star1 = Map.get(map, 1)
    star2 = Map.get(map, star1)
    IO.puts("#{star1} * #{star2} == #{star1 * star2}")
  end

  def millionize({curr, map}) do
    {last, ^curr} = Enum.find(map, fn {_key, val} -> val == curr end)

    {curr,
     10..999_999
     |> Enum.map(fn x -> {x, x + 1} end)
     |> Map.new()
     |> Map.merge(map |> Map.put(last, 10))
     |> Map.put(1_000_000, curr)}
  end

  def cups(str) do
    list = str |> String.graphemes() |> Enum.map(&String.to_integer/1)

    list
    |> List.foldr({List.first(list), %{}}, fn x, {next, map} -> {x, Map.put(map, x, next)} end)
  end

  def cups_to_string({current, map}) do
    Stream.resource(
      fn -> current end,
      fn curr ->
        if curr do
          next = Map.get(map, curr)

          if next != current do
            {[curr], next}
          else
            {[curr], nil}
          end
        else
          {:halt, nil}
        end
      end,
      fn curr -> curr end
    )
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join()
  end

  def collect_list({curr, map}) do
    Stream.resource(
      fn -> Map.get(map, curr) end,
      fn next -> if next == 1, do: {:halt, next}, else: {[next], Map.get(map, next)} end,
      fn next -> next end
    )
  end

  def collect({_start, map}) do
    collect_list({1, map}) |> Enum.map(&Integer.to_string/1) |> Enum.join()
  end

  def move({current, map}) do
    next1 = Map.get(map, current)
    next2 = Map.get(map, next1)
    next3 = Map.get(map, next2)
    next4 = Map.get(map, next3)

    map = Map.put(map, current, next4)

    insert_at =
      if current > 1 do
        (current - 1)..1 |> Enum.find(fn x -> x != next1 && x != next2 && x != next3 end) ||
          Enum.count(map)..current
          |> Enum.find(fn x -> x != next1 && x != next2 && x != next3 end)
      else
        Enum.count(map)..current |> Enum.find(fn x -> x != next1 && x != next2 && x != next3 end)
      end

    insert_before = Map.get(map, insert_at)
    map = Map.put(map, next3, insert_before)
    map = Map.put(map, insert_at, next1)
    {next4, map}
  end
end
