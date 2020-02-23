defmodule Towers.Row do
  alias __MODULE__

  import IEx

  alias Towers.{Cell}

  @board_size 4

  defstruct [:n_front, :n_back, cells: []]

  # TODO: Refactor rows, to be persistent. Transient Rows has been dumb idea.
  # Inside Row store coords of cells, n_front, n_back.
  # Board will have hor_rows Row[], and ver_rows Row[]
  # Every time some operation on rows is done, 
  # Board will fill Rows' cells, using Coords from a row and Cells from a Board.
  def new(n_front, n_back, cells) do
    %Row{
      n_front: n_front,
      n_back: n_back,
      cells: cells
    }
  end

  def digest_cells(cells), do: digest(%Row{cells: cells})

  def digest(%Row{cells: cells} = row) do
    IO.inspect("row_digest_1:")

    IO.inspect(
      row.cells
      |> Enum.map(fn cell -> {cell.value, MapSet.to_list(cell.values)} end)
    )

    discovered_values =
      cells
      |> Enum.filter(&(&1.value != nil))
      |> Enum.map(& &1.value)

    if has_duplicates?(discovered_values) do
      IO.inspect(cells)
      IO.inspect(discovered_values)
      throw("row_duplicates")
      Process.sleep(2000)
    end

    all_values =
      cells
      |> Enum.reduce([], fn %Cell{values: values}, acc ->
        acc ++ MapSet.to_list(values)
      end)

    uniques_set =
      all_values
      |> Enum.group_by(fn v ->
        Enum.count(all_values, &(&1 == v))
      end)
      |> Map.get(1, [])
      |> Enum.into(MapSet.new())

    singles_set =
      cells
      |> Enum.filter(&(MapSet.size(&1.values) == 1))
      |> Enum.reduce(MapSet.new(), &MapSet.union(&1.values, &2))

    discovered_set = Enum.into(discovered_values, MapSet.new())

    new_cells =
      Enum.map(cells, fn cell ->
        cell
        |> Cell.apply_singles(singles_set)
        |> Cell.apply_uniques(uniques_set)
        |> Cell.apply_discovered(discovered_set)
        |> Cell.apply_values()
      end)

    result = %Row{
      cells: new_cells
    }

    if new_cells != cells do
      # IO.inspect("row_digest_2:")
      # IO.inspect(result)
      digest(result)
    else
      # IO.inspect("row_digest_3:")
      # IO.inspect(result)
      result
    end
  end

  def has_duplicates?(list), do: Enum.uniq(list) != list

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
