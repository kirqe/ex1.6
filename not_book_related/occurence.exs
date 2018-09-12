defmodule Q do
  def short_way(str) do
    str
    |> String.graphemes
    |> Enum.chunk_by(&(&1))
    |> Enum.max_by(&length/1)
    |> List.first
  end

  def find(str) when is_binary(str),
    do: find(String.graphemes(str), nil, 1, 1)

  def find([], l, _counter, _max), do: l

  def find([h|t], l, counter, max)
    when h == l,
    do: find(t, h, counter + 1, max)

  def find([h|t], l, counter, max)
    when h != l and counter >= max,
    do: find(t, h, 1, counter)

  def find([h|t], l, counter, max)
    when h != l and counter <= max,
    do: find(t, h, 1, max)
end

IO.inspect Q.find("aaccccccddddcc")
IO.inspect Q.short_way("aaccccccddddcc")

#=> "c"
#=> "c"
