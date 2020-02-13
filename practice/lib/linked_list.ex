defmodule LinkedList do
  def reverse([]), do: []

  def reverse([h | t]) do
    reverse(t) ++ [h]
  end

  def reverse_tail_rec(list, result \\ [])
  def reverse_tail_rec([], result), do: result

  def reverse_tail_rec([h | t], result) do
    reverse_tail_rec(t, [h | result])
  end

  def push([], val), do: [val]

  def push([h | t], val) do
    [h | push(t, val)]
  end

  def remove_last([t]), do: []

  def remove_last([h | t]) do
    [h | remove_last(t)]
  end

  def at(list, n, counter \\ 0)
  def at([], n, counter), do: nil
  def at([h | t], n, counter) when h == n, do: counter

  def at([h | t], n, counter) do
    at(t, n, counter + 1)
  end

  def set(list, n, value, counter \\ 0)

  def set([_ | t], n, value, counter) when n == counter do
    [value | t]
  end

  def set([h | t], n, value, counter) do
    [h | set(t, n, value, counter + 1)]
  end

  def insert(list, n, value, counter \\ 0)
  def insert([], n, value, counter), do: []

  def insert([h | t], n, value, counter) when n == counter do
    [value | [h | t]]
  end

  def insert([h | t], n, value, counter) do
    [h | insert(t, n, value, counter + 1)]
  end
end
