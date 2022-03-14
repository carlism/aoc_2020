defmodule Day18 do
  @moduledoc """
  Documentation for Day18.
  """

  def part1 do
    File.stream!("input.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&eval/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.sum()
    |> IO.puts()
  end

  def eval_simple(expr_str) do
    expr = Regex.named_captures(~r/(?<op1>\d+)\s?(?<operand>[+*])\s?(?<op2>\d+)/, expr_str)
    # |> IO.inspect()

    case expr["operand"] do
      "*" -> String.to_integer(expr["op1"]) * String.to_integer(expr["op2"])
      "+" -> String.to_integer(expr["op1"]) + String.to_integer(expr["op2"])
    end
    |> Integer.to_string()
  end

  def eval(expr_str) do
    paren_rex = ~r/(\(\d+(\s?[+*]\s?\d+)+\))/
    parens = Regex.split(paren_rex, expr_str, trim: true, include_captures: true)

    if length(parens) > 1 do
      parens
      |> Enum.map(fn cap ->
        if Regex.match?(paren_rex, cap) do
          eval(cap |> String.slice(1..-2))
        else
          cap
        end
      end)
      |> Enum.join()
      |> eval()
    else
      add_rex = ~r/(\d+\s?\+\s?\d+)/
      mult_rex = ~r/(\d+\s?\*\s?\d+)/

      result =
        if Regex.match?(add_rex, expr_str) do
          Regex.split(add_rex, expr_str, trim: true, include_captures: true)
          |> Enum.map(fn part ->
            if String.match?(part, add_rex) do
              eval_simple(part)
            else
              part
            end
          end)
          |> Enum.join()
          |> eval()
        else
          if Regex.match?(mult_rex, expr_str) do
            Regex.split(mult_rex, expr_str, trim: true, include_captures: true)
            |> Enum.map(fn part ->
              if String.match?(part, mult_rex) do
                eval_simple(part)
              else
                part
              end
            end)
            |> Enum.join()
            |> eval()
          else
            expr_str
          end
        end

      if String.match?(result, ~r/^\d+$/) do
        result
      else
        eval(result)
      end
    end
  end
end
