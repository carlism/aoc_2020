defmodule Day2 do
  @moduledoc """
  Documentation for Day2.
  """

  def part1 do
    "input.txt"
    |> stream_input()
    |> Stream.filter(&is_valid/1)
    |> Enum.count()
    |> IO.puts()
  end

  def part2 do
    "input.txt"
    |> stream_input()
    |> Stream.filter(&is_valid2/1)
    |> Enum.count()
    |> IO.puts()
  end

  def stream_input(filename) do
    regex = ~r/(?<lb>\d+)-(?<ub>\d+)\s+(?<char>\w):\s+(?<password>.*)/

    File.stream!(filename)
    |> Stream.map(fn line ->
      Regex.named_captures(regex, line)
    end)
  end

  def is_valid(%{"lb" => lb, "ub" => ub, "char" => char, "password" => password}) do
    {upper, _} = Integer.parse(ub)
    {lower, _} = Integer.parse(lb)
    occurances = password |> String.graphemes() |> Enum.count(&(&1 == char))
    occurances >= lower && occurances <= upper
  end

  def is_valid2(%{"lb" => lb, "ub" => ub, "char" => char, "password" => password}) do
    {pos1, _} = Integer.parse(ub)
    {pos2, _} = Integer.parse(lb)
    letters = password |> String.graphemes()

    occurances =
      [Enum.at(letters, pos1 - 1), Enum.at(letters, pos2 - 1)] |> Enum.count(&(&1 == char))

    occurances == 1
  end
end
