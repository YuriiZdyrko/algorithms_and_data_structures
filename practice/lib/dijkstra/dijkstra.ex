defmodule Dijkstra do
  alias Dijkstra.{WeightedGraph, PriorityQueue}

  @moduledoc """
        A   
     1/   \2

     B     C  
    3|     4|
        1
     D  -  E
     6\  1/ \9
         
        F  3-  G
  """

  def init_graph do
    WeightedGraph.new()
    |> WeightedGraph.add_vertexes(~w(a b c d e f g)a)
    |> WeightedGraph.add_edges([
      {:a, :b, 1},
      {:a, :c, 2},
      {:b, :d, 3},
      {:c, :e, 4},
      {:d, :e, 1},
      {:d, :f, 6},
      {:e, :f, 1},
      {:e, :g, 9},
      {:f, :g, 3}
    ])
  end

  @doc """
  Keep track of minimum distance to & prev node for each node:
  %{
    a: %{0, nil},
    b: %{Infinity, nil},
    c: %{Infinity, nil}
    ...
  }
  """
  def init_min_distances(graph) do
    graph
    |> Enum.reduce(
      %{},
      fn {node, _edges}, acc ->
        put_in(acc, [node], {:infinity, nil})
      end
    )
  end

  def run(initial_node \\ :a) do
    graph = init_graph()
    min_distances = init_min_distances(graph)

    pq =
      PriorityQueue.enqueue(
        PriorityQueue.new(),
        %{dist: 0, name: initial_node, prev: nil}
      )

    loop(graph, pq, min_distances)
  end

  def loop(_graph, [] = _pq, min_distances, _visited), do: min_distances

  def loop(graph, priority_queue, min_distances, visited \\ []) do
    {curr, pq} = PriorityQueue.dequeue(priority_queue)

    min_distances =
      if curr.dist < elem(min_distances[curr.name], 0),
        do: put_in(min_distances, [curr.name], {curr.dist, curr.prev}),
        else: min_distances

    pq =
      graph[curr.name]
      |> Enum.filter(&(&1.name not in visited))
      |> Enum.reduce(pq, fn child, pq ->
        PriorityQueue.enqueue(pq, %{
          name: child.name,
          dist: elem(min_distances[curr.name], 0) + child.weight,
          prev: curr.name
        })
      end)

    loop(graph, pq, min_distances, [curr.name | visited])
  end
end
