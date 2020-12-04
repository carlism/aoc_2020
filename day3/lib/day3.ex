defmodule Day3 do
  @moduledoc """
  Documentation for Day3.
  """
  def part1 do
    Day3.read_data("input.txt")
    |> Day3.make_path(3)
    |> Enum.count(fn x -> x == "#" end)
    |> IO.puts()
  end

  def part2 do
    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(fn {right, down} ->
      Day3.read_data("input.txt")
      |> Day3.make_path(right, down)
      |> Enum.count(fn x -> x == "#" end)
    end)
    |> Enum.reduce(&(&1 * &2))
    |> IO.puts()
  end

  def read_data(filename) do
    File.stream!(filename)
    |> Stream.map(fn line -> line |> String.trim() |> String.graphemes() end)
  end

  def make_path(data, step, skip \\ 1) do
    data
    |> Stream.take_every(skip)
    |> Stream.with_index()
    |> Stream.map(fn {row, index} ->
      Enum.at(row, rem(index * step, Enum.count(row)))
    end)
  end
end
