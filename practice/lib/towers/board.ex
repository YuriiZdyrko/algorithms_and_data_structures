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

    board = %Board{
      cells: cells
    }
  end

  def run do
    board = new()

    board =
      board
      |> split_rows
      |> Enum.map(&Row.digest_clues/1)
      |> Enum.reduce(board, &Board.merge_row(&2, &1))

    try do
      loop(board)
    catch
      "row_duplicates" ->
        IO.inspect("Duplicates error! Random approach sucks")
        run()

      other ->
        IO.inspect(other)
        System.halt(0)
    end
  end

  def loop(board, counter \\ 1) do
    Process.sleep(1000)

    IO.puts("<<<<<<<<<<")

    # IO.inspect(board)

    IO.puts("AAAAAND digest!")

    board_new = digest(board)

    IO.puts(">>>>>>>>")

    if equal?(board, board_new) do
      # IO.inspect("Board.digest №#{counter} equal, will try random shot...")

      # loop(random_shot(board_new), counter + 1)
      throw("TODO: random shot")
      System.halt(0)
    else
      IO.inspect("Board.digest №#{counter} unequal ")

      loop(board_new, counter + 1)
    end
  end

  def cells_discovered_count(%Board{cells: cells}) do
    Enum.count(List.flatten(cells), &Cell.discovered?(&1))
  end

  def digest(%Board{cells: cells} = board) do
    board
    |> digest_merge_hor_rows()
    |> digest_merge_ver_rows()

    # TODO: Digest horizontal and vertical rows separately,
    # Or merge horizontal into Cells, and then merge Vertical.
    # Then merge their results, using smallest values
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
    board
    |> replace_cell(h)
    |> merge_row(t)
  end

  def replace_cell(board = %Board{cells: cells}, %Cell{} = cell) do
    %Board{
      board
      | cells:
          List.update_at(
            cells,
            cell.y,
            &List.replace_at(&1, cell.x, cell)
          )
    }
  end

  def cell_at(board, x, y) when is_integer(x) and is_integer(y) do
    board.cells
    |> Enum.at(y)
    |> Enum.at(x)
  end

  def random_shot(board) do
    cell =
      board.cells
      |> List.flatten()
      |> Enum.filter(fn %Cell{values: values} -> MapSet.size(values) == 2 end)
      |> Enum.sort_by(fn %Cell{values: values} -> MapSet.size(values) end)
      |> List.first()

    new_value = Enum.at(cell.values, :rand.uniform(MapSet.size(cell.values) - 1))

    new_cell = %Cell{
      cell
      | value: new_value,
        values: MapSet.new()
    }

    replace_cell(board, new_cell)
  end

  def equal?(board1, board2) do
    board1 == board2
  end

  def print(board) do
    board.cells
    |> Enum.map(fn row -> Enum.map(row, &{&1.value, &1.values}) end)
    |> IO.inspect()

    board
  end

  def digest_merge_ver_rows(board = %Board{cells: cells}) do
    cells
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> digest_merge(board)
  end

  def digest_merge_hor_rows(board = %Board{cells: cells}) do
    digest_merge(cells, board)
  end

  def digest_merge(cells, board) do
    cells
    |> Enum.map(&Row.digest_cells/1)
    |> Enum.reduce(board, fn row, board ->
      Board.merge_row(board, row)
    end)
  end
end
