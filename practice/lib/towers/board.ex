defmodule Towers.Board do
  defstruct [:size, :rows_ver, :rows_hor, cells: [], clues: []]
  alias Towers.{Board, Row, Cell, Permutations}
  import IEx

  @board_size 4
  @clues [2, 2, 1, 3, 2, 2, 3, 1, 1, 2, 2, 3, 3, 2, 1, 3]

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

  def digest_loop(board, status \\ :continue)

  def digest_loop(board, :continue) do
    board_new = digest(board)
    IO.puts("loop...")

    if board != board_new do
      digest_loop(board_new)
    else
      nil_values_remain =
        board.cells
        |> List.flatten()
        |> Enum.any?(&is_nil(&1.value))

      if !nil_values_remain,
        do: digest_loop_success(board_new, :done_by_digest),
        else: try_to_resolve_ambiquity(board_new)
    end
  end

  def digest_loop_success(board, :done_by_digest) do
    IO.puts("digest_loop success :)")
    {:done, board}
  end

  def digest_loop_success(board, :done_by_guess) do
    IO.puts("guess_loop success :) \n")
    {:done, board}
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
      |> Enum.map(fn {cells, row} ->
        Row.digest_cells(row, cells)
      end)

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

    empty_cells =
      row
      |> Enum.filter(&is_nil(&1.value))

    nil_heights =
      empty_cells
      |> Enum.map(&MapSet.to_list(&1.values))
      |> Permutations.do_recursive()
      |> Enum.reject(&(Enum.uniq(&1) != &1))

    empty_cells_permuts =
      nil_heights
      |> Enum.map(fn permut ->
        permut
        |> Enum.zip(empty_cells)
        |> Enum.map(fn {permut_value, cell} ->
          %Cell{
            cell
            | value: permut_value,
              values: MapSet.new()
          }
        end)
      end)

    guess_loop(board, empty_cells_permuts)
  end

  def guess_loop(board, [cells | t]) do
    IO.puts("guess_loop...")

    tentative_board =
      cells
      |> Enum.reduce(board, fn cell = %Cell{x: x, y: y}, board ->
        board
        |> update_cell_at(x, y, fn _ -> cell end)
      end)

    with {:done, board} <- digest_loop(tentative_board),
         {:ok, board} <- validate_against_clues(board) do
      digest_loop_success(board, :done_by_guess)
    else
      {:clues_error, _board} ->
        IO.puts("guess_loop failed attempt :-/")
        guess_loop(board, t)
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

  def validate_against_clues(board) do
    all_valid? =
      0..(board.size - 1)
      |> Enum.all?(fn i ->
        hor_valid? =
          Row.cells_allowed_by_clues?(
            Enum.at(board.rows_hor, i),
            Enum.at(cells_for_rows(board, :rows_hor), i)
          )

        ver_valid? =
          Row.cells_allowed_by_clues?(
            Enum.at(board.rows_ver, i),
            Enum.at(cells_for_rows(board, :rows_ver), i)
          )

        hor_valid? and ver_valid?
      end)

    case all_valid? do
      true -> {:ok, board}
      _ -> {:clues_error, board}
    end
  end
end

defmodule PuzzleSolver do
  import Towers.Board

  def solve(clues) do
    with {:done, board} <- digest_loop(new(clues)) do
      result(board)
    end
  end
end
