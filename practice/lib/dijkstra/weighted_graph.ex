defmodule Dijkstra.WeightedGraph do
  @moduledoc """
      A Min Weighted graph, with order by weight
      
      Representation:
      [
          A: [%{node: "B", weight: 10}, %{node: "C", weight: 1},],
          B: [%{node: "A", weight: 10}, %{node: "D", weight: 100}]
          ...
      ]
  """

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
    |> Enum.reduce(adj_list, fn {e1, e2, w}, acc -> add_edge(acc, e1, e2, w) end)
  end

  def add_edge(adj_list, v1, v2, weight) do
    adj_list
    |> update_in([v1], &[%{name: v2, weight: weight} | &1])
    |> update_in([v2], &[%{name: v1, weight: weight} | &1])
  end

  def remove_edge(adj_list, v1, v2) do
    adj_list
    |> update_in([v1], &Enum.reject(&1, fn v -> v.name == v2 end))
    |> update_in([v2], &Enum.reject(&1, fn v -> v.name == v1 end))
  end

  def remove_vertex(adj_list, v_removed) do
    adj_list
    |> Enum.map(fn {k, v} ->
      {k, Enum.reject(v, &(&1.name == v_removed))}
    end)
    |> Enum.into(%{})
    |> Map.delete(v_removed)
  end
end
