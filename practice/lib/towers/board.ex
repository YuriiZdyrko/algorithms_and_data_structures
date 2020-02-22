defmodule Towers.Board do
  defstruct cells: []

  alias Towers.{Board, Row, Cell}

  @board_size 4

  def new(clues) do
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

  def merge_row(board, %Row{cells: []} = _row), do: board

  def merge_row(board, %Row{cells: [h | t]} = _row) do
    updated_cell = %Cell{x: x, y: y} = h

    List.update_at(
      board.cells,
      y,
      fn row ->
        List.replace_at(row, x, updated_cell)
      end
    )
  end
end
