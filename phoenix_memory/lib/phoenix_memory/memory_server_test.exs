defmodule Module do
  def game_won?(board) do
    Enum.reduce(board, true, fn ({_index, bool, _letter}, result) ->
      if bool, do: result, else: false
    end )
  end
end

simple_loss = [
  {1, false, "A"}
]

simple_win = [
  {1, true, "A"}
]

complex_win = [
  {1, true, "B"},
  {2, true, "F"},
  {3, true, "I"},
  {4, true, "F"},
  {5, true, "D"},
  {6, true, "J"},
  {7, true, "A"},
  {8, true, "D"},
  {9, true, "A"},
  {10, true, "J"},
  {11, true, "I"},
  {12, true, "E"},
  {13, true, "H"},
  {14, true, "C"},
  {15, true, "B"},
  {16, true, "G"},
  {17, true, "H"},
  {18, true, "G"},
  {19, true, "E"},
  {20, true, "C"}
]

complex_loss = [ {21, false, "Q"} | complex_win] |> Enum.shuffle()


test1 = Module.game_won?(simple_loss)
IO.puts("Test1 is #{test1 == false}")

test2 = Module.game_won?(simple_win)
IO.puts("Test2 is #{test2 == true}")

test3 = Module.game_won?(complex_loss)
IO.puts("Test3 is #{test3 == false}")

test4 = Module.game_won?(complex_win)
IO.puts("Test4 is #{test4 == true}")
