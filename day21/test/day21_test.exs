defmodule Day21Test do
  use ExUnit.Case
  doctest Day21

  test "read the file" do
    line1 = Day21.read_input("test/input.txt") |> Stream.take(1) |> Enum.to_list() |> List.first()
    assert List.first(line1) == ["mxmxvkd", "kfcds", "sqjhc", "nhms"]
    assert List.last(line1) == ["dairy", "fish"]
  end

  test "first pass" do
    input = Day21.read_input("test/input.txt")

    alergen_map = Day21.build_alergen_map(input)

    specific_alergens = Day21.narrow_alergens(alergen_map)
    bad_ingredients = specific_alergens |> Map.keys()

    assert input
           |> Enum.map(fn [ingredients, _alergens] ->
             ingredients
             |> Enum.reject(fn i -> Enum.member?(bad_ingredients, i) end)
             |> Enum.count()
           end)
           |> Enum.sum() == 5
  end

  test "reorder safe" do
    input = Day21.read_input("test/input.txt")

    alergen_map = Day21.build_alergen_map(input)

    specific_alergens = Day21.narrow_alergens(alergen_map)

    assert specific_alergens
           |> Enum.to_list()
           |> Enum.sort(fn {_i1, a1}, {_i2, a2} -> a1 < a2 end)
           |> Enum.map(fn {i, _a} -> i end)
           |> Enum.join(",") == "mxmxvkd,sqjhc,fvjkl"
  end
end
