defmodule PhoenixMemory.MemoryServer do
  use GenServer

  def start_link(arg_opts \\ []) do
    initialState = init_state()
    opts = Keyword.merge(arg_opts, name: __MODULE__)
    IO.puts("This is the memory server, it am starts!")
    # Is this how we do options? Seems inelegant
    GenServer.start_link(__MODULE__, initialState, opts)
  end

  def init(state) do
    {:ok, state}
  end

  def get_state() do
    GenServer.call(__MODULE__, {:get_state})
  end

  def post_guess(%{"guessA" => guessA, "guessB" => guessB}) do
    GenServer.call(__MODULE__, {:post_guess, guessA, guessB})
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:post_guess, stringGuessA, stringGuessB}, _from, state) do
    %{:board => board} = state
    {guessA, _} = Integer.parse(stringGuessA)
    {guessB, _} = Integer.parse(stringGuessB)

    first_letter = get_letter(guessA, board)
    second_letter = get_letter(guessB, board)
    match = first_letter == second_letter

    check_guess(match, guessA, guessB, state)
  end

  defp get_letter(guess_index, state) do
    IO.inspect("guess index is:")
    IO.inspect(guess_index)
    {_index, _bool, found_letter} =
      Enum.find(state, fn {index, _bool, _letter} ->
        index == guess_index
      end)

    found_letter
  end

  def check_guess(true, first_index, second_index, %{:board => board, :guesses => guesses}) do
    new_board =
      Enum.map(board, fn {index, bool, letter} ->
        {index, index == first_index || index == second_index || bool, letter}
      end)

    new_state = %{:board => new_board, :guesses => (guesses - 1) }
    {:reply, :fail, new_state}
  end

  def check_guess(false, _first_index, _second_index, %{:board => board, :guesses => guesses}) do

    new_state = %{:board => board, :guesses => (guesses - 1) }

    {:reply,:success, new_state}
  end

  defp init_state() do
    board = [
      "A","A","B","B","C","C","D","D","E","E","F","F","G","G","H","H","I","I","J","J"
    ]
    |> Enum.shuffle()
    |> Enum.with_index(fn el, index -> {index + 1, false, el} end)

    %{:guesses => 30, :board => board}
  end
end
