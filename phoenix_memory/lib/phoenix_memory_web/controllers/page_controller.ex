defmodule PhoenixMemoryWeb.PageController do
  use PhoenixMemoryWeb, :controller

  def index(conn, _params) do
    done_thing = PhoenixMemory.MemoryServer.do_a_thing()

    %{:board => board, :guesses => guesses} = PhoenixMemory.MemoryServer.get_state()

    conn
    |> assign(:guesses, guesses)
    |> assign(:board, board)
    |> assign(:done_thing, done_thing)
    |> render("index.html")
  end

  def post_thing(conn, %{ "thing" => thing }) do
    PhoenixMemory.MemoryServer.get_a_thing(thing)
    redirect(conn, to: "/")
  end
end
