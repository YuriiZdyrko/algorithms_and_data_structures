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
          {2, nil, nil},
          {4, nil, nil}
        },
        {8, nil, nil}
      },
      {
        15,
        nil,
        {20, nil, nil}
      }
    }

    IO.inspect("bfs: #{inspect(bfs(tree))}")
    IO.inspect("dfs: #{inspect(dfs(tree))}")
    IO.inspect("dfs_post_order: #{inspect(dfs_postorder(tree))}")
    IO.inspect("dfs_pre_order: #{inspect(dfs_preorder(tree))}")
    IO.inspect("dfs_insert: #{inspect(insert(tree, 22))}")
    # IO.inspect("dfs_delete: #{inspect delete(tree, 6)}")
  end

  def bfs(nil), do: []
  def bfs([]), do: []

  def bfs(nodes) when is_list(nodes) do
    values =
      nodes
      |> Enum.map(fn {v, l, r} -> v end)

    children =
      nodes
      |> Enum.flat_map(fn {v, l, r} ->
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

  def dfs_postorder(nil), do: []

  def dfs_postorder(tree) do
    {v, l, r} = tree

    dfs_postorder(r) ++ dfs_postorder(l) ++ [v]
  end

  def dfs_preorder(nil), do: []

  def dfs_preorder(tree) do
    {v, l, r} = tree

    dfs_preorder(l) ++ [v] ++ dfs_preorder(r)
  end

  def insert(nil, value), do: {value, nil, nil}

  def insert(tree, value) do
    {v, l, r} = tree

    if value > v do
      {v, l, insert(r, value)}
    else
      {v, insert(l, value), r}
    end
  end

  # def delete(nil, value), do: nil
  # def delete(tree, value) do
  #   {v, l, r} = tree

  #   if (value == v) do
  #     {l_v, l_l, l_r} = l
  #     {ll_v, ll_l, ll_r} = l_l

  #     {l_v, {ll_v, ll_l, ll_r}, l_r}
  #   else
  #     {v, delete(l, value), delete(r, value)}
  #   end
  # end
end
