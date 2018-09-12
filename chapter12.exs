# Rewrite the FizzBuzz example using case.
defmodule CF do
  def up_to(n) when n > 0 do
    1..n |> Enum.map(&fizzbuzz/1)
  end

  def fizzbuzz(n) do
    case { rem(n, 3), rem(n, 5) } do
      { 0, 0 } -> "FizzBuzz"
      { _, 0 } -> "Fizz"
      { 0, _ } -> "Buzz"
      _ -> n
    end
  end
end

# Write an ok! function that takes an arbitrary parameter. If the parameter is the tuple {:ok, data}, return the data. Otherwise, raise an exception containing information from the parameter.

defmodule CF do
  def ok!(file) do
    case file do
      {:ok, data} -> data
      {:error, message} -> raise "Failed to open file #{message}"
    end
  end
end

File.open("./sales.csv") |> CF.ok!() |> IO.read(:all)
