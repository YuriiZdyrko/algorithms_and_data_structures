defmodule Towers.Board2Test do
  use ExUnit.Case
  alias Towers.{Board, Cell, Row}

  #  TODO: Make row extract cells from a Board, using coords,
  #  This should be responsibility of a row.
  #  Merging a row is a responsibility of a Board

  @tag new_board: true
  test "new" do 
    clues = [2, 2, 1, 3, 2, 2, 3, 1, 1, 2, 2, 3, 3, 2, 1, 3]
    size = 4
    board = Board.new(clues, size)

    assert %Board{
             size: ^size,
             clues: ^clues,
             cells: cells,
             rows_hor: rows_hor,
             rows_ver: rows_ver
           } = board

    cell_1_values = MapSet.new([1, 2])
    cell_2_values = MapSet.new([2, 3])
    cell_3_values = MapSet.new([4])
    cell_4_values = MapSet.new([1, 2])

    assert [
             [
               %Cell{x: 0, y: 0, values: ^cell_1_values},
               %Cell{x: 1, y: 0, values: ^cell_2_values},
               %Cell{x: 2, y: 0, values: ^cell_3_values},
               %Cell{x: 3, y: 0, values: ^cell_4_values}
             ],
             [%Cell{x: 0, y: 1}, %Cell{x: 1, y: 1}, %Cell{x: 2, y: 1}, %Cell{x: 3, y: 1}],
             row_3,
             row_4
           ] = cells

    assert [
             %Row{n_front: 3, n_back: 2},
             %Row{n_front: 1, n_back: 2},
             %Row{},
             %Row{}
           ] = rows_hor

    assert [
             %Row{n_front: 2, n_back: 3},
             %Row{n_front: 2, n_back: 2},
             %Row{},
             %Row{}
           ] = rows_ver
  end

  @tag compute: true
  test "compute rows" do
    assert %Board{
             rows_hor: [
               hor_1,
               hor_2,
               %Row{},
               %Row{}
             ],
             rows_ver: [
               ver_1,
               ver_2,
               %Row{},
               %Row{}
             ]
           } = Board.new()

    assert %Row{n_front: 3, n_back: 2, cells: []} = hor_1
    assert %Row{n_front: 1, n_back: 2, cells: []} = hor_2

    assert %Row{n_front: 2, n_back: 3, cells: []} = ver_1
    assert %Row{n_front: 2, n_back: 2, cells: []} = ver_2
  end

  @tag merge: true
  test "merge row" do
    board = %Board{
      cells: [
        [
          %Cell{value: nil, values: set([1, 2, 4]), x: 0, y: 0},
          %Cell{value: nil, values: set([1, 2, 3]), x: 1, y: 0},
          %Cell{value: nil, values: set([3]), x: 2, y: 0},
          %Cell{value: nil, values: set([4]), x: 3, y: 0}
        ]
      ]
    }

    row = %Row{
      cells: [
        %Cell{value: nil, values: set([1, 2]), x: 0, y: 0},
        %Cell{value: nil, values: set([1, 2]), x: 1, y: 0},
        %Cell{value: 3, values: set(), x: 2, y: 0},
        %Cell{value: 4, values: set(), x: 3, y: 0}
      ]
    }

    board = Board.merge_row(board, row)

    map_set_1 = set([1, 2])
    map_set_2 = set([1, 2])
    map_set_3 = set()
    map_set_4 = set()

    assert %Cell{value: nil, values: ^map_set_1} = Board.cell_at(board, 0, 0)
    assert %Cell{value: nil, values: ^map_set_2} = Board.cell_at(board, 1, 0)
    assert %Cell{value: 3, values: ^map_set_3} = Board.cell_at(board, 2, 0)
    assert %Cell{value: 4, values: ^map_set_4} = Board.cell_at(board, 3, 0)
  end

  test "cell_at" do
    board = Board.new()
    assert %Cell{x: 1, y: 2} = Board.cell_at(board, 1, 2)
  end

  @tag board_digest: true
  test "digest/1" do
    values = MapSet.new()

    assert %Towers.Board{
             cells: [
               [
                 %Cell{value: 1, values: ^values, x: 0, y: 0},
                 %Cell{value: 3, values: ^values, x: 1, y: 0},
                 %Cell{value: 4, values: ^values, x: 2, y: 0},
                 %Cell{value: 2, values: ^values, x: 3, y: 0}
               ],
               [
                 %Cell{value: 4, values: ^values, x: 0, y: 1},
                 %Cell{value: 2, values: ^values, x: 1, y: 1},
                 %Cell{value: 1, values: ^values, x: 2, y: 1},
                 %Cell{value: 3, values: ^values, x: 3, y: 1}
               ],
               [
                 %Cell{value: 3, values: ^values, x: 0, y: 2},
                 %Cell{value: 4, values: ^values, x: 1, y: 2},
                 %Cell{value: 2, values: ^values, x: 2, y: 2},
                 %Cell{value: 1, values: ^values, x: 3, y: 2}
               ],
               [
                 %Cell{value: 2, values: ^values, x: 0, y: 3},
                 %Cell{value: 1, values: ^values, x: 1, y: 3},
                 %Cell{value: 3, values: ^values, x: 2, y: 3},
                 %Cell{value: 4, values: ^values, x: 3, y: 3}
               ]
             ]
           } = Board.new() |> Board.digest()
  end

  def set(list \\ []), do: MapSet.new(list)
end
