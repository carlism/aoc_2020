defmodule Day5 do
  @moduledoc """
  Documentation for Day5.
  """

  def part1 do
    File.stream!("input.txt")
    |> Stream.map(&convert/1)
    |> Enum.max()
    |> IO.puts()
  end

  def part2 do
    File.stream!("input.txt")
    |> Stream.map(&convert/1)
    |> Enum.sort()
    |> Enum.reduce(0, fn i, acc ->
      if i != acc + 1 do
        IO.puts("#{acc}, #{i}")
      end

      i
    end)
  end

  def convert(seat) do
    seat
    |> String.replace(["F", "B", "R", "L"], fn
      "F" -> "0"
      "L" -> "0"
      "B" -> "1"
      "R" -> "1"
    end)
    |> Integer.parse(2)
    |> elem(0)
  end
end
