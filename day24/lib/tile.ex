defmodule Tile do
  @moduledoc """
  This represents a hexagonal tile.  Because the tiles are hexagonal, every tile
  has six neighbors: east, southeast, southwest, west, northwest, and northeast
  """
  defstruct [:e, :se, :sw, :w, :ne, :nw, state: :white]

  @behaviour Access
  defdelegate get(v, key, default), to: Map
  defdelegate fetch(v, key), to: Map
  defdelegate get_and_update(v, key, func), to: Map
  defdelegate pop(v, key), to: Map

  def reverse_dir(dir) do
    case dir do
      :e -> :w
      :se -> :nw
      :sw -> :ne
      :w -> :e
      :nw -> :se
      :ne -> :sw
    end
  end

  def clockwise(dir) do
    case dir do
      :e -> :se
      :se -> :sw
      :sw -> :w
      :w -> :nw
      :nw -> :ne
      :ne -> :e
    end
  end

  def counter_clockwise(dir) do
    case dir do
      :e -> :ne
      :ne -> :nw
      :nw -> :w
      :w -> :sw
      :sw -> :se
      :se -> :e
    end
  end

  def new(conn, in_dir) do
    conn_dir = reverse_dir(in_dir)
    tile = %Tile{}
    tile = %{tile | conn_dir => conn}
    tile = Tile.fully_connect(tile)
    tile
  end

  def flip(tile) do
    if tile.state == :white do
      %{tile | state: :black}
    else
      %{tile | state: :white}
    end
  end

  def get_adjacents(tile, dir) do
    {tile[clockwise(dir)], tile[counter_clockwise(dir)]}
  end

  def fully_connect(tile) do
    [:e, :se, :sw, :w, :ne, :nw]
    |> Enum.map(fn dir -> {dir, tile[dir]} end)
    |> Enum.filter(fn {_dir, conn} -> conn end)
    |> Enum.reduce(tile, fn {dir, conn}, tile ->
      {ccw, cw} = Tile.get_adjacents(conn, reverse_dir(dir))
      %{tile | clockwise(dir) => cw, counter_clockwise(dir) => ccw}
    end)
  end
end
