defmodule Day4 do
  @moduledoc """
  Documentation for Day4.
  """
  def part1 do
    Day4.parse_file("input.txt")
    |> Day4.validate()
    |> Stream.filter(fn x -> x end)
    |> Enum.count()
    |> IO.puts()
  end

  def required_fields do
    ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
  end

  def valid_eye_colors do
    ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
  end

  def parse_file(filename) do
    File.stream!(filename)
    |> Stream.chunk_while(
      "",
      fn element, acc ->
        if String.trim(element) == "" do
          {:cont, String.split(acc <> " " <> String.trim(element)), ""}
        else
          {:cont, acc <> " " <> String.trim(element)}
        end
      end,
      fn acc -> {:cont, String.split(acc), ""} end
    )
    |> Stream.map(fn record ->
      record
      |> Enum.map(fn field ->
        field |> String.split(":") |> List.to_tuple()
      end)
    end)
  end

  def validate(records) do
    records
    |> Stream.map(fn record ->
      [
        has_required_fields(record),
        has_valid_year(field_val(record, "byr"), 1920, 2002),
        has_valid_year(field_val(record, "iyr"), 2010, 2020),
        has_valid_year(field_val(record, "eyr"), 2020, 2030),
        has_valid_height(record),
        has_valid_hair_color(record),
        has_valid_eye_color(record),
        has_valid_pid(record)
      ]
      |> Enum.all?()
    end)
  end

  def field_val(record, field) do
    record
    |> List.keyfind(field, 0, {nil, nil})
    |> elem(1)
  end

  def has_valid_year(nil, _min, _max) do
    false
  end

  def has_valid_year(field_value, min, max) do
    value =
      field_value
      |> String.to_integer()

    value >= min && value <= max
  end

  def has_valid_height(record) do
    (field_val(record, "hgt") || "")
    |> String.split_at(-2)
    |> validate_height()
  end

  def validate_height({measure, "in"}) do
    value = measure |> String.to_integer()
    value >= 59 && value <= 76
  end

  def validate_height({measure, "cm"}) do
    value = measure |> String.to_integer()
    value >= 150 && value <= 193
  end

  def validate_height({_measure, _unknown_units}) do
    false
  end

  def has_required_fields(record) do
    required_fields()
    |> Enum.map(fn requirement ->
      record |> List.keymember?(requirement, 0)
    end)
    |> Enum.all?()
  end

  def has_valid_hair_color(record) do
    (field_val(record, "hcl") || "")
    |> String.match?(~r/#[0-9a-f]{6}/)
  end

  def has_valid_eye_color(record) do
    valid_eye_colors() |> Enum.member?(field_val(record, "ecl"))
  end

  def has_valid_pid(record) do
    (field_val(record, "pid") || "")
    |> String.match?(~r/^[0-9]{9}$/)
  end
end
