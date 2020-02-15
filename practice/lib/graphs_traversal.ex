defmodule GraphsTraversal do
  @moduledoc """
  Options for traversal:
  - Bread-first (move in all possible directions)
  - Depth-first (move away from root, then backtrack & repeat)
  """

  import Graphs

  @doc """
        A       K - J - L
      /   \       /
     B     C     I
     |     | \  /
     D  -  E - G
      \   / \/
        F - H 
  """
  def graph do
    new()
    |> add_vertexes(~w(a b c d e f g h i j k l)a)
    |> add_edges([
      {:a, :b},
      {:a, :c},
      {:b, :d},
      {:c, :e},
      {:d, :e},
      {:d, :f},
      {:e, :f},
      {:e, :g},
      {:c, :g},
      {:e, :h},
      {:f, :h},
      {:g, :h},
      {:g, :i},
      {:i, :j},
      {:j, :k},
      {:j, :l}
    ])
    |> IO.inspect()
  end

  def test_bfs() do
    graph()
    |> bfs([:a])
  end

  def test_dfs() do
    {:ok, agent_pid} = Agent.start(fn -> MapSet.new() end)

    graph()
    |> dfs(:a, agent_pid)
  end

  @doc """
  BFS helps find shortest path
  """
  def bfs(graph, vertexes, visited \\ [])
  def bfs(graph, [], visited), do: []

  def bfs(graph, vertexes, visited) do
    visited = visited ++ vertexes

    next =
      vertexes
      |> Enum.flat_map(&graph[&1])
      |> Enum.uniq()
      |> Enum.reject(&(&1 in visited))

    IO.inspect("visiting #{inspect(vertexes)}")

    bfs(graph, next, visited)
  end

  @doc """
  DFS helps find if path exists
  """
  def dfs(graph, vertex, agent_pid) do
    visited = Agent.get(agent_pid, & &1)

    if vertex in visited do
      # No backtracking here (vertex already visited by deeper call)
      IO.inspect("ignore #{vertex}")
    else
      IO.inspect("visit #{vertex}")
      Agent.update(agent_pid, &MapSet.put(&1, vertex))

      graph[vertex]
      |> Enum.filter(&(not (&1 in visited)))
      |> Enum.sort()
      |> Enum.each(&dfs(graph, &1, agent_pid))
    end
  end
end
