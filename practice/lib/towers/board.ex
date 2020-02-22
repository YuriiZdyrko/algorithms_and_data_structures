defmodule Towers.Board do
  defstruct cells: []

  import IEx
  alias Towers.{Board, Row, Cell}

  @board_size 4

  @clues [2, 2, 1, 3, 2, 2, 3, 1, 1, 2, 2, 3, 3, 2, 1, 3]

  def new(clues \\ @clues) do
    cells =
      for x <- 0..(@board_size - 1), y <- 0..(@board_size - 1) do
        Cell.new(y, x)
      end
      |> Enum.chunk_every(4)

    %Board{
      cells: cells
    }

    # generate rows, for each row
    # digest clues
    # merge
    # generate rows, for each row
    #   digest
    #   merge
  end

  def cells_discovered_count(%Board{cells: cells}) do
    Enum.count(cells, &Cell.discovered?(&1))
  end

  def split_rows(board) do
    [
      front_vert,
      back_hor,
      back_vert,
      front_hor
    ] = Enum.chunk_every(@clues, @board_size)

    hor_rows_cells = board.cells

    vert_rows_cells =
      board.cells
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list(&1))

    hor_rows = init_rows(hor_rows_cells, Enum.reverse(front_hor), back_hor)
    vert_rows = init_rows(vert_rows_cells, front_vert, Enum.reverse(back_vert))

    hor_rows ++ vert_rows
  end

  def init_rows(cells, front_clues, back_clues) do
    cells
    |> Enum.zip(front_clues)
    |> Enum.zip(back_clues)
    |> Enum.map(fn {{row_cells, front_clue}, back_clue} ->
      Row.new(front_clue, back_clue, row_cells)
    end)
  end

  def merge_row(board, %Row{cells: cells}),
    do: merge_row(board, cells)

  def merge_row(board, []), do: board

  def merge_row(board, [h | t]) do
    replace_cell(board, h)
    |> merge_row(t)
  end

  def replace_cell(board = %Board{cells: cells}, cell) do
    cells =
      List.update_at(
        cells,
        cell.y,
        fn row ->
          List.replace_at(row, cell.x, cell)
        end
      )

    %Board{
      board
      | cells: cells
    }
  end

  def cell_at(board, x, y) do
    board.cells
    |> Enum.at(y)
    |> Enum.at(x)
  end
end
