defmodule Guesser do
  def start do
    IO.puts("Guess a number between 1 and 100 ")

    answer = :rand.uniform(100) + 1

    ask_new_guess(0, answer)
  end

  def handle_response(_guess, 7, answer) do
    IO.puts("Sorry, you're out of guesses, the answer was #{answer}")
  end

  def handle_response(guess, _guess_count, answer) when guess == answer do
    IO.puts("You win!!")
  end

  def handle_response(guess, guess_count, answer) when guess < answer do
      IO.puts("The answer is HIGHER! than #{guess}")

      ask_new_guess(guess_count, answer)
  end

  def handle_response(guess, guess_count, answer) do
    IO.puts("The answer is LOWER! than #{guess}")

    ask_new_guess(guess_count, answer)
  end

  def ask_new_guess(guess_count, answer) do
    IO.gets("What is your guess number #{guess_count}?")
    |> String.trim()
    |> Integer.parse()
    |> elem(0)
    |> handle_response(guess_count+1, answer)
  end
end

Guesser.start()
