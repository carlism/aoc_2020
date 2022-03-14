defmodule Day13 do
  @moduledoc """
  Documentation for Day13.
  """

  def part1 do
    {start, buses} = read_data("input.txt")

    {departure_time, departing_buses} =
      next_departure(start, buses |> Enum.filter(fn bus -> bus != -1 end))

    IO.puts("Next departure time: #{departure_time} buses #{Enum.join(departing_buses, ",")}")
    IO.puts("#{departure_time - start} minutes from now")
  end

  def part2 do
    read_data("input.txt")
    |> elem(1)
    |> find_sequenced_departures_2()
    |> IO.puts()
  end

  def read_data(filename) do
    lines = File.stream!(filename) |> Stream.map(&String.trim/1) |> Enum.to_list()

    {lines |> List.first() |> String.to_integer(),
     lines
     |> List.last()
     |> String.split(",")
     |> Enum.map(fn id ->
       case Integer.parse(id) do
         {int, _bin} -> int
         :error -> -1
       end
     end)}
  end

  def departures_at(time, buses) do
    buses |> Enum.map(fn bus -> rem(time, bus) == 0 end)
  end

  def find_next_departure(time, buses) do
    Stream.iterate(time, &(&1 + 1))
    |> Stream.map(fn timeslot ->
      {timeslot, departures_at(timeslot, buses)}
    end)
    |> Stream.filter(fn {_ts, departures} ->
      Enum.any?(departures)
    end)
    |> Stream.take(1)
    |> Enum.to_list()
    |> List.first()
  end

  def next_departure(time, buses) do
    {time, departing} = find_next_departure(time, buses)

    {time,
     departing
     |> Enum.zip(buses)
     |> Enum.filter(fn {departs, _bus} -> departs end)
     |> Enum.map(fn x -> elem(x, 1) end)}
  end

  def sequenced_departures(time, buses) do
    buses
    |> Enum.map(fn
      {bus, offset} -> rem(time + offset, bus) == 0
    end)
  end

  def find_sequenced_departures(buses) do
    first_bus = Enum.at(buses, 0)
    buses_idx = filter_and_add_offsets(buses)

    Stream.iterate(first_bus, fn time -> time + first_bus end)
    |> Stream.map(fn time -> {time, sequenced_departures(time, buses_idx)} end)
    |> Stream.filter(fn {_t, depart_list} -> depart_list |> Enum.all?() end)
    |> Stream.take(1)
    |> Enum.to_list()
    |> List.first()
    |> elem(0)
  end

  def filter_and_add_offsets(buses) do
    buses |> Enum.with_index() |> Enum.filter(fn {x, _} -> x != -1 end)
  end

  def search(indexed_buses, start_time, skip_factor, bus_count) do
    rendezvous =
      Stream.iterate(start_time, fn time -> time + skip_factor end)
      |> Stream.map(fn time ->
        {time, sequenced_departures(time, indexed_buses |> Enum.slice(0, bus_count))}
      end)
      |> Stream.filter(fn {_t, depart_list} -> depart_list |> Enum.all?() end)
      |> Stream.take(1)
      |> Enum.to_list()
      |> List.first()
      |> elem(0)

    if bus_count == length(indexed_buses) do
      rendezvous
    else
      search(
        indexed_buses,
        rendezvous,
        BasicMath.lcm(
          indexed_buses
          |> Enum.slice(0, bus_count)
          |> Enum.map(fn b -> elem(b, 0) end)
        ),
        bus_count + 1
      )
    end
  end

  def find_sequenced_departures_2(buses) do
    first_bus = Enum.at(buses, 0)
    filter_and_add_offsets(buses) |> search(first_bus, first_bus, 2)
  end
end
