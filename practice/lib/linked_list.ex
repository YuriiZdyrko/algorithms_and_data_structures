defmodule LinkedList do
  def run do
    list = [1 | [2 | [3 | [4 | [5]]]]]
    reverse(list)
  end

  def reverse([]), do: []

  def reverse([h | t] = list) do
    reverse(t) ++ [h]
  end
end
