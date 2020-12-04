defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  test "parses the input" do
    data = Day4.parse_file("test/data/test_input.txt")
    assert Enum.count(data) == 4
  end

  test "parses the input into list of tuples" do
    data = Day4.parse_file("test/data/test_input.txt")

    assert Enum.at(data, 0) == [
             {"ecl", "gry"},
             {"pid", "860033327"},
             {"eyr", "2020"},
             {"hcl", "#fffffd"},
             {"byr", "1937"},
             {"iyr", "2017"},
             {"cid", "147"},
             {"hgt", "183cm"}
           ]
  end

  test "validate passports" do
    assert Day4.parse_file("test/data/test_input.txt")
           |> Day4.validate()
           |> Stream.filter(fn x -> x end)
           |> Enum.count() == 2
  end

  test "validates year" do
    record = [
      {"eyr", "2020"},
      {"byr", "1937"},
      {"iyr", "2017"}
    ]

    assert Day4.has_valid_year(Day4.field_val(record, "byr"), 1920, 2002) == true
    assert Day4.has_valid_year(Day4.field_val(record, "iyr"), 2010, 2020) == true
    assert Day4.has_valid_year(Day4.field_val(record, "eyr"), 2020, 2030) == true
    assert Day4.has_valid_year(Day4.field_val(record, "eyr"), 1920, 2002) == false
    assert Day4.has_valid_year(Day4.field_val(record, "xyr"), 1920, 2002) == false
  end

  test "validates height" do
    assert Day4.has_valid_height([{"hgt", "183cm"}]) == true
    assert Day4.has_valid_height([{"hgt", "60in"}]) == true
    assert Day4.has_valid_height([{"hgt", "190cm"}]) == true
    assert Day4.has_valid_height([{"hgt", "190in"}]) == false
    assert Day4.has_valid_height([{"hgt", "190"}]) == false
  end

  test "validates hair color" do
    assert Day4.has_valid_hair_color([{"hcl", "#ae17e1"}]) == true
    assert Day4.has_valid_hair_color([{"hcl", "#123abz"}]) == false
    assert Day4.has_valid_hair_color([{"hcl", "123abc"}]) == false
  end

  test "validates eye color" do
    assert Day4.has_valid_eye_color([{"ecl", "brn"}]) == true
    assert Day4.has_valid_eye_color([{"ecl", "wat"}]) == false
  end

  test "validates pid" do
    assert Day4.has_valid_pid([{"pid", "000000001"}]) == true
    assert Day4.has_valid_pid([{"pid", "0123456789"}]) == false
  end

  test "valid passports" do
    assert Day4.parse_file("test/data/valid_input.txt")
           |> Day4.validate()
           |> Stream.filter(fn x -> x end)
           |> Enum.count() == 4
  end

  test "invalid passports" do
    assert Day4.parse_file("test/data/invalid_input.txt")
           |> Day4.validate()
           |> Stream.filter(fn x -> x end)
           |> Enum.count() == 0
  end
end
