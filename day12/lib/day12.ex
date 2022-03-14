defmodule Day12 do
  @moduledoc """
  Documentation for Day12.
  """

  @north {1, 0}
  @south {-1, 0}
  @east {0, 1}
  @west {0, -1}
  @right_turns [@north, @east, @south, @west]

  def part1 do
    Day12.read_data("input.txt")
    |> Day12.calc_distances()
    |> Day12.sum_distances()
    |> IO.inspect()
  end

  def part2 do
    Day12.read_data("input.txt")
    |> Day12.navigate()
    |> IO.inspect()
  end

  def read_data(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn s -> String.split_at(s, 1) end)
    |> Stream.map(fn {x, y} -> {x, String.to_integer(y)} end)
  end

  def move({x, y}, value) do
    {x * value, y * value}
  end

  def turn_right(heading, value) do
    Enum.at(
      @right_turns,
      rem(
        Enum.find_index(@right_turns, fn i -> i == heading end) + floor(value / 90),
        4
      )
    )
  end

  def calc_change({heading, {inst, value}}) do
    case inst do
      "N" -> {heading, move(@north, value)}
      "S" -> {heading, move(@south, value)}
      "E" -> {heading, move(@east, value)}
      "W" -> {heading, move(@west, value)}
      "F" -> {heading, move(heading, value)}
      "L" -> calc_change({heading, {"R", 360 - value}})
      "R" -> {turn_right(heading, value), {0, 0}}
    end
  end

  def calc_distances(stream) do
    stream
    |> Stream.transform(@east, fn cmd, heading ->
      {new_heading, distance} = calc_change({heading, cmd})
      {[distance], new_heading}
    end)
  end

  def sum_distances(stream) do
    stream |> Enum.reduce({0, 0}, fn {dx, dy}, {tx, ty} -> {tx + dx, ty + dy} end)
  end

  def navigate(stream) do
    stream
    |> Stream.transform(%State{}, fn {inst, value},
                                     %State{
                                       ship: ship,
                                       waypoint: waypoint
                                     } = state ->
      new_state =
        case inst do
          "N" -> %{state | waypoint: Position.move(waypoint, {0, 1}, value)}
          "S" -> %{state | waypoint: Position.move(waypoint, {0, -1}, value)}
          "E" -> %{state | waypoint: Position.move(waypoint, {1, 0}, value)}
          "W" -> %{state | waypoint: Position.move(waypoint, {-1, 0}, value)}
          "R" -> %{state | waypoint: Position.rotate(waypoint, value)}
          "L" -> %{state | waypoint: Position.rotate(waypoint, 360 - value)}
          "F" -> %{state | ship: Position.move(ship, Position.to_vector(waypoint), value)}
        end

      # IO.inspect([{inst, value}, state, new_state])

      {[new_state], new_state}
    end)
    |> Enum.to_list()
    |> List.last()
  end
end
