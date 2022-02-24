defmodule Wordle do
  def play do
    select_answer()
    |> make_guess(6)
  end

  def select_answer do
    {:ok, my_big_string} = File.read("./wordle_list.txt")

    String.split(my_big_string)
    |> Enum.random()
    |> IO.inspect()
  end

  def make_guess(answer, 0) do
    IO.puts("Sorry, it was #{answer}")
  end

  def make_guess(answer, remaining_guesses) do
    IO.puts("#{remaining_guesses} left!")
    input_guess()
    |> compare(answer, remaining_guesses)
  end

  def input_guess do
    {:ok, my_big_string} = File.read("/usr/share/dict/words")

    master_word_list =
      String.split(my_big_string)
      |> Enum.filter(fn word -> String.length(word) == 5 end)

    guess =
      IO.gets("What is your guess? ")
      |> String.trim()

    if Enum.member?(master_word_list, guess) do
      # IO.puts("\nA good guess")
      guess
    else
      IO.puts("NOT A WOOOORD")
      input_guess()
    end
  end

  def compare(guess, answer, _remaining_guesses) when guess == answer do
    IO.puts("You win!")
  end

  def compare(guess, answer, remaining_guesses) do
    Enum.zip(String.graphemes(guess), String.graphemes(answer))
    |> Enum.map(fn {guess_letter, answer_letter} ->
      # take a trip to conde naste
      if guess_letter == answer_letter do
        "#"
      else
        if String.contains?(answer, guess_letter) do
          "!"
        else
          "_"
        end
      end
    end)
    |> Enum.join("")
    |> then(fn hint -> IO.puts("#{hint}\n#{guess}\n#{hint}") end)

    make_guess(answer, remaining_guesses-1)
  end
end

Wordle.play()
