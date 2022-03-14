defmodule Day19Test do
  use ExUnit.Case
  doctest Day19

  test "reads the file" do
    assert Day19.read_input("test/input.txt") |> List.first() |> Map.values() == [
             "1 2",
             "\"a\"",
             "1 3 | 3 1",
             "\"b\""
           ]
  end

  test "parse rules" do
    assert Day19.parse_rule("\"a\"") == %SingleLetter{letter: "a"}
    assert Day19.parse_rule("1 2") == %Sequence{refs: [1, 2]}

    assert Day19.parse_rule("4 5 | 5 4") == %Alternation{
             left: %Sequence{refs: [4, 5]},
             right: %Sequence{refs: [5, 4]}
           }
  end

  test "build regex" do
    rules = Day19.read_input("test/input.txt") |> List.first() |> Day19.parsed_rules()
    assert Day19.build_rex(rules, 1) == "a"
    assert Day19.build_rex(rules, 3) == "b"
    assert Day19.build_rex(rules, 2) == "(ab|ba)"
  end

  test "compile regex" do
    [rules | messages] = Day19.read_input("test/input.txt")
    rules = Day19.parsed_rules(rules)
    rex = Day19.build_rex(rules, 0)
    assert rex == "a(ab|ba)"
    {:ok, regex} = Regex.compile(rex)
  end

  test "compile regex 2" do
    [rules | messages] = Day19.read_input("test/input2.txt")
    rules = Day19.parsed_rules(rules)
    rex = Day19.build_rex(rules, 0)
    assert rex == "a((aa|bb)(ab|ba)|(ab|ba)(aa|bb))b"
    {:ok, regex} = Regex.compile("^#{rex}$")

    IO.inspect(messages)
    |> Enum.map(fn msg -> Regex.match?(regex, msg) end)
    |> IO.inspect()
  end
end
