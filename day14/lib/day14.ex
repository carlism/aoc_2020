use Bitwise

defmodule Day14 do
  @moduledoc """
  Documentation for Day14.
  """
  def part1() do
    Day14.process("input.txt") |> IO.puts()
  end

  def part2() do
    Day14.process_v2("input.txt") |> IO.puts()
  end

  def apply_mask(mask, value) do
    value = String.to_integer(value)
    {or_mask, _} = String.replace(mask, "X", "0") |> Integer.parse(2)
    value = value ||| or_mask
    {and_mask, _} = String.replace(mask, "X", "1") |> Integer.parse(2)
    value &&& and_mask
  end

  def process(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Enum.reduce({String.duplicate("X", 36), %{}}, fn line, {mask, memory} ->
      mask_cap = Regex.named_captures(~r/mask = (?<m>[X01]{36})/, line)
      mem_cap = Regex.named_captures(~r/mem\[(?<a>\d+)\]\s=\s(?<v>\d+)/, line)

      if mask_cap do
        {mask_cap["m"], memory}
      else
        if mem_cap do
          {mask, Map.put(memory, mem_cap["a"], apply_mask(mask, mem_cap["v"]))}
        end
      end
    end)
    |> elem(1)
    |> Map.values()
    |> Enum.sum()
  end

  def apply_address_mask(mask, address) do
    floating_address =
      mask
      |> String.graphemes()
      |> Enum.zip(address |> String.pad_leading(36, "0") |> String.graphemes())
      |> Enum.map(fn
        {"0", a} -> a
        {"1", _} -> "1"
        {"X", _} -> "X"
      end)

    x_count = Enum.count(floating_address, fn x -> x == "X" end)

    0..floor(:math.pow(2, x_count) - 1)
    |> Enum.map(fn float_value ->
      float_value
      |> Integer.to_string(2)
      |> String.pad_leading(x_count, "0")
      |> String.graphemes()
      |> Enum.reduce(floating_address |> Enum.join(), fn digit, addr ->
        String.replace(addr, "X", digit, global: false)
      end)
    end)
  end

  def put_memory_values(memory, mask, address, value_str) do
    value = String.to_integer(value_str)

    apply_address_mask(mask, address |> String.to_integer() |> Integer.to_string(2))
    |> Enum.reduce(memory, fn addr, memory -> Map.put(memory, addr, value) end)
  end

  def process_v2(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Enum.reduce({String.duplicate("X", 36), %{}}, fn line, {mask, memory} ->
      mask_cap = Regex.named_captures(~r/mask = (?<m>[X01]{36})/, line)
      mem_cap = Regex.named_captures(~r/mem\[(?<a>\d+)\]\s=\s(?<v>\d+)/, line)

      if mask_cap do
        {mask_cap["m"], memory}
      else
        if mem_cap do
          {mask, put_memory_values(memory, mask, mem_cap["a"], mem_cap["v"])}
        end
      end
    end)
    |> elem(1)
    |> Map.values()
    |> Enum.sum()
  end
end
