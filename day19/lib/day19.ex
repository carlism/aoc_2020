defmodule Day19 do
  @moduledoc """
  Documentation for Day19.
  """

  def part1 do
    [rules | messages] = read_input("input.txt")
    rules = Day19.parsed_rules(rules)
    rex = Day19.build_rex(rules, 0)
    {:ok, regex} = Regex.compile("^#{rex}$")

    messages
    |> Enum.map(fn msg -> Regex.match?(regex, msg) end)
    |> Enum.filter(fn x -> x end)
    |> Enum.count()
    |> IO.puts()
  end

  def part2 do
    [rules | messages] = read_input("input.1.txt")
    rules = Day19.parsed_rules(rules)
    rex = Day19.build_rex(rules, 0)
    IO.inspect(String.length(rex))
    {:ok, regex} = :re2.compile("^#{rex}$")

    messages
    |> Enum.map(fn msg -> :re2.run(msg, regex) end)
    |> Enum.filter(fn
      :nomatch -> false
      {:match, _} -> true
    end)
    |> Enum.count()
    |> IO.puts()
  end

  def read_input(filename) do
    [rules | messages] =
      File.stream!(filename)
      |> Stream.map(&String.trim/1)
      |> Stream.chunk_by(fn x -> x == "" end)
      |> Stream.reject(fn x -> x == [""] end)
      |> Enum.to_list()

    [
      rules
      |> Stream.map(fn x -> x |> String.split(~r/:\s?/, parts: 2, trim: true) end)
      |> Enum.reduce(%{}, fn [i, v], map ->
        Map.put(map, String.to_integer(i), v)
      end)
      | messages |> List.flatten()
    ]
  end

  def parse_rule(rule) do
    letter_result = Regex.named_captures(~r/"(?<letter>.+)"/, rule)

    if letter_result do
      %SingleLetter{letter: letter_result["letter"]}
    else
      alt_result = String.split(rule, "|")

      if Enum.count(alt_result) > 1 do
        %Alternation{
          left: parse_rule(List.first(alt_result)),
          right: parse_rule(List.last(alt_result))
        }
      else
        rep_result = Regex.named_captures(~r/(?<thing>.+)\+/, rule)

        if rep_result do
          %Repeat{expr: parse_rule(rep_result["thing"])}
        else
          nest_result = String.split(rule, "^")

          if Enum.count(nest_result) > 1 do
            %Nest{
              left: parse_rule(List.first(nest_result)),
              right: parse_rule(List.last(nest_result))
            }
          else
            seq_result = Regex.scan(~r/\d+/, rule)

            if seq_result != [] do
              %Sequence{
                refs: seq_result |> Enum.map(&List.first/1) |> Enum.map(&String.to_integer/1)
              }
            end
          end
        end
      end
    end
  end

  def parsed_rules(input) do
    input
    |> Enum.map(fn {i, r} -> {i, parse_rule(r)} end)
    |> Map.new()
  end

  def build_rex(rules, start, cache \\ nil) do
    {:ok, cache} =
      if cache == nil do
        Agent.start_link(fn -> %{} end)
      else
        {:ok, cache}
      end

    if Agent.get(cache, fn map -> map[start] end) == nil do
      result = rule_rex(rules, rules[start], cache)
      Agent.update(cache, fn map -> Map.put(map, start, result) end)
    end

    Agent.get(cache, fn map -> map[start] end)
  end

  def rule_rex(rules, rule, c) do
    case rule do
      %SingleLetter{letter: l} ->
        l

      %Alternation{left: l, right: r} ->
        "(#{rule_rex(rules, l, c)}|#{rule_rex(rules, r, c)})"

      %Sequence{refs: rs} ->
        Enum.map(rs, fn r -> build_rex(rules, r, c) end) |> Enum.join()

      %Repeat{expr: e} ->
        "(#{rule_rex(rules, e, c)})+"

      %Nest{left: l, right: r} ->
        left = rule_rex(rules, l, c)
        right = rule_rex(rules, r, c)

        2..10
        |> Enum.map(fn count ->
          "(#{left}{#{count}}#{right}{#{count}})"
        end)
        |> Enum.join("|")
    end
  end
end
