defmodule Day25 do
  @moduledoc """
  Documentation for Day25.
  """
  def loops(n, n) do
    1
  end

  def loops(number, subject \\ 7) do
    loops(number, rem(subject * 7, 20_201_227)) + 1
  end

  def loop(subject, 0) do
    1
  end

  def loop(subject, count) do
    rem(loop(subject, count - 1) * subject, 20_201_227)
  end
end
