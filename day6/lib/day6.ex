defmodule Day6 do
  @moduledoc """
  Documentation for Day6.
  """

  def part1 do
    "input.txt"
    |> File.stream!()
    |> Day6.count_groups_any()
    |> Enum.sum()
    |> IO.puts()
  end

  def part2 do
    "input.txt"
    |> File.stream!()
    |> Day6.count_groups_all()
    |> Enum.sum()
    |> IO.puts()
  end

  def intersect_line("\n", acc) do
    acc
  end

  def intersect_line(line, nil) do
    line |> String.trim() |> String.graphemes() |> MapSet.new()
  end

  def intersect_line(line, acc) do
    line |> String.trim() |> String.graphemes() |> MapSet.new() |> MapSet.intersection(acc)
  end

  def add_line(line, acc) do
    line |> String.trim() |> String.graphemes() |> MapSet.new() |> MapSet.union(acc)
  end

  def chunk_stream(source, init_fn, eval_fn, acc_fn, chunk_fn) do
    source
    |> Stream.chunk_while(
      init_fn.(),
      fn element, acc ->
        if eval_fn.(element) do
          {:cont, chunk_fn.(acc_fn.(element, acc)), init_fn.()}
        else
          {:cont, acc_fn.(element, acc)}
        end
      end,
      fn acc ->
        {:cont, chunk_fn.(acc), init_fn.()}
      end
    )
  end

  def count_groups_any(stream) do
    stream
    |> chunk_stream(
      &MapSet.new/0,
      fn line -> String.trim(line) == "" end,
      &add_line/2,
      &MapSet.size/1
    )
    |> Enum.to_list()
  end

  def count_groups_all(stream) do
    stream
    |> chunk_stream(
      fn -> nil end,
      fn line -> String.trim(line) == "" end,
      &intersect_line/2,
      &MapSet.size/1
    )
    |> Enum.to_list()
  end
end
