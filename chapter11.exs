# Write a function that returns true if a single-quoted string contains only printable ASCII characters (space through tilde).
defmodule SAB do
  def has_only_printable?([h|t]) when h > 31 and h < 172, do: has_only_printable?(t)
  def has_only_printable?([h|_t]) when h <= 31, do: false
  def has_only_printable?([]), do: true
end

# Write an anagram?(word1, word2) that returns true if its parameters are anagrams.
defmodule SAB do
  def anagram?(word1, word2) do
    word1 == Enum.reverse(word2) or word2 == Enum.reverse(word1)
  end
end

# (Hard) Write a function that takes a single-quoted string of the form number [+-*/] number and returns the result of the calculation. The individual numbers do not have leading plus or minus signs.
# calculate(’123 + 27’) # => 150”
defmodule SAB do
  def calculate(str) do
    _digits(str, [], []) |> result
  end

  def result([a, sign, b]) do
    case sign do
      "+" -> a + b
      "-" -> a - b
      "*" -> a * b
      "/" -> if b != 0, do: a / b, else: 0
      _ -> "#{sign} not supported"
    end
  end

  def _digits([h | t], res, acc) when h == 32, do: _digits(t, res, acc)
  def _digits([h | t], res, acc) when h in '+-*/' do
    {val, sign} = acc ++ [h] |> List.to_string |> Integer.parse
    _digits(t, res ++ [val] ++ [sign], [])
  end
  def _digits([h | t], res, acc) when h in '0123456789' do
    _digits(t, res, acc ++ [h])
  end
  def _digits([], res, acc) do
    {val, _sign} = acc |> List.to_string |> Integer.parse
    res ++ [val]
  end
end

IO.puts SAB.calculate('123 + 10')

# Write a function that takes a list of double-quoted strings and prints each on a separate line, centered in a column that has the width of the longest string. Make sure it works with UTF characters.
defmodule SAB do
  def center(words) do
    with longest_length = longest(words) do
      Enum.each(words, fn(word) ->
        add_padding(word, longest_length) |> IO.puts
      end)
    end
  end

  defp longest(words), do: words |> Enum.max_by(&String.length/1) |> String.length
  defp add_padding(current, longest_length) do
    with current_length = String.length(current),
         length_difference = longest_length - current_length,
         pad = current_length + div(length_difference, 2)
    do
      if current_length == longest_length,
      do: current,
      else: String.pad_leading(current, pad , " ")
    end
  end
end

SAB.center(["cat", "zebra", "elephant"])

# Write a function to capitalize the sentences in a string. Each sentence is terminated by a period and a space. Right now, the case of the characters in the string is random.
defmodule SAB do
  def capitalize_sentences(str) do
    str
    |> String.split(". ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(". ")
  end
end

# Write a function that reads and parses this file and then passes the result to the sales_tax function. Remember that the data should be formatted into a keyword list, and that the fields need to be the correct types (so the id field is an integer, and so on).
defmodule Tax do
  def calculate(rates, orders) do
    for [_, {_, os}, {_, na}] = o <- orders, do:
      o ++ [{:total_amount, (if is_nil(rates[os]),
        do: na, else: na + na * rates[os])}]
  end
end

defmodule SAB do
  def orders do
    open_file()
    |> Enum.drop(1)
    |> Enum.map(&parse/1)
  end

  defp parse(line) do
    line
    |> String.split(", ")
    |> parse_line
  end

  defp parse_line([id, state, cost]) do
    [
      id: String.to_integer(id),
      ship_to: String.to_atom(String.replace(state, ":", "")),
      net_amount: String.to_float(String.trim(cost))
    ]
  end

  defp open_file do
    {:ok, file} = File.open("./sales.csv")
    IO.stream(file, :line)
  end
end

tax_rates = [ NC: 0.075, TX: 0.08 ]
IO.inspect Tax.calculate(tax_rates, SAB.orders)
