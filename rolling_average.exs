defmodule Rolling_average do
  use GenServer

  @spec start_link([keyword()]) :: {:ok, pid()}
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init(list) do
    {:ok, list}
  end

  def add_and_roll(pid, value) do #where value is number etc
    GenServer.call(pid, {:add_and_roll, value})
  end

  def handle_call({:add_and_roll, value}, _from, list) do
    new_list = [value | list]

    {:reply, get_rolling_average(new_list, 10), new_list}
  end

  def get_rolling_average(list, roll_num, total \\ 0, index \\ 0) do
    if (list == [] || index == roll_num) do
      total/index
    else
      [current | rest] = list
      get_rolling_average(rest, roll_num, total + current, index + 1)
    end
  end


end

{:ok, pid} = Rolling_average.start_link()

Rolling_average.add_and_roll(pid, 10) |> IO.puts()
Rolling_average.add_and_roll(pid, 15) |> IO.puts()
Rolling_average.add_and_roll(pid, 5) |> IO.puts()
Rolling_average.add_and_roll(pid, 5) |> IO.puts()
