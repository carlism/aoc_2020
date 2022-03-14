defmodule Day15 do
  @moduledoc """
  Documentation for Day15.
  """

  def record_turn(map, turn_count, value) do
    Map.put(map, value, Enum.slice([turn_count | Map.get(map, value, [])], 0..1))
  end

  def next_turn(map, last_num) do
    case Map.get(map, last_num, []) do
      [_x] -> 0
      [x, y] -> x - y
    end
  end

  def play(starting, turns) do
    state_map =
      starting
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {turn, i}, state_map -> record_turn(state_map, i + 1, turn) end)

    last_num = List.last(starting)

    (length(starting) + 1)..turns
    |> Enum.reduce({last_num, state_map}, fn turn, {last, state_map} ->
      next_turn = next_turn(state_map, last)
      if rem(turn, 1_000_000) == 0, do: IO.puts(turn)
      {next_turn, record_turn(state_map, turn, next_turn)}
    end)
    |> elem(0)
  end
end
