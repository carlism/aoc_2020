defmodule Day11 do
  @moduledoc """
  Documentation for Day11.
  """

  def part1 do
    Day11.read_seats("input.txt") |> Day11.stabilize() |> Day11.occupied_seats() |> IO.puts()
  end

  def part2 do
    Day11.read_seats("input.txt")
    |> Day11.stabilize(&Day11.step2/1)
    |> Day11.occupied_seats()
    |> IO.puts()
  end

  def read_seats(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.graphemes/1)
    |> Stream.with_index()
    |> Stream.map(fn {seats, row} ->
      seats
      |> Enum.with_index()
      |> Enum.map(fn {seat, col} -> {{row, col}, seat} end)
    end)
    |> Stream.flat_map(fn row -> row end)
    |> Map.new()
  end

  def neighborhood({row, col} = loc) do
    for r <- [row - 1, row, row + 1], c <- [col - 1, col, col + 1] do
      {r, c}
    end
    |> Enum.filter(fn x -> x != loc end)
  end

  def debug(seats, size \\ 10) do
    for row <- 0..(size - 1), col <- 0..(size - 1) do
      IO.write(seats[{row, col}])
      if col == 9, do: IO.puts("")
    end

    seats
  end

  def directions do
    for x <- -1..1, y <- -1..1 do
      {x, y}
    end
    |> Enum.filter(fn
      {0, 0} -> false
      _ -> true
    end)
  end

  def look(seats, {lx, ly}, {dx, dy} = dir) do
    next_loc = {lx + dx, ly + dy}

    case seats[next_loc] do
      "." ->
        look(seats, next_loc, dir)

      seat ->
        seat
    end
  end

  def neighborhood2(seats, loc) do
    directions() |> Enum.map(fn dir -> look(seats, loc, dir) end)
  end

  def step2(seats) do
    seats
    |> Enum.map(fn {loc, seat} ->
      case {seat,
            neighborhood2(seats, loc)
            |> Enum.filter(fn s -> s == "#" end)
            |> Enum.count()} do
        {".", _} ->
          {loc, "."}

        {"L", 0} ->
          {loc, "#"}

        {"#", adjacents} when adjacents >= 5 ->
          {loc, "L"}

        _ ->
          {loc, seat}
      end
    end)
    |> Map.new()
  end

  def step(seats) do
    seats
    |> Enum.map(fn {loc, seat} ->
      case {seat,
            neighborhood(loc)
            |> Enum.map(fn n_loc -> Map.get(seats, n_loc) end)
            |> Enum.filter(fn s -> s == "#" end)
            |> Enum.count()} do
        {".", _} ->
          {loc, "."}

        {"L", 0} ->
          {loc, "#"}

        {"#", adjacents} when adjacents >= 4 ->
          {loc, "L"}

        _ ->
          {loc, seat}
      end
    end)
    |> Map.new()
  end

  def occupied_seats(seats) do
    seats |> Map.values() |> Enum.count(fn s -> s == "#" end)
  end

  def stabilize(seats, step_fn \\ &Day11.step/1) do
    Stream.resource(
      fn -> seats end,
      fn last_seats ->
        next_seats = last_seats |> step_fn.()

        if next_seats == last_seats do
          {:halt, next_seats}
        else
          {[next_seats], next_seats}
        end
      end,
      fn final_seats -> final_seats end
    )
    |> Enum.to_list()
    # |> Enum.map(fn seats ->
    #   IO.puts("----------")
    #   seats |> debug()
    # end)
    |> List.last()
  end
end
