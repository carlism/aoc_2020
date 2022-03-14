defmodule Day24 do
  @moduledoc """
  Documentation for Day24.
  """

  def part1 do
    initial_black_tiles("input.txt")
    |> Enum.to_list()
    |> Enum.count()
    |> IO.puts()
  end

  def part2 do
    "input.txt" |> initial_black_tiles() |> days(100) |> Enum.count() |> IO.puts()
  end

  def read_input(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn line ->
      Regex.scan(~r/e|se|sw|w|nw|ne/, line)
      |> Enum.map(&List.first/1)
      |> Enum.map(&String.to_existing_atom/1)
    end)
  end

  def initial_black_tiles(filename) do
    read_input(filename)
    |> Stream.map(&walk/1)
    |> Stream.map(&to_2d/1)
    |> Enum.sort()
    |> Stream.chunk_by(& &1)
    |> Stream.filter(fn visits -> is_odd(Enum.count(visits)) end)
    |> Stream.map(&List.first/1)
  end

  def is_odd(num) do
    rem(num, 2) != 0
  end

  def walk(directions) do
    directions
    |> Enum.reduce({0, 0, 0}, fn move, {e_w, ne_sw, nw_se} ->
      case move do
        :e -> {e_w + 1, ne_sw, nw_se}
        :w -> {e_w - 1, ne_sw, nw_se}
        :se -> {e_w, ne_sw, nw_se - 1}
        :nw -> {e_w, ne_sw, nw_se + 1}
        :sw -> {e_w, ne_sw - 1, nw_se}
        :ne -> {e_w, ne_sw + 1, nw_se}
      end
    end)
  end

  def to_2d({e_w, ne_sw, nw_se}) do
    {e_w * 2 + ne_sw - nw_se, ne_sw + nw_se}
  end

  def space_ranges(black_tiles) do
    x_axis = black_tiles |> Stream.map(fn {x, _y} -> x end)
    y_axis = black_tiles |> Stream.map(fn {_x, y} -> y end)

    {(Enum.min(x_axis) - 2)..(Enum.max(x_axis) + 2),
     (Enum.min(y_axis) - 1)..(Enum.max(y_axis) + 1)}
  end

  def neighborhood({x, y}) do
    [{x - 1, y + 1}, {x + 1, y + 1}, {x - 1, y - 1}, {x - 2, y}, {x + 1, y - 1}, {x + 2, y}]
  end

  def odd_or_even(x, y) do
    if is_odd(y) do
      is_odd(x)
    else
      !is_odd(x)
    end
  end

  def day(black_tiles) do
    {x_range, y_range} = space_ranges(black_tiles)

    for y <- y_range do
      for x <- x_range, odd_or_even(x, y) do
        neighbors =
          neighborhood({x, y})
          |> Enum.count(fn neighbor -> Enum.member?(black_tiles, neighbor) end)

        if Enum.member?(black_tiles, {x, y}) do
          # was black
          {x, y, if(neighbors == 1 || neighbors == 2, do: :black, else: :white)}
        else
          # was white
          {x, y, if(neighbors == 2, do: :black, else: :white)}
        end
      end
    end
    |> List.flatten()
    |> Enum.filter(fn {_x, _y, color} -> color == :black end)
    |> Enum.map(fn {x, y, _color} -> {x, y} end)
  end

  def days(tiles, days) do
    1..days |> Enum.reduce(tiles, fn _day, tiles -> day(tiles) end)
  end
end
