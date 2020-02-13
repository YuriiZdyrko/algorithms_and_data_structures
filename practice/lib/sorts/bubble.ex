defmodule Sorts.Bubble do
  @moduledoc """
  Run sort multiple times, until list is not changing.
  On each step of iterations, swap two adjacent elements.
  """

  def run do
    list = [3, 5, 10, 1, 55, 20, 100, 2]
    sort(list)
  end

  def sort(list, result \\ [], changed? \\ false)
  def sort([last], result, true), do: sort(result ++ [last])
  def sort([last], result, false), do: result ++ [last]

  def sort([h | [hh | t]] = list, result, changed?) do
    if h > hh do
      sort([h | t], result ++ [hh], true)
    else
      sort([hh | t], result ++ [h], changed?)
    end
  end
end
