defmodule Dijkstra.PriorityQueue do
  def test_pq() do
    new()
    |> enqueue(%{node: "A", distance: 0})
    |> enqueue(%{node: "B", distance: 10})
    |> enqueue(%{node: "C", distance: 1000})
    |> enqueue(%{node: "D", distance: 50})
    |> enqueue(%{node: "E", dsistance: 20})
    |> dequeue()
  end

  def new() do
    []
  end

  def enqueue(p_queue, new_item = %{name: _, dist: _, prev: _}) do
    [new_item | p_queue]
    |> sort
  end

  def dequeue([h | t] = p_queue) do
    {h, t}
  end

  defp sort(p_queue) do
    p_queue |> Enum.sort_by(fn %{dist: d} -> d end)
  end
end
