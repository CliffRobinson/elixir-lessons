defmodule Coolest do
  def coolest do
      name = IO.gets("What's your name?")

      IO.puts("#{name} is your name \nCliff is the coolest")
  end
end

Coolest.coolest()
