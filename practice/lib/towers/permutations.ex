defmodule Towers.Permutations do
  @moduledoc """
  Exercise in recursion

  Generates all possible ordered combinations from sub-arrays:
  [[1,2], [3,4]] => [[1,3],[1,4],[2,3],[2,4]]
  """

  def do_tail_recursive(list, result \\ [])

  def do_tail_recursive([], result), do: result

  def do_tail_recursive([h | tail], []) do
    do_tail_recursive(tail, Enum.map(h, &[&1]))
  end

  def do_tail_recursive([h | tail], result) do
    result =
      List.duplicate(result, length(h))
      |> Enum.zip(h)
      |> Enum.flat_map(fn {dup_item, h_item} ->
        dup_item
        |> Enum.map(&(&1 ++ [h_item]))
      end)

    do_tail_recursive(tail, result)
  end

  def do_recursive([]), do: []

  def do_recursive([h]) do
    h |> Enum.map(&[&1])
  end

  def do_recursive([h | t] = list) do
    next = do_recursive(t)

    h
    |> List.duplicate(length(next))
    |> Enum.zip(next)
    |> Enum.flat_map(fn {dup_item, h_item} ->
      dup_item
      |> Enum.map(&[&1 | h_item])
    end)
  end

  def do_reduce([h | t] = list) do
    list
    |> Enum.with_index()
    |> Enum.reduce(
      Enum.map(h, &[&1]),
      fn {item, index}, result ->
        with {:ok, next_item} <- Enum.fetch(list, index + 1) do
          result
          |> List.duplicate(length(next_item))
          |> Enum.zip(next_item)
          |> Enum.flat_map(fn {dup_item, h_item} ->
            dup_item
            |> Enum.map(&(&1 ++ [h_item]))
          end)
        else
          _ -> result
        end
      end
    )
  end
end
