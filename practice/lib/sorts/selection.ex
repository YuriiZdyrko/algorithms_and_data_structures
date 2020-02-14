defmodule Sorts.Selection do
  @moduledoc """
  On each iteration find smallest item in right (unsorted) part
  """

  def run do
    list = [3, 5, 10, 1, 55, 20, 100, 2]
    sort(list)
  end

  def sort([]), do: []

  def sort([h | t] = list) do
    {min, rest} = min_and_rest(t, h)
    [min | sort(rest)]
  end

  def min_and_rest(list, min, rest \\ [])
  def min_and_rest([], min, rest), do: {min, rest}

  def min_and_rest([h | t] = list, min, rest) do
    if h < min,
      do: min_and_rest(t, h, [min | rest]),
      else: min_and_rest(t, min, [h | rest])
  end
end
