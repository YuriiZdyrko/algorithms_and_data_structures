defmodule Towers.Board do
  defstruct [:size, :rows_ver, :rows_hor, cells: [], clues: []]

  alias Towers.{Board, Row, Cell}
  import IEx

  @board_size 4
  @clues [2, 2, 1, 3, 2, 2, 3, 1, 1, 2, 2, 3, 3, 2, 1, 3]

  # @clues [2, 2, 1, 3, 2, 2, 3, 1, 1, 2, 2, 3, 3, 2, 1, 3]

  def new(clues \\ @clues, size \\ @board_size) do
    cells =
      for x <- 0..(size - 1), y <- 0..(size - 1) do
        Cell.new(y, x)
      end
      |> Enum.chunk_every(size)

    %Board{
      cells: cells,
      clues: clues,
      size: size
    }
    |> compute_rows()
  end

  def loop(board, status \\ :looping)

  def loop(board, :looping) do
    board_new = digest(board)
    IO.puts("loop")

    status =
      if board != board_new do
        :looping
      else
        nil_values_remain =
          board.cells
          |> List.flatten()
          |> Enum.any?(&is_nil(&1.value))

        if !nil_values_remain do
          :done
        else
          :ambiquity
        end
      end

    loop(board_new, status)
  end

  def loop(board, :done) do
    IO.puts("Done!")
    {:done, board}
  end

  def loop(board, :ambiquity) do
    IO.puts("Ambiquity encountered")
    try_to_resolve_ambiquity(board)
  end

  def result(%Board{cells: cells}) do
    cells
    |> Enum.map(fn row_cells ->
      Enum.map(row_cells, & &1.value)
    end)
  end

  def compute_rows(board = %Board{cells: cells, clues: clues, size: size}) do
    [
      front_vert,
      back_hor,
      back_vert,
      front_hor
    ] = Enum.chunk_every(clues, size)

    board
    |> init_merge_rows(Enum.reverse(front_hor), back_hor, :rows_hor)
    |> init_merge_rows(front_vert, Enum.reverse(back_vert), :rows_ver)
  end

  def init_merge_rows(board = %Board{cells: cells}, front_clues, back_clues, rows_key)
      when rows_key in [:rows_hor, :rows_ver] do
    cells =
      board
      |> cells_for_rows(rows_key)
      |> Enum.zip(front_clues)
      |> Enum.zip(back_clues)
      |> Enum.map(fn {{row_cells, front_clue}, back_clue} ->
        Row.new(front_clue, back_clue, row_cells)
      end)

    merge_rows(board, cells, rows_key)
  end

  def merge_rows(board, rows, rows_key) do
    rows
    |> Enum.reduce(board, &merge_row(&2, &1))
    |> Map.replace(
      rows_key,
      rows |> Enum.map(&Map.replace(&1, :cells, []))
    )
  end

  def merge_row(board, %Row{cells: cells}) do
    cells
    |> Enum.reduce(board, &merge_cell(&2, &1))
  end

  def merge_cell(
        board = %Board{cells: cells},
        %Cell{x: x, y: y, value: value, values: values}
      ) do
    update_cell_at(
      board,
      x,
      y,
      &%Cell{
        &1
        | values:
            if(Cell.pristine?(&1),
              do: values,
              else: MapSet.intersection(&1.values, values)
            ),
          value: &1.value || value
      }
    )
  end

  def update_cell_at(board = %Board{cells: cells}, x, y, updater_fn) do
    %Board{
      board
      | cells:
          List.update_at(
            cells,
            y,
            fn row ->
              List.update_at(
                row,
                x,
                &updater_fn.(&1)
              )
            end
          )
    }
  end

  def cell_at(board, x, y) do
    board.cells
    |> Enum.at(y)
    |> Enum.at(x)
  end

  def digest(%Board{cells: cells} = board) do
    board
    |> digest_merge_rows(:rows_hor)
    |> digest_merge_rows(:rows_ver)
  end

  def digest_merge_rows(board = %Board{cells: cells}, rows_key)
      when rows_key in [:rows_hor, :rows_ver] do
    rows =
      board
      |> cells_for_rows(rows_key)
      |> Enum.zip(Map.fetch!(board, rows_key))
      |> Enum.map(&Row.digest_cells(elem(&1, 1), elem(&1, 0)))

    board
    |> merge_rows(rows, rows_key)
  end

  def try_to_resolve_ambiquity(board) do
    row =
      board.cells
      |> Enum.find(fn cells ->
        Enum.any?(cells, &is_nil(&1.value))
      end)

    heights =
      row
      |> Enum.map(& &1.value)

    row_hor = Enum.at(board.rows_hor, Enum.at(row, 0).y)

    empty_cells =
      row
      |> Enum.filter(&is_nil(&1.value))

    nil_heights =
      empty_cells
      |> List.first()
      |> Map.get(:values)
      |> MapSet.to_list()
      |> Row.permutations()

    permuts =
      nil_heights
      |> Enum.map(&join_heights(heights, &1))

    empty_cells_with_permuts =
      permuts
      |> Enum.map(fn permut_values ->
        permut_values
        |> Enum.zip(empty_cells)
        |> Enum.map(fn {permut_value, cell} ->
          %Cell{
            cell
            | value: permut_value
          }
        end)
      end)

    try_permuts(board, empty_cells_with_permuts)
  end

  def try_permuts(board, [cells | t]) do
    IO.puts("try_permuts...")

    tentative_board =
      cells
      |> Enum.reduce(board, fn cell = %Cell{x: x, y: y}, board ->
        board
        |> update_cell_at(x, y, fn _ -> cell end)
      end)

    with {:done, board} <- loop(tentative_board),
          {:ok, board} <- validate_against_clues(board) do
      IO.puts("try_permuts success :)")
      {:done, board}
    else
      {:ambiquity, board} ->
        IO.puts("""
          try_permuts failed :( \n 
          Too much ambiquity... \n
          Greedier solution is required \n
        """)

      {:clues_error, _board} ->
        try_permuts(board, t)
    end
  end

  defp cells_for_rows(board, :rows_hor) do
    board.cells
  end

  defp cells_for_rows(board, :rows_ver) do
    board.cells
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list(&1))
  end

  def join_heights([], _), do: []

  def join_heights(rest, []) do
    rest
  end

  def join_heights([h1 | t1], [h2 | t2]) do
    [h1 || h2] ++ join_heights(t1, t2)
  end

  def validate_against_clues(board) do
    cells_rows_ver = cells_for_rows(board, :rows_ver)
    cells_rows_hor = cells_for_rows(board, :rows_hor)

    result =
      0..(board.size - 1)
      |> Enum.all?(fn i ->
        row_hor = Enum.at(board.rows_hor, i)
        row_ver = Enum.at(board.rows_ver, i)
        cells_hor = Enum.at(cells_rows_hor, i)
        cells_ver = Enum.at(cells_rows_ver, i)

        result =
          Row.cells_valid?(row_hor, cells_hor) &&
            Row.cells_valid?(row_ver, cells_ver)

        if !result do
          IO.puts("try_permuts failed attempt :-/")
        end

        result
      end)

    if result,
      do: {:ok, board},
      else: {:clues_error, board}
  end
end

defmodule PuzzleSolver do
  import Towers.Board

  def solve(clues) do
    with {:done, board} <- loop(new(clues)) do
      result(board)
    else
      other ->
        IO.puts("WAT")
    end
  end
end
