defmodule Stack do
  use GenServer

  @doc """
  This function starts up the GenServer.  Internally it calls
  `spawn` and returns `{:ok, pid}`.
  """
  @spec start_link([keyword()]) :: {:ok, pid()}
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  #
  # Client API
  # Other functions call these functions to interact with the GenServer.
  #

  @spec push(pid(), any()) :: :ok
  def push(pid, value) do
    GenServer.call(pid, {:push, value})
  end

  @spec pop(pid()) :: any()
  def pop(pid) do
    GenServer.call(pid, :pop)
  end

  #
  # Server implementation
  # GenServer calls these in the server's process
  #

  # init lets you change the initial state, which is set in
  # the start_link call above, and for this example is []
  #
  # It's only called once, immediately after the GenServer is started.
  def init(list) do
    {:ok, list}
  end

  # handle_call is called by GenServer.  The first argument is
  # whatever was passed in the GenServer.call function call,
  # the second is which process sent it (we don't need that),
  # and the third is the state of the GenServer.  Our state
  # starts off as [].
  #
  # These function return a tuple with three elements:
  #   1. it's almost always :reply
  #   2. the value you want to send back to the process that called
  #      GenServer.call
  #   3. the new state

  def handle_call({:push, value}, _from, list) do
    {:reply, :ok, [value | list]}
  end

  def handle_call(:pop, _from, list) do
    [value | new_list] = list

    {:reply, value, new_list}
  end
end


# Example use

{:ok, pid} = Stack.start_link()

Stack.push(pid, 3)
Stack.push(pid, 4)
Stack.push(pid, 5)

Stack.pop(pid) |> IO.puts()
Stack.pop(pid) |> IO.puts()
Stack.pop(pid) |> IO.puts()
