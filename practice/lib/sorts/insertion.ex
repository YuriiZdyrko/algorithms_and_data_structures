defmodule Sorts.Insertion do
  @moduledoc """
  List iterated, and left part is always sorted.
  Tail-recursion for ordering left part
  """

  def run do
    list = [3, 5, 10, 1, 55, 20, 100, 2]
    sort(list)
  end

  def sort(list, result \\ [])
  def sort([], result), do: result

  def sort([h | t] = list, result) do
    sort(t, calc_front(result, h))
  end

  def calc_front(sorted_part, value, result \\ [])

  def calc_front([], value, result) do
    (result ++ [value])
    |> IO.inspect(charlists: false)
  end

  def calc_front([h | t] = sorted_part, value, result) do
    IO.inspect("inner loop: #{inspect(sorted_part, charlists: false)} vs #{value}")

    if value < h do
      (result ++ [value] ++ sorted_part)
      |> IO.inspect(charlists: false)
    else
      calc_front(t, value, result ++ [h])
    end
  end
end

defmodule Sorts.Insertion2 do
  @moduledoc """
  Recursive ordering of left part
  """
  def sort(list) when is_list(list) do
    do_sort([], list)
  end

  def do_sort(_sorted_list = [], _unsorted_list = [head | tail]) do
    do_sort([head], tail)
  end

  def do_sort(sorted_list, _unsorted_list = [head | tail]) do
    insert(head, sorted_list) |> do_sort(tail)
  end

  def do_sort(sorted_list, _unsorted_list = []) do
    sorted_list
  end

  def insert(elem, _sorted_list = []) do
    [elem]
  end

  def insert(elem, sorted_list) do
    [min | rest] = sorted_list

    if min >= elem do
      [elem | [min | rest]]
    else
      [min | insert(elem, rest)]
    end
  end
end
