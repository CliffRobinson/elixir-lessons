defmodule TTT.Client do
  def start(server_pid, port) do
    IO.puts("Client starting!")
    {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    loop_acceptor(server_pid, socket)
  end

  def loop_acceptor(server_pid, socket) do
    # IO.inspect("Client loooping, server_pid:")
    # IO.inspect(server_pid)
    # IO.inspect("Socket:")
    # IO.inspect(socket)
    {:ok, client} = :gen_tcp.accept(socket)
    # IO.puts("gen_tcp OK!!")
    spawn(fn -> register(server_pid, client) end)
    loop_acceptor(server_pid, socket)
  end

  def register(server_pid, socket) do
    IO.puts("Client Registering!")
    send(server_pid, {self(), :register})

    puts("Waiting for other player...", socket)

    receive do
      {:your_turn, board} -> play(server_pid, board, socket)
      {:error, :game_full} -> puts("Game is full :(", socket)
    end

    :gen_tcp.close(socket)
  end

  defp play(server_pid, board, socket) do
    print_board(board, socket)

    position = ask_for_position(socket)
    send(server_pid, {self(), {:play, position - 1}})

    receive do
      {:error, error} ->
        print_error(error, socket)
        play(server_pid, board, socket)

      {:accepted, board} ->
        print_board(board, socket)

        puts("Waiting for other player...", socket)

        receive do
          {:your_turn, board} ->
            play(server_pid, board, socket)

          {:game_complete, board} ->
            print_board(board, socket)
            puts("Game complete!", socket)
        end
    end
  end

  defp ask_for_position(socket) do
    gets("Play at position (1-9): ", socket)
    |> String.trim()
    |> Integer.parse()
    |> case do
      {number, ""} -> number
      _ ->
        puts("Not a valid number", socket)
        ask_for_position(socket)
    end
  end

  defp print_error(error, socket) do
    case error do
      :not_your_turn -> "Weird, it wasn't my turn."
      :invalid_position -> "That's not a valid position."
      :cell_not_empty -> "That cell is not empty."
      error -> "Error '#{error}' occurred."
    end
    |> puts(socket)
  end

  defp print_board(board, socket) do
    board
    |> Enum.map(fn
      nil -> " "
      0 -> "X"
      1 -> "O"
    end)
    |> Enum.chunk_every(3)
    |> Enum.map(&Enum.join(&1, " | "))
    |> Enum.intersperse("---------")
    |> Enum.join("\n")
    |> then(&"\n#{&1}\n")
    |> puts(socket)
  end

  defp gets(prompt, socket) do
    print(prompt, socket)
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp puts(line, socket) do
    print("#{line}\n", socket)
  end

  defp print(line, socket) do
    :gen_tcp.send(socket, line)
  end
end

defmodule TTT.Server do
  def start do
    # TODO: switch case/cond for different atoms recieved from client
    # function for each:
    # receive: :register => :your_turn, :error
    IO.puts("SERVER STARTING!!!!")
    initial_state = [nil, nil, nil,nil, nil, nil,nil, nil, nil,]

    spawn(fn -> looper(initial_state) end)
  end

  def looper(board, a \\ nil, b \\ nil ) do
    IO.puts("Server Looping!")
    receive do
      {client_pid, :register } ->
        IO.puts("received a register atom!!, client_pid is:")
        IO.inspect(client_pid)
        cond do
          a == nil ->
            IO.puts("first player registered!")
            looper(board, client_pid, nil)

          a != nil && b == nil ->
            IO.puts("second player registered!")
            #send_play
            send(a, {:your_turn, board})
            looper(board, a, client_pid)

          true ->
            IO.puts("Game oversubscribed :-(")
            send(client_pid, {:error, :game_full})
            looper(board, a, b)
          end
      {player, {:play, play_num}} ->
        #check if position has been played to
        if (Enum.at(board, play_num) != nil) do
          #if it has, return :error and ask for input again
          send(player, {:error, :invalid_position})
          looper(board, a, b)
        else
          #if it hasn't, call looper with an updated board, MAYBE instruct client that it's the next player's turn



          symbol = if player == a, do: 1, else: 0
          next_player = if player == a, do: b, else: a

          new_board = List.replace_at(board, play_num, symbol)
          send(player, {:accepted, new_board})
          send(next_player, {:your_turn, new_board})
          looper(new_board, a, b)
        end
    end
  end
end

server_pid = TTT.Server.start()
TTT.Client.start(server_pid, 6000)
