defmodule PhoenixMemoryWeb.PageController do
  use PhoenixMemoryWeb, :controller

  def index(conn, params) do
   %{:board => board, :guesses => guesses} = PhoenixMemory.MemoryServer.get_state()

    # message = "initial defaul"

    IO.inspect(board)

    message = if(Map.get(params, "message"), do: Map.get(params, "message"), else: "Make your first guess!")

    conn
    |> assign(:message, message)
    |> assign(:guesses, guesses)
    |> assign(:board, Enum.chunk_every(board,5))
    |> render("index.html")
  end

  @spec post_guess(Plug.Conn.t(), map) :: Plug.Conn.t()
  def post_guess(conn, arg) do
    {guess_result, {first_index, first_letter, second_index, second_letter}} = PhoenixMemory.MemoryServer.post_guess(arg)

    message = cond do
      guess_result == :victory ->
        "You win! #{first_index} is #{first_letter} and #{second_index} is #{second_letter}"
      guess_result == :success ->
        "Congratulations, they matched! #{first_index} is #{first_letter} and #{second_index} is #{second_letter}"
        guess_result == :fail ->
          "Sorry, no match! #{first_index} is #{first_letter} and #{second_index} is #{second_letter}"
    end

    redirect(conn, to: "/?message=#{message}")
  end
end
