defmodule Day1 do
  @moduledoc """
  Day1 fix my expense reports.
  """

  def part1 do
    {x, y} =
      Day1.read_numbers("input.txt")
      |> Day1.all_pairs()
      |> Day1.find_sum(2020)

    IO.puts(x)
    IO.puts(y)
    IO.puts(x * y)
  end

  def part2 do
    {x, y, z} =
      Day1.read_numbers("input.txt")
      |> Day1.all_trios()
      |> Day1.find_sum(2020)

    IO.puts(x)
    IO.puts(y)
    IO.puts(z)
    IO.puts(x * y * z)
  end

  def read_lines(file_name) do
    File.stream!(file_name)
    |> Enum.map(&String.trim/1)
  end

  def read_numbers(file_name) do
    read_lines(file_name)
    |> Enum.map(fn str ->
      {int, _err} = Integer.parse(str)
      int
    end)
  end

  def all_pairs(list) do
    for x <- list, y <- list do
      {x, y}
    end
  end

  def all_trios(list) do
    for x <- list, y <- list, z <- list do
      {x, y, z}
    end
  end

  def find_sum(list, target) do
    Enum.find(list, fn group -> Enum.sum(Tuple.to_list(group)) == target end)
  end
end
