defmodule Towers.Board do
  defstruct [:size, :rows_ver, :rows_hor, cells: [], clues: []]

  import IEx
  alias Towers.{Board, Row, Cell}

  @board_size 4
  @clues [2, 2, 1, 3, 2, 2, 3, 1, 1, 2, 2, 3, 3, 2, 1, 3]

  def solve(clues \\ @clues) do
    clues
    |> new() 
    |> loop()
  end

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

  def loop(board) do
    board_new = digest(board)

    if board == board_new do
      if Enum.any?(List.flatten(board.cells), &is_nil(&1.value)),
        do: throw("Ambiquity encountered"),
        else: result(board_new)
    else
      loop(board_new)
    end
  end

  def result(%Board{cells: cells}) do
    cells
    |> Enum.map(fn row_cells -> 
      Enum.map(row_cells, &(&1.value))
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

  defp cells_for_rows(board, :rows_hor) do
    board.cells
  end

  defp cells_for_rows(board, :rows_ver) do
    board.cells
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list(&1))
  end
end
