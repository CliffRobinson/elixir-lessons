defmodule RPN do
  def calc(string) when is_binary(string) do
    String.split(string)
    |> Enum.map(fn el ->
      case Integer.parse(el) do
        {num, _} -> num
        :error -> el
      end
    end)
    |> Enum.reverse()
    |> calc()
  end

  # solution case
  def calc([first | _rest]) when is_number(first) do
    first
  end

  # first is always an operation in this case
  def calc([first | [second | rest]]) when is_number(second) do
    operate(first, second, calc(rest))
  end

  # first and second are operations
  def calc([operation | rest]) do
      {middle, [last]} = Enum.split(rest, length(rest) -1)
      operate(operation, calc(middle), last)
  end

  def operate(operation, a, b) do
    case operation do
      "+" ->
        b + a
      "-" ->
        b - a
      "*" ->
        b * a
      "/" ->
        b / a
      true ->
        IO.puts("something is wrong,op is #{operation} a is #{a}, b is #{b}")
    end
  end
end

test1 = RPN.calc("-17")
IO.puts("test1 is #{test1 == -17}")

test1a = RPN.calc([-17])
IO.puts("test1a is #{test1a  == -17}")

test2 = RPN.calc("3 20 -")
IO.puts("test2 is #{test2  == -17}")

test2a = RPN.calc(["-", 20, 3])
IO.puts("test2a is #{test2a  == -17}")

test3 = RPN.calc("3 4 5 * -")
IO.puts("test3 is #{test3  == -17}")

test4 = RPN.calc("2 3 + 4 *")
IO.puts("test4 is #{test4  == 20}")
