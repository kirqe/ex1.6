# Write a mapsum function that takes a list and a function. It applies the function to each element of the list and then sums the result.

defmodule MyList do
  def mapsum([], _), do: 0
  def mapsum([h | t], func) do
    func.(h) + mapsum(t, func)
  end
end

IO.puts MyList.mapsum([1,2,3], &(&1 * &1)) #=> 14

# Write a max(list) that returns the element with the maximum value in the list.
defmodule Ml do
  def max([a]), do: a
  def max([a, b]), do: (if a > b or a == b, do: a, else: b)
  def max([a | b]), do: (if a > max(b), do: a, else: max(b))
end

IO.puts Ml.max([10,15,44,55])

# max 10, 5, 44, 3
# 10 > max 5, 44, 3
#    5 > max 44, 3
#      max 44

# An Elixir single-quoted string is actually a list of individual character codes. Write a caesar(list, n) function that adds n to each list element, wrapping if the addition results in a character greater than z.
# Had to look this up
defmodule C do
  def caesar([], _), do: []
  def caesar([h|t], n) when (h + n) > 122, do: [(h + n)-26 | caesar(t, n)]
  def caesar([h|t], n), do:  [h + n | caesar(t, n)]
end

IO.puts C.caesar('ryvkve', 13)

# build a list having from and to values usign recursion
defmodule MyList do
  def span(from, to) when from > to, do: []
  def span(from, to), do: [from | span(from + 1, to)]
end

IO.inspect MyList.span(4, 10)
