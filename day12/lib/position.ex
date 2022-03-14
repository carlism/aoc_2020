defmodule Position do
  defstruct x: 0, y: 0

  def move(%Position{x: x, y: y}, {dx, dy}, scale) do
    %Position{x: x + dx * scale, y: y + dy * scale}
  end

  def to_vector(%Position{x: x, y: y}) do
    {x, y}
  end

  def rotate(position, angle) do
    1..floor(angle / 90)
    |> Enum.reduce(position, fn _i, %Position{x: x, y: y} ->
      %Position{x: y, y: -x}
    end)
  end
end
