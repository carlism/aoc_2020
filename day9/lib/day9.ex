defmodule Day9 do
  @moduledoc """
  Documentation for Day9.
  """

  def part1 do
    find_invalid(getXmas("input.txt"), 25) |> Enum.each(&IO.puts/1)
  end

  def part2 do
    stream = getXmas("input.txt")
    target = find_invalid(stream, 25) |> List.first()
    find_contiguous_sum(stream, target) |> add_smallest_to_largest() |> IO.puts()
  end

  def getXmas(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
  end

  def add_smallest_to_largest(list) do
    Enum.max(list) + Enum.min(list)
  end

  def find_contiguous_sum(stream, target, window_start \\ 0, window_length \\ 1) do
    window = stream |> Stream.drop(window_start) |> Stream.take(window_length)
    sum = window |> Enum.sum()

    cond do
      sum == target ->
        window |> Enum.to_list()

      sum > target ->
        find_contiguous_sum(stream, target, window_start + 1, window_length - 1)

      sum < target ->
        find_contiguous_sum(stream, target, window_start, window_length + 1)

      true ->
        {:error}
    end
  end

  def pairs(list) when length(list) < 2 do
    []
  end

  def pairs([head | tail]) do
    tail |> Enum.map(fn element -> {head, element} end) |> Enum.concat(pairs(tail))
  end

  def check_preamble(queue, value) do
    if :queue.to_list(queue)
       |> pairs()
       |> Enum.map(fn {x, y} -> x + y end)
       |> Enum.member?(value) do
      []
    else
      [value]
    end
  end

  def find_invalid(stream, preamble) do
    stream
    |> Stream.with_index()
    |> Stream.transform(:queue.new(), fn {value, index}, queue ->
      invalid_values =
        if index + 1 > preamble do
          check_preamble(queue, value)
        else
          []
        end

      queue = :queue.in(value, queue)

      queue =
        if index + 1 > preamble do
          :queue.out(queue) |> elem(1)
        else
          queue
        end

      {invalid_values, queue}
    end)
    |> Enum.to_list()
  end
end
