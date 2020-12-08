defmodule Day8Test do
  use ExUnit.Case
  doctest Day8

  test "runs test" do
    result =
      Day8.start_link(Day8.parse_program("test/test_input.txt"))
      |> elem(1)
      |> Day8.run()
      |> Day8.await_completion()

    assert result == 5
  end

  test "runs adjusted test" do
    result =
      Day8.start_link(Day8.parse_program("test/test_input.1.txt"))
      |> elem(1)
      |> Day8.run()
      |> Day8.await_completion()

    assert result == 8
  end
end
