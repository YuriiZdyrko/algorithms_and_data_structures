defmodule Dijkstra do
  alias Dijkstra.{WeightedGraph, PriorityQueue}

  import IEx

  @moduledoc """
        A   
     1/   \2

     B     C  
    3|     4|
        1
     D  -  E
     6\  1/ \9
         
        F  3-  G 

  A to F shortest = A->B->D->E->F
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
    Enum.map(
      graph,
      fn {node, _edges} ->
        {node, {:infinity, nil}}
      end
    )
    |> Enum.into(%{})
    |> put_in([:a], {0, nil})
  end

  def run(initial_node \\ :a) do
    graph = init_graph()
    min_distances = init_min_distances(graph)

    pq =
      PriorityQueue.new()
      |> PriorityQueue.enqueue(%{dist: 0, name: initial_node, prev: nil})

    loop(graph, pq, min_distances)
    |> backtrack()
  end

  def loop(graph, [] = pq, min_distances, visited), do: min_distances

  def loop(graph, priority_queue, min_distances, visited \\ []) do
    {curr, pq} = PriorityQueue.dequeue(priority_queue)

    min_distances =
      if curr.dist < elem(min_distances[curr.name], 0) do
        put_in(min_distances, [curr.name], {curr.dist, curr.prev})
      else
        min_distances
      end

    priority_queue =
      graph
      |> Map.get(curr.name)
      |> Enum.filter(&(&1.name not in visited))
      |> Enum.reduce(pq, fn child, pq ->
        PriorityQueue.enqueue(pq, %{
          name: child.name,
          dist: elem(min_distances[curr.name], 0) + child.weight,
          prev: curr.name
        })
      end)

    # IO.inspect(min_distances)
    # Process.sleep 100

    loop(graph, priority_queue, min_distances, [curr.name | visited])
  end

  def backtrack(min_distances) do
    min_distances
    |> Enum.map(fn {k, {dist, from}} ->
      from
    end)
    |> Enum.uniq()
    |> tl
  end
end
