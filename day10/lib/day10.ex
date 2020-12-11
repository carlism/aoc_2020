defmodule Day10 do
  @moduledoc """
  Documentation for Day10.
  """

  def part1 do
    dist =
      read_input("input.txt")
      |> difference_distribution()

    (Enum.at(dist, 1) * (Enum.at(dist, 3) + 1)) |> IO.puts()
  end

  def part2 do
    read_input("input.txt")
    |> differences()
    |> IO.inspect()
    |> group_ones()
    |> IO.inspect()
    |> convert_to_variations()
    |> IO.inspect()
    |> combine_variations()
    |> IO.inspect()
  end

  def read_input(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
  end

  def difference_distribution(values) do
    values
    |> differences()
    |> IO.inspect()
    |> Enum.reduce(
      [0, 0, 0, 0],
      fn diff, list ->
        List.replace_at(list, diff, Enum.at(list, diff) + 1)
      end
    )
  end

  def differences(values) do
    values
    |> Enum.sort()
    |> Enum.reduce(
      {0, []},
      fn jolts, {last_j, diffs} ->
        {jolts, [jolts - last_j | diffs]}
      end
    )
    |> elem(1)
    |> Enum.reverse()
  end

  def group_ones(differences) do
    differences
    |> Enum.chunk_by(fn x -> x == 1 end)
    |> Enum.filter(fn [head | _rest] -> head == 1 end)
  end

  def convert_to_variations(spans) do
    spans
    |> Enum.map(&Enum.count/1)
    |> Enum.map(fn count ->
      # turns out this is 1+(n*(n-1)/2) up to 4 which is all that's needed, but I counted them manually
      case count do
        1 ->
          1

        2 ->
          2

        3 ->
          4

        4 ->
          7

        5 ->
          13

        6 ->
          24

        _ ->
          0
      end

      1 + count * (count - 1) / 2
    end)
  end

  def combine_variations(list) do
    list |> Enum.reduce(&*/2)
  end
end
