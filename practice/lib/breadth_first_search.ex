defmodule BFS do
  #       10
  #     6    15
  #   3  8     20
  #  2 4      

  def run do
    tree = {
      10,
      {
        6,
        {
          3,
          { 2, nil, nil },
          { 4, nil, nil },
        },
        { 8, nil, nil }
      },
      {
        15,
        nil,
        { 20, nil, nil }
      }
    }

    IO.inspect("bfs: #{inspect bfs(tree)}")
    IO.inspect("dfs: #{inspect dfs(tree)}")
  end

  def bfs(nil), do: []
  def bfs([]), do: []
  def bfs(nodes) when is_list(nodes) do
    values = nodes
    |> Enum.map(fn({v, l, r}) -> v end)

    children = nodes
    |> Enum.flat_map(fn({v, l, r}) -> 
      Enum.filter([l, r], &(&1 != nil))
    end)

    values ++ bfs(children)
  end
  def bfs(tree) do
    {v, l, r} = tree

    [v] ++ bfs([l, r])
  end

  def dfs(nil), do: []
  def dfs(tree) do
    {v, l, r} = tree
    
    [v] ++ dfs(l) ++ dfs(r)
  end
end
