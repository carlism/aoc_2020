defmodule Day8 do
  @moduledoc """
  Documentation for Day8.
  """

  def part1 do
    Day8.start_link(Day8.parse_program("input.txt"))
    |> elem(1)
    |> Day8.run()
    |> Day8.await_completion()
    |> IO.puts()
  end

  def part2 do
    program = Day8.parse_program("input.txt")
    {:ok, pid} = Day8.start_link(program)
    pid |> Day8.run() |> Day8.await_completion() |> IO.puts()
    pid |> Day8.get_abort() |> IO.puts()

    pid
    |> Day8.get_trace()
    |> Enum.reduce_while(0, fn {pc, {inst, amt, _visits}}, _acc ->
      new_trial =
        case inst do
          "jmp" -> program |> List.replace_at(pc, {"nop", amt, 0})
          "nop" -> program |> List.replace_at(pc, {"jmp", amt, 0})
          _ -> nil
        end

      if is_nil(new_trial) do
        {:cont, 0}
      else
        IO.puts("Replacing #{inst} at #{pc}")
        {:ok, pid} = Day8.start_link(new_trial)
        result = pid |> Day8.run() |> Day8.await_completion()
        abort = pid |> Day8.get_abort()

        if abort do
          {:cont, 0}
        else
          {:halt, result}
        end
      end
    end)
    |> IO.puts()
  end

  def start_link(program) do
    GenServer.start_link(__MODULE__, program, [])
  end

  def init(program) do
    {:ok,
     %{
       :accumulator => 0,
       :pc => 0,
       :program => program,
       :completed => false,
       :trace => [],
       :abort => false
     }}
  end

  # Completion
  def handle_cast(:done, %{:waiting => from} = state) do
    GenServer.reply(from, {:ok, state[:accumulator]})

    {:noreply, state}
  end

  def handle_cast(:done, state) do
    {:noreply, state}
  end

  def handle_call(:await_completion, _from, %{:completed => true} = state) do
    {:reply, {:ok, state[:accumulator]}, state}
  end

  def handle_call(:await_completion, from, state) do
    {:noreply, state |> Map.put(:waiting, from)}
  end

  def handle_call(:retrieve_trace, _from, %{:trace => trace} = state) do
    {:reply, {:ok, trace}, state}
  end

  def handle_call(:retrieve_abort, _from, %{:abort => abort} = state) do
    {:reply, {:ok, abort}, state}
  end

  # Instructions
  def handle_cast({"acc", amt, _visits}, state) do
    GenServer.cast(self(), :step)

    {:noreply, state |> trace() |> inc(amt) |> advance()}
  end

  def handle_cast({"jmp", amt, _visits}, state) do
    GenServer.cast(self(), :step)
    {:noreply, state |> trace() |> advance(amt)}
  end

  def handle_cast({"nop", _amt, _visits}, state) do
    GenServer.cast(self(), :step)
    {:noreply, state |> trace() |> advance()}
  end

  # Step
  def handle_cast(:step, %{:program => program, :pc => pc} = state)
      when pc < length(program) do
    {inst, amt, visits} = Enum.at(program, pc)
    # IO.inspect({pc, {inst, amt, visits}})

    if visits > 0 do
      GenServer.cast(self(), :done)
      {:noreply, state |> Map.put(:abort, true)}
    else
      GenServer.cast(self(), {inst, amt, visits})
      {:noreply, state}
    end
  end

  def handle_cast(:step, state) do
    GenServer.cast(self(), :done)
    {:noreply, state}
  end

  # Client Functions
  def run(pid) do
    GenServer.cast(pid, :step)
    pid
  end

  def await_completion(pid) do
    {:ok, accumulator} = GenServer.call(pid, :await_completion, 60000)
    accumulator
  end

  def get_trace(pid) do
    {:ok, trace} = GenServer.call(pid, :retrieve_trace)
    trace
  end

  def get_abort(pid) do
    {:ok, abort} = GenServer.call(pid, :retrieve_abort)
    abort
  end

  # Utility Functions
  def parse_program(filename) do
    File.stream!(filename)
    |> Stream.map(fn line ->
      [op, val] = String.split(line)
      {op, String.to_integer(val), 0}
    end)
    |> Enum.to_list()
  end

  def inc(state, amt) do
    state |> Map.put(:accumulator, state[:accumulator] + amt)
  end

  def advance(state, step \\ 1) do
    state |> Map.put(:pc, state[:pc] + step)
  end

  def trace(%{:program => program, :pc => pc} = state) do
    {inst, amt, visits} = Enum.at(program, pc)

    state
    |> Map.put(:program, List.replace_at(program, pc, {inst, amt, visits + 1}))
    |> Map.put(:trace, [{pc, {inst, amt, visits}} | state[:trace]])
  end
end
