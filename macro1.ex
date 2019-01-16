defmodule Exp do
  defmacro explain(expression) do
    exp = quote do
       unquote(expression)
    end
    process exp
  end
  # 1+2*3   {:+, [line: 36], [1, {:*, [line: 36], [2, 3]}]}
  # 2-3*2   {:-, [line: 57], [2, {:*, [line: 57], [3, 2]}]}
  # 5*2-4/3 {:-, [line: 58], [{:*, [line: 58], [5, 2]}, {:/, [line: 58], [4, 3]}]}
  #
  # sign, _, [tuple, tuple]
  # sign, _, [tuple, number]
  # sign, _, [number, tuple]
  # sign, _, [number, number]

  def process(exp) do
    # IO.inspect exp

    parse(exp)
  end

  def parse(exp) do

    Macro.postwalk(exp, [], fn
      {sign, _, [left, right]} = q, acc ->
        {exp, acc ++ ["#{translate_sign(sign)}"]}

        # {sign, acc}
      # {:*, _, [left, right]}, acc ->
      #   IO.inspect left
      #   {:ok, acc}
      # {sign, _, [left, right]} = q, acc when is_tuple(left) and is_tuple(right) ->
      #   # {sign, _, [left, right]} = x
      #   IO.inspect q
      #   IO.inspect left
      #   IO.inspect right
      #   {sign, acc}

      _, acc ->
        {exp, acc}

    end)
    |> elem(1)
    |> IO.inspect
  end

  def build_line({sign, _, [left, right]}) when is_tuple(left) do
    "#{translate_sign(sign)} #{build_line(left)} #{right}"
  end
  def build_line({sign, _, [left, right]}) when is_tuple(right) do
    "#{translate_sign(sign)} #{build_line(right)} #{left}"
  end


  # def translate_expression({sign,_, [left, right]}) do
  #   "#{translate_sign(sign)} #{left} by #{right}"
  # end

  def translate_sign(sign) do
    case sign do
      :+ -> "add"
      :- -> "subtract"
      :* -> "multipy"
      :/ -> "divide"
    end
  end
end

defmodule Test do
  require Exp
  Exp.explain(2*3/6+(7+7)+3)
end

# {:+, [line: 36], [1, {:*, [line: 36], [2, 3]}]}

# {:+, [line: 36], [1, {:*, [line: 36], [2, 3]}]}
#
# {:+, [line: 36], [1, "multipy 2 by 3, then"]}
#
# [1, {:*, [line: 36], [2, 3]}]
#
# {:*, [line: 36], [2, 3]}

#
# # Write a macro called myunless that implements the standard unless functionality.
# # You’re allowed to use the regular if expression in it.
# defmodule Mu do
#   defmacro myunless(condition, blocks) do
#     do_block = Keyword.get(blocks, :do, nil)
#
#     quote do
#       if !unquote(condition) do
#         unquote(do_block)
#       end
#     end
#   end
# end
#
# defmodule Test do
#   require Mu
#
#   def t do
#     Mu.myunless 1 > 2 do
#       IO.puts "1 is less than 2"
#     end
#   end
# end
#
# # Write a macro called times_n that takes a single numeric argument.
# # It should define a function called times_n in the caller’s module that itself takes a single argument,
# # and that multiplies that argument by n. So, calling times_n(3) should create a function called times_3,
# # and calling times_3(4) should return 12.
#
# defmodule Times do
#   defmacro times_n(num) do
#     quote do
#       def unquote(:"times_#{num}")(args) do
#         unquote(num) * args
#       end
#     end
#   end
# end
#
# defmodule Test do
#   require Times
#   Times.times_n(3)
#   Times.times_n(4)
# end
#
# IO.puts Test.times_3(4) #12
# IO.puts Test.times_4(5) #20
