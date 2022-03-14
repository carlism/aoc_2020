defmodule Day20Test do
  use ExUnit.Case
  doctest Day20

  test "reads the input" do
    input = Day20.read_input("test/input.txt")
    assert input |> Enum.count() == 9
    assert input["2311"] |> List.first() == "..##.#..#."
  end

  test "edge_to_num" do
    assert Day20.edge_to_num("..#.......") == 128
    assert Day20.edge_to_num(String.reverse("..#.......")) == 4
  end

  test "left and right edges" do
    data = Day20.read_input("test/input.txt")["3079"]
    assert Day20.get_left_edge(data) == "#..##.#..."
    assert Day20.get_right_edge(data) == ".#....#..."
  end

  test "pivot function" do
    data = [
      "#....####.",
      "#..#.##...",
      "#.##..#...",
      "######.#.#",
      ".#...#.#.#",
      ".#########",
      ".###.#..#.",
      "########.#",
      "##...##.#.",
      "..###.#.#."
    ]

    assert Day20.pivot(data) == [
             "####...##.",
             "...######.",
             "..##.###.#",
             ".###.###.#",
             "...#.#.#.#",
             "##.######.",
             "###..#.###",
             "#..###.#..",
             "#....##.##",
             "...###.#.."
           ]
  end

  test "derive edge values" do
    data = Day20.read_input("test/input.txt")["3079"]
    values = Day20.derive_edges(data)
    assert values |> Enum.count() == 8
    assert Enum.member?(values, 8 + 256)
    assert Enum.member?(values, 2 + 64)
  end

  test "pair-up by edge values" do
    assert Day20.read_input("test/input.txt")
           |> Day20.derive_all_edges()
           |> Day20.pair_up()
           |> Day20.tile_connections()
           |> Day20.with_connections(2)
           |> Day20.multiply() == 20_899_048_083_289
  end

  test "piece together parts" do
    input_tiles = Day20.read_input("test/input.txt")

    assert input_tiles
           |> Day20.derive_all_edges()
           |> Day20.pair_up()
           |> Day20.tile_connections()
           |> Day20.arrange_tiles()
           |> Enum.to_list() == [
             ["1171", "1489", "2971"],
             ["2473", "1427", "2729"],
             ["3079", "2311", "1951"]
           ]
  end

  test "stripping edges" do
    data = Day20.read_input("test/input.txt")["3079"]

    assert Day20.strip_edges(data) == [
             "#..#####",
             ".#......",
             "#####...",
             "###.#..#",
             "#...#.##",
             ".#####.#",
             ".#.###..",
             ".#......"
           ]
  end

  test "render puzzle" do
    input_tiles = Day20.read_input("test/input.txt")

    assert input_tiles
           |> Day20.derive_all_edges()
           |> Day20.pair_up()
           |> Day20.tile_connections()
           |> Day20.arrange_tiles()
           |> Day20.render_puzzle(input_tiles)

    #  |> IO.inspect()
  end

  test "find monster" do
    input_tiles = Day20.read_input("input.txt")

    puzzle =
      assert input_tiles
             |> Day20.derive_all_edges()
             |> Day20.pair_up()
             |> Day20.tile_connections()
             |> Day20.arrange_tiles()
             |> Day20.render_puzzle(input_tiles)

    regex = Day20.monster_regex(puzzle |> List.first() |> String.length())
    assert regex == "(..................#.).{76}(#....##....##....###).{76}(.#..#..#..#..#..#...)"
    {ok, r} = Regex.compile(regex)

    hash_count =
      puzzle
      |> Enum.join()
      |> String.graphemes()
      |> Enum.filter(fn x -> x == "#" end)
      |> Enum.count()
      |> IO.inspect()

    orientations = [
      puzzle,
      Day20.flip_vertical(puzzle),
      Day20.flip_horizontal(puzzle),
      Day20.flip_vertical(Day20.flip_horizontal(puzzle)),
      Day20.pivot(puzzle),
      Day20.flip_horizontal(Day20.pivot(puzzle)),
      Day20.flip_vertical(Day20.pivot(puzzle)),
      Day20.flip_horizontal(Day20.flip_vertical(Day20.pivot(puzzle)))
    ]

    IO.puts(Day20.flip_vertical(Day20.flip_horizontal(puzzle)) |> Enum.join("\n"))

    orientations
    |> Enum.map(fn p -> Day20.find_all(r, p |> Enum.join()) end)
    |> Enum.reject(fn x -> x == [] end)
    |> Enum.map(fn matches -> matches |> Enum.count() end)
    |> Enum.map(fn match_count -> hash_count - match_count * 15 end)
    |> IO.inspect()
  end
end
