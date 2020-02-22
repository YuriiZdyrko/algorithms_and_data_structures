defmodule Towers.Row do
  alias __MODULE__

  alias Towers.{Cell}

  @board_size 4

  defstruct [:n_front, :n_back, cells: []]

  def new(n_front, n_back, cells) do
    %Row{
      n_front: n_front,
      n_back: n_back,
      cells: cells
    }
  end

  def digest(%Row{cells: cells} = row) do
    discovered_values =
      cells
      |> Enum.filter(& &1.value)
      |> Enum.map(& &1.value)
      |> Enum.into(MapSet.new())

    %Row{
      cells: Enum.map(cells, &Cell.assign_value(&1, discovered_values))
    }
  end

  @doc """
    Set initial values[] set for each cell in a row,
    using clues (n_front and n_back).
    After digest clues are no longer needed, 
    because they are transformed here into cells' values[].

    For example for:
        n_front: 1, n_back: 3, board_size: 4,
    matching values are:
        [
            MapSet[4], 
            MapSet[1, 2, 3], 
            MapSet[1, 3], 
            MapSet[1, 2]
        ]
  """
  def digest_clues(%Row{cells: cells} = row) do
    new_values =
      permutations(Enum.to_list(1..@board_size))
      |> Enum.filter(&permutation_valid?(row, &1))
      |> Enum.zip()
      |> Enum.map(&MapSet.new(Tuple.to_list(&1)))

    cells =
      cells
      |> Enum.with_index()
      |> Enum.map(fn {%Cell{values: prev_v} = cell, i} ->
        new_v = Enum.at(new_values, i)
        %Cell{cell | values: MapSet.union(prev_v, new_v)}
      end)

    %Row{row | cells: cells}
  end

  @doc """
  TODO: understand how this recursion works
  """
  def permutations([]), do: [[]]

  def permutations(list) do
    for elem <- list,
        rest <- permutations(list -- [elem]),
        do: [elem | rest]
  end

  def permutation_valid?(%Row{n_front: n_front, n_back: n_back}, heights) do
    side_valid?(heights, n_front) &&
      side_valid?(Enum.reverse(heights), n_back)
  end

  def side_valid?(heights, n, n_curr \\ 0, max_height_curr \\ 0)

  def side_valid?(_, nil, _, _), do: true

  def side_valid?([], n, n_curr, _max_height_curr),
    do: n == n_curr

  def side_valid?([h | t], n, n_curr, max_height_curr) do
    if h > max_height_curr do
      side_valid?(t, n, n_curr + 1, h)
    else
      side_valid?(t, n, n_curr, max_height_curr)
    end
  end
end
