defmodule PhoenixMemoryWeb.PageController do
  use PhoenixMemoryWeb, :controller

  def index(conn, _params) do
   %{:board => board, :guesses => guesses} = PhoenixMemory.MemoryServer.get_state()

    conn
    |> assign(:guesses, guesses)
    |> assign(:board, Enum.chunk_every(board,5))
    |> render("index.html")
  end

  # def post_thing(conn, %{ "thing" => thing }) do
  #   PhoenixMemory.MemoryServer.get_a_thing(thing)
  #   redirect(conn, to: "/")
  # end

  def post_guess(conn, arg) do
    PhoenixMemory.MemoryServer.post_guess(arg)

    redirect(conn, to: "/")
  end
end
