# Implement the following Enum functions using no library functions or list comprehensions: all?, each, filter, split, and take. You may need to use an if statement to implement filter.

defmodule MyEnum do
  def all?([], _), do: []
  def all?([h|t], condition) do
    if condition.(h) and all?(t, condition), do: true, else: false
  end

  def each([], _), do: :ok
  def each([h|t], func) do
    func.(h)
    each(t, func)
  end

  def filter([], _), do: []
  def filter([h|t], condition) do
    if condition.(h), do:
    [h | filter(t, condition)], else: filter(t, condition)
  end

  def take(_, n) when n == 0, do: []
  def take([h|t], n) do
    [h | take(t, n-1)]
  end
end

# (Hard) Write a flatten(list) function that takes a list that may contain any number of sublists, which themselves may contain sublists, to any depth. It returns the elements of these lists as a flat list.

# took quite a while with lots of experiments :O
defmodule MyList do
  def flatten([]), do: []
  def flatten([h|t]) when length(h) >= 1, do: flatten(h) ++ flatten(t)
  def flatten([h|t]), do: [h] ++ flatten(t)
end

IO.inspect MyList.flatten([1,[2,3,[4]],5,[[[6]]]])
#=> [1, 2, 3, 4, 5, 6]

# In the last exercise of Chapter 7, ​Lists and Recursion​, you wrote a span function. Use it and list comprehensions to return a list of the prime numbers from 2 to n.

# had to look this up since it wasn't obvious if I can use stuff like Enum.all? :)
defmodule MyList do
  def span(from, to) when from > to, do: []
  def span(from, to), do: [from | span(from + 1, to)]
end

defmodule Primes do
  def list_primes_till(n) do
    for x <- MyList.span(2, n), Enum.all?(MyList.span(2, x - 1), fn(q) -> rem(x, q) != 0 end), do: x
  end
end

# Write a function that takes both lists and returns a copy of the orders, but with an extra field, total_amount, which is the net plus sales tax. If a shipment is not to NC or TX, there’s no tax applied.

# Some people use Enum and Keyword module functions for this task but it's not fair since the chapter is about recursion and comprehensions
#
# Pure comprehensions :D
defmodule Tax do
  def calculate(rates, orders) do
    for [_, {_, os}, {_, na}] = o <- orders, do:
      o ++ [{:total_amount, (if is_nil(rates[os]),
        do: na, else: na + na * rates[os])}]
  end
end

tax_rates = [ NC: 0.075, TX: 0.08 ]
orders = [
  [ id: 123, ship_to: :NC, net_amount: 100.00 ],
  [ id: 124, ship_to: :OK, net_amount:  35.50 ],
  [ id: 125, ship_to: :TX, net_amount:  24.00 ],
  [ id: 126, ship_to: :TX, net_amount:  44.80 ],
  [ id: 127, ship_to: :NC, net_amount:  25.00 ],
  [ id: 128, ship_to: :MA, net_amount:  10.00 ],
  [ id: 129, ship_to: :CA, net_amount: 102.00 ],
  [ id: 130, ship_to: :NC, net_amount:  50.00 ]]

IO.inspect Tax.calculate(tax_rates, orders)
