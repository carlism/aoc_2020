defmodule Day21 do
  @moduledoc """
  Documentation for Day21.
  """

  def part2 do
    input = Day21.read_input("input.txt")

    alergen_map = Day21.build_alergen_map(input)

    specific_alergens = Day21.narrow_alergens(alergen_map)

    specific_alergens
    |> Enum.to_list()
    |> Enum.sort(fn {_i1, a1}, {_i2, a2} -> a1 < a2 end)
    |> Enum.map(fn {i, _a} -> i end)
    |> Enum.join(",")
    |> IO.puts()
  end

  def read_input(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn line -> line |> String.split(" (contains ") end)
    |> Stream.map(fn [ingredients, alergens] ->
      [String.split(ingredients), alergens |> String.replace(")", "") |> String.split(", ")]
    end)
  end

  def build_alergen_map(input) do
    input
    |> Enum.reduce(%{}, fn line, map ->
      [ingredients, alergens] = line

      alergens
      |> Enum.reduce(map, fn alergen, map ->
        set = Map.get(map, alergen)

        if set do
          Map.put(map, alergen, set |> MapSet.intersection(MapSet.new(ingredients)))
        else
          Map.put(map, alergen, MapSet.new(ingredients))
        end
      end)
    end)
  end

  def narrow_alergens(alergen_map) do
    Stream.resource(
      fn -> alergen_map end,
      fn map ->
        uniques = map |> Enum.filter(fn {_key, set} -> MapSet.size(set) == 1 end)

        if Enum.count(uniques) == 0 do
          {:halt, map}
        else
          elements =
            uniques |> Enum.map(fn {key, set} -> {MapSet.to_list(set) |> List.first(), key} end)

          ingredients_map = Map.new(elements)

          new_map =
            map
            |> Enum.reject(fn {_key, set} -> MapSet.size(set) == 1 end)
            |> Enum.map(fn {key, set} ->
              {key,
               MapSet.new(
                 MapSet.to_list(set)
                 |> Enum.reject(fn ingredient ->
                   Map.keys(ingredients_map) |> Enum.member?(ingredient)
                 end)
               )}
            end)

          {elements, new_map}
        end
      end,
      fn _map -> nil end
    )
    |> Map.new()
  end
end
