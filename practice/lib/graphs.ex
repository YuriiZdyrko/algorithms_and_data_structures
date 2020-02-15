defmodule Graphs do
  @moduledoc """
      Graphs = edges + nodes • (vertexes)
      1. Undirected - 2 way connections. No direction, associated with edge.
      2. Directed - edges have arrows. Arrows may be both ways though (<-->)

      A. Weighted - each edge has weight, or distance
      B. Unweighted - edges are equivalent


      Ways to store graphs: 
      1. Adjacency matrix - better only for very interconnected (not sparse) graphs
      A B C D E F
      A 0 1 0
      B 1 0 1
      C 0 1 0
      D 0 0 1
      E 0 0 0
      F 1 0 1

      2. Adjacency list (better for most cases)
      [
          [1, 5],
          [0, 2],
          [1, 3],
          [2, 4]
      ]
      OR if names are not numbers
      [
          A: ["B", "C"],
          B: ["D", "E"],
          C: ["A", "K"]
      ]


      Weighted graph representation:
      [
          A: [%{node: "B", weight: 10}, %{node: "C", weight: 1},],
          B: [%{node: "A", weight: 10}, %{node: "D", weight: 100}]
          ...
      ]
  """

  # Undirected unweighted graph, stored ad adjacency list
  def test do
    new()
    |> add_vertex(:a)
    |> add_vertex(:b)
    |> add_vertex(:c)
    |> add_edge(:a, :b)
    |> add_edge(:a, :c)
    |> add_edge(:b, :c)
    |> remove_edge(:b, :c)
    |> remove_vertex(:a)
  end

  def new() do
    %{}
  end

  def add_vertex(adj_list, vertex) do
    Map.put_new(adj_list, vertex, [])
  end

  def add_vertexes(adj_list, vertexes) do
    vertexes
    |> Enum.reduce(adj_list, fn v, acc -> add_vertex(acc, v) end)
  end

  def add_edges(adj_list, edges) do
    edges
    |> Enum.reduce(adj_list, fn {e1, e2}, acc -> add_edge(acc, e1, e2) end)
  end

  def add_edge(adj_list, v1, v2) do
    adj_list
    |> update_in([v1], &[v2 | &1])
    |> update_in([v2], &[v1 | &1])
  end

  def remove_edge(adj_list, v1, v2) do
    adj_list
    |> update_in([v1], &Enum.reject(&1, fn v -> v == v2 end))
    |> update_in([v2], &Enum.reject(&1, fn v -> v == v1 end))
  end

  def remove_vertex(adj_list, v_removed) do
    adj_list
    |> Enum.map(fn {k, v} ->
      {k, Enum.reject(v, &(&1 == v_removed))}
    end)
    |> Enum.into(%{})
    |> Map.delete(v_removed)
  end
end
