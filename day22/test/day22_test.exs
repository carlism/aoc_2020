defmodule Day22Test do
  use ExUnit.Case
  doctest Day22

  test "reads the cards" do
    assert Day22.read_input("test/input.txt") |> List.last() == [5, 8, 4, 7, 10]
  end

  test "play combat" do
    assert Day22.read_input("test/input.txt")
           |> Day22.play()
           |> List.last() == [3, 2, 10, 6, 8, 5, 9, 4, 7, 1]
  end

  test "score hands" do
    assert Day22.read_input("test/input.txt")
           |> Day22.play()
           |> Day22.score() == [0, 306]
  end

  test "score recursive" do
    assert Day22.read_input("test/input.txt")
           |> Day22.play2()
           |> Day22.score() == [0, 291]
  end

  test "game ends" do
    assert Day22.play2([[43, 19], [2, 29, 14]]) == [[43, 19], [2, 29, 14]]
  end
end
