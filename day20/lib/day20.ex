defmodule Day20 do
  @moduledoc """
  Documentation for Day20.
  """

  def part1 do
    Day20.read_input("input.txt")
    |> Day20.derive_all_edges()
    |> Day20.pair_up()
    |> Day20.tile_connections()
    |> Day20.corners()
    |> Day20.multiply()
    |> IO.puts()
  end

  def read_input(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.chunk_by(fn line -> line == "" end)
    |> Stream.reject(fn chunk -> chunk == [""] end)
    |> Stream.map(fn chunk ->
      [tile | data] = chunk
      tile = Regex.run(~r/\d+/, tile) |> Enum.at(0)
      {tile, data}
    end)
    |> Map.new()
  end

  def edge_to_num(edge) do
    edge |> String.replace(".", "0") |> String.replace("#", "1") |> String.to_integer(2)
  end

  def get_left_edge(data) do
    data |> Enum.map(fn line -> line |> String.slice(0..0) end) |> Enum.join()
  end

  def get_right_edge(data) do
    data |> Enum.map(fn line -> line |> String.slice(-1..-1) end) |> Enum.join()
  end

  def derive_edges(tile_data) do
    [
      List.first(tile_data),
      List.last(tile_data),
      get_left_edge(tile_data),
      get_right_edge(tile_data)
    ]
    |> Enum.map(fn edge -> [edge, String.reverse(edge)] end)
    |> List.flatten()
    |> Enum.map(&edge_to_num/1)
  end

  def derive_all_edges(data) do
    data |> Enum.map(fn {tile, data} -> {tile, Day20.derive_edges(data)} end) |> Map.new()
  end

  def pair_up(values) do
    Enum.reduce(values, %{}, fn {id, edges}, map ->
      Enum.reduce(edges, map, fn edge_num, map ->
        Map.put(map, edge_num, [id | Map.get(map, edge_num, [])])
      end)
    end)
  end

  def tile_connections(edge_data) do
    Enum.reduce(edge_data, %{}, fn
      {_id, [tile1, tile2]}, map ->
        map
        |> Map.put(tile1, [tile2 | Map.get(map, tile1, [])])
        |> Map.put(tile2, [tile1 | Map.get(map, tile2, [])])

      {_id, [_tile1]}, map ->
        map
    end)
    |> Enum.map(fn {tile, connections} -> {tile, Enum.uniq(connections)} end)
    |> Map.new()
  end

  def with_connections(data, conn_count) do
    data
    |> Enum.filter(fn {_tile, connections} -> Enum.count(connections) == conn_count end)
    |> Enum.map(fn {tile, _conn} -> tile end)
  end

  def multiply(corners) do
    corners |> Enum.reduce(1, fn tile, acc -> String.to_integer(tile) * acc end)
  end

  def edges_till_corner(data, start_tile, alt \\ false) do
    corners = with_connections(data, 2)
    edges = with_connections(data, 3)

    Stream.resource(
      fn -> {start_tile, nil} end,
      fn
        {nil, nil} ->
          {:halt, nil}

        {first_tile, nil} ->
          next_tile =
            if alt do
              Enum.reverse(data[first_tile])
            else
              data[first_tile]
            end
            |> Enum.find(fn next -> Enum.member?(edges, next) end)

          {[first_tile, next_tile], {next_tile, first_tile}}

        {last_tile, prev_tile} ->
          valid_edges = edges |> Enum.reject(fn x -> x == prev_tile end)

          found_edge =
            data[last_tile] |> Enum.find(fn next -> Enum.member?(valid_edges, next) end)

          if found_edge do
            {[found_edge], {found_edge, last_tile}}
          else
            valid_corners = corners |> Enum.reject(fn x -> x == prev_tile end)

            found_corner =
              data[last_tile] |> Enum.find(fn next -> Enum.member?(valid_corners, next) end)

            {[found_corner], {nil, nil}}
          end
      end,
      fn _acc -> nil end
    )
  end

  def build_row(last_tile, prev_row, next_index, _data) when next_index >= length(prev_row) do
    [last_tile]
  end

  def build_row(last_tile, prev_row, next_index, data) do
    next_tile =
      MapSet.new(data[last_tile])
      |> MapSet.intersection(
        MapSet.new(
          data[Enum.at(prev_row, next_index)]
          |> Enum.reject(fn t -> Enum.member?(prev_row, t) end)
        )
      )
      |> Enum.at(0)

    [last_tile | build_row(next_tile, prev_row, next_index + 1, data)]
  end

  def generate_rows([], last_row, _data) do
    [last_row]
  end

  def generate_rows(start_tiles, prev_row, data) do
    [first_tile | remaining] = start_tiles
    this_row = build_row(first_tile, prev_row, 1, data)
    [prev_row | generate_rows(remaining, this_row, data)]
  end

  def arrange_tiles(data) do
    corner1 = Enum.at(with_connections(data, 2), 0)

    first_row = edges_till_corner(data, corner1) |> Enum.to_list()
    first_col = edges_till_corner(data, corner1, true) |> Enum.to_list()
    first_col |> Enum.slice(1..-1) |> generate_rows(first_row, data)
  end

  def strip_edges(tile_data) do
    tile_data |> Enum.slice(1..-2) |> Enum.map(fn line -> String.slice(line, 1..-2) end)
  end

  def flip_vertical(tile_data) do
    tile_data |> Enum.reverse()
  end

  def flip_horizontal(tile_data) do
    tile_data |> Enum.map(fn row -> row |> String.reverse() end)
  end

  def pivot(tile_data) do
    tile_data
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.join/1)
  end

  def reorient_left_edge(this_tile, right_edge) do
    case derive_edges(this_tile)
         |> Enum.find_index(fn edge -> edge == right_edge end) do
      # top, top_r, bottom, bottom_r, left, left_r, right, right_r
      0 -> pivot(this_tile)
      1 -> flip_vertical(pivot(this_tile))
      2 -> flip_horizontal(pivot(this_tile))
      3 -> flip_vertical(flip_horizontal(pivot(this_tile)))
      4 -> this_tile
      5 -> flip_vertical(this_tile)
      6 -> flip_horizontal(this_tile)
      7 -> flip_horizontal(flip_vertical(this_tile))
    end
  end

  def reorient_right_edge(this_tile, left_edge) do
    case derive_edges(this_tile)
         |> Enum.find_index(fn edge -> edge == left_edge end) do
      # top, top_r, bottom, bottom_r, left, left_r, right, right_r
      0 -> flip_horizontal(pivot(this_tile))
      1 -> flip_vertical(flip_horizontal(pivot(this_tile)))
      2 -> pivot(this_tile)
      3 -> flip_vertical(pivot(this_tile))
      4 -> flip_horizontal(this_tile)
      5 -> flip_horizontal(flip_vertical(this_tile))
      6 -> this_tile
      7 -> flip_vertical(this_tile)
    end
  end

  def rearrange_tile_row([left_tile, right_tile] = tiles) do
    [left_edge_set, right_edge_set] =
      tiles |> Enum.map(&derive_edges/1) |> Enum.map(&MapSet.new/1)

    matched_edge = MapSet.intersection(left_edge_set, right_edge_set) |> Enum.at(0)

    [reorient_right_edge(left_tile, matched_edge), reorient_left_edge(right_tile, matched_edge)]
  end

  def rearrange_tile_row(tiles) do
    [this_tile | rest] = tiles

    tail = rearrange_tile_row(rest)

    [
      reorient_right_edge(this_tile, tail |> Enum.at(0) |> get_left_edge() |> edge_to_num())
      | tail
    ]
  end

  def flip_row_vertical(row) do
    row |> Enum.map(fn tile -> flip_vertical(tile) end)
  end

  def reorient_rows([top_row, bottom_row]) do
    case [
      List.first(List.first(top_row)),
      List.last(List.first(top_row)),
      List.first(List.first(bottom_row)),
      List.last(List.first(bottom_row))
    ] do
      [x, _, x, _] -> [flip_row_vertical(top_row), bottom_row]
      [x, _, _, x] -> [flip_row_vertical(top_row), flip_row_vertical(bottom_row)]
      [_, x, x, _] -> [top_row, bottom_row]
      [_, x, _, x] -> [top_row, flip_row_vertical(bottom_row)]
    end
  end

  def reorient_rows([top_row | more_rows]) do
    bottom_rows = reorient_rows(more_rows)
    top_of_bottom = List.first(List.first(List.first(bottom_rows)))

    if List.first(List.first(top_row)) == top_of_bottom do
      [flip_row_vertical(top_row) | bottom_rows]
    else
      [top_row | bottom_rows]
    end
  end

  def rearange_tiles(tiles) do
    tiles |> Enum.map(fn row -> rearrange_tile_row(row) end) |> reorient_rows()
  end

  def render_puzzle(assembled_tiles, tile_data) do
    assembled_tiles
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn tile_id -> tile_data[tile_id] end)
      |> rearrange_tile_row()
    end)
    |> reorient_rows()
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn tile -> strip_edges(tile) end)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&Enum.join/1)
    end)
    |> List.flatten()
  end

  def monster() do
    ["..................#.", "#....##....##....###", ".#..#..#..#..#..#..."]
  end

  def monster_regex(puzzle_size) do
    gap_size = puzzle_size - (monster() |> List.first() |> String.length())
    monster() |> Enum.map(fn line -> "(#{line})" end) |> Enum.join(".{#{gap_size}}")
  end

  def find_all(regex, puzzle) do
    result = Regex.run(regex, puzzle, return: :index)

    if result == nil do
      []
    else
      index = (result |> List.first() |> elem(0)) + 1
      [result |> List.first() | find_all(regex, puzzle |> String.slice(index..-1))]
    end
  end
end
