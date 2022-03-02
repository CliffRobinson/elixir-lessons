defmodule Memory do
  alias Memory.{UI, Logic}

  def start() do
    Logic.init_state()
    |> play_loop()
  end

  def play_loop(state) do
    UI.display(state)

    UI.ask_for_numbers(state)
    |> UI.show_guess(state)
    |> Logic.guess(state)
    |> UI.display_guess_result()
    |> play_loop()
  end
end

defmodule Memory.UI do
  def display(state) do
    IO.puts("====================")

    for {index, bool, letter} <- state,
        do: if(bool, do: IO.puts("#{index}: #{letter}"), else: IO.puts("#{index}:???"))

    IO.puts("====================")
  end

  def ask_for_numbers(state) do
    IO.gets("Put in two numbers separated by a space\n")
    |> String.trim()
    |> String.split(" ")
    |> Enum.map(fn el ->
      {num, _} = Integer.parse(el)
      num
    end)
  end

  def show_guess(guesses, state) do
    for guess <- guesses do
      letter = elem(Enum.at(state, guess - 1), 2)
      IO.puts("#{guess}: #{letter}")
    end

    guesses
  end

  def display_guess_result({:success, state}) do
    IO.puts("Your guesses matched!")
    state
  end

  def display_guess_result({:fail, state}) do
    IO.puts("Your guesses didn't match :-(")
    state
  end
end

defmodule Memory.Logic do
  def init_state() do
    [
      "A",
      "A",
      "B",
      "B",
      "C",
      "C",
      "D",
      "D",
      "E",
      "E",
      "F",
      "F",
      "G",
      "G",
      "H",
      "H",
      "I",
      "I",
      "K",
      "K"
    ]
    |> Enum.shuffle()
    |> Enum.with_index(fn el, index -> {index + 1, false, el} end)
  end

  def get_letter(guess_index, state) do
    {_index, _bool, found_letter} =
      Enum.find(state, fn {index, bool, letter} ->
        index == guess_index
      end)

    found_letter
  end

  def guess([first_index, second_index], state) do
    first_letter = get_letter(first_index, state)
    second_letter = get_letter(second_index, state)
    match = first_letter == second_letter

    check_guess(match, first_index, second_index, state)
  end

  def check_guess(true, first_index, second_index, state) do
    new_state =
      Enum.map(state, fn {index, bool, letter} ->
        {index, index == first_index || index == second_index || bool, letter}
      end)
    {:success, new_state}
  end

  def check_guess(false, _first_index, _second_index, state) do
    {:fail, state}
  end
end

Memory.start()
