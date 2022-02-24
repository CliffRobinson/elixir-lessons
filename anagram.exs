defmodule Anagrams do

  def get_word do
    IO.gets("What is your word? ")
    |> String.trim()
  end

  def play do
    {:ok, my_big_string} = File.read("/usr/share/dict/words")

    # IO.inspect(my_big_string)

    some_words_list = String.split(my_big_string)

    Enum.member?(some_words_list,get_word())
    |> if(do: "It's there!", else: "it's not there")
    |> IO.puts()
  end



end

Anagrams.play()
