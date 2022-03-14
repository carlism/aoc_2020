defmodule Day22 do
  @moduledoc """
  Documentation for Day22.
  """

  def part1 do
    read_input("input.txt") |> play() |> score() |> IO.inspect()
  end

  def part2 do
    read_input("input.txt") |> play2() |> score() |> IO.inspect()
  end

  def read_input(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn line -> String.split(line, ",") |> Enum.map(&String.to_integer/1) end)
    |> Stream.take(2)
    |> Enum.to_list()
  end

  def play([_hand1, []] = cards) do
    cards
  end

  def play([[], _hand2] = cards) do
    cards
  end

  def play([[card1 | hand1], [card2 | hand2]]) do
    if card1 > card2 do
      play([[hand1 | [card1, card2]] |> List.flatten(), hand2])
    else
      play([hand1, [hand2 | [card2, card1]] |> List.flatten()])
    end
  end

  def play2(cards, history \\ MapSet.new())

  def play2([_hand1, []] = cards, _hist) do
    cards
  end

  def play2([[], _hand2] = cards, _hist) do
    cards
  end

  def play2([[card1 | hand1], [card2 | hand2]] = cards, history) do
    # IO.inspect(cards)

    if MapSet.member?(history, cards) do
      cards
    else
      if card1 <= Enum.count(hand1) && card2 <= Enum.count(hand2) do
        subgame = play2([hand1 |> Enum.slice(0, card1), hand2 |> Enum.slice(0, card2)])

        case subgame do
          [[], _hand2] ->
            play2([hand1, [hand2 | [card2, card1]] |> List.flatten()], MapSet.put(history, cards))

          [_hand1, _hand2] ->
            play2([[hand1 | [card1, card2]] |> List.flatten(), hand2], MapSet.put(history, cards))
        end
      else
        if card1 > card2 do
          play2([[hand1 | [card1, card2]] |> List.flatten(), hand2], MapSet.put(history, cards))
        else
          play2([hand1, [hand2 | [card2, card1]] |> List.flatten()], MapSet.put(history, cards))
        end
      end
    end
  end

  def score(hands) do
    hands
    |> Enum.map(fn hand ->
      hand
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.map(fn {card, index} -> card * (index + 1) end)
      |> Enum.sum()
    end)
  end
end
