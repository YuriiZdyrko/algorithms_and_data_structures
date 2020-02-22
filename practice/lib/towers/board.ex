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
    # generate rows, for each row
    # digest clues
    # merge
    # generate rows, for each row
    #   digest
    #   merge
  end

  def run do
    board = new()

    board = board
    |> split_rows
    |> Enum.map(&Row.digest_clues/1)
    |> Enum.reduce(board, &Board.merge_row(&2, &1))

    try do
      loop(board)
    catch e -> 
      IO.inspect("OK, running again")
      run()
    end
    # rows = board
    # |> split_rows()
    # |> Enum.map(&Row.digest/1)

    # board = rows
    # |> Enum.reduce(board, fn row, board -> 
    #   Board.merge_row(board, row)
    # end)
  end
  
  def loop(board) do
    board_new = board
    |> split_rows
    |> Enum.map(&Row.digest/1)
    |> Enum.reduce(board, &Board.merge_row(&2, &1))
    
    # Random shooting
    if (equal?(board, board_new)) do
      # cells = board_new.cells |> List.flatten()
      new_cells = board_new.cells
      |> Enum.map(&random_shot/1)
      # |> List.flatten()

      # IO.inspect(new_cells)
      
      Process.sleep(1000)
      IEx.pry()
      
      loop(%Board{board_new | cells: new_cells})
    else
      IEx.pry()
      # IO.inspect(board)
      loop(board_new)
    end
  end

  def cells_discovered_count(%Board{cells: cells}) do
    Enum.count(List.flatten(cells), &Cell.discovered?(&1))
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

  # TODO: make random shot work nicely
  # Fucking random shot should be developed...
  def random_shot(cells, cells_shot \\ 0)
  def random_shot([], _), do: []
  def random_shot([h | t] = cells, cells_shot) do
    if MapSet.size(h.values) == 2 && cells_shot < 1 do
      IO.inspect("Alright, making a guess")
      [%Cell{
        h | 
        value: Enum.at(h.values, :rand.uniform(MapSet.size(h.values) - 1))
      } | random_shot(t, cells_shot + 1)]
    else
      [h | random_shot(t, cells_shot)]
    end
  end

  def equal?(board1, board2) do
    l1 = List.flatten(board1.cells) |> Enum.map(fn c -> {c.value, c.values} end)
    l2 = List.flatten(board2.cells) |> Enum.map(fn c -> {c.value, c.values} end)

    l1 == l2
  end
end
