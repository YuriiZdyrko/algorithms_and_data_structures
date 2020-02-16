defmodule GraphsTraversal do
  @moduledoc """
  Options for traversal:
  - Bread-first (move in all possible directions)
  - Depth-first (move away from root, then backtrack & repeat)
  - Priority-first (for example Dijkstra algorithm)
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

  def test_dfs_simple() do
    # {:ok, agent_pid} = Agent.start(fn -> MapSet.new() end)

    graph()
    |> dfs_simple(:a)
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
  DFS - very "smart" approach. But I'll leave it here for historic reference.
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

  @doc """
  DFS - look mummy, no Agent!
  """
  def dfs_simple(graph, vertex) do
    dfs_simple(graph, vertex, [], [vertex])
  end

  def dfs_simple(graph, vertex, visited, stack) do
    if vertex in visited do
      IO.inspect("ignore #{vertex}")
    else
      IO.inspect("visit #{vertex}")

      [h | rest_of_stack] =
        graph[vertex]
        |> Enum.reject(&(&1 in visited))
        |> Kernel.++(stack)

      dfs_simple(graph, h, [vertex | visited], rest_of_stack)
    end
  end
end
