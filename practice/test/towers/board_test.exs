defmodule Towers.BoardTest do
  use ExUnit.Case
  alias Towers.{Board, Cell, Row}

  test "new board generates 4X4 cells grid" do
    clues = []

    assert %Board{
             cells: [
               [%Cell{x: 0, y: 0}, %Cell{x: 1, y: 0}, %Cell{x: 2, y: 0}, %Cell{x: 3, y: 0}],
               [%Cell{x: 0, y: 1}, %Cell{x: 1, y: 1}, %Cell{x: 2, y: 1}, %Cell{x: 3, y: 1}],
               row_3,
               row_4
             ]
           } = Board.new(clues)
  end

  test "cell_at" do
    board = Board.new()
    assert %Cell{x: 1, y: 2} == Board.cell_at(board, 1, 2)
  end

  test "merge row" do
    map_set_1 = set([1, 2])
    map_set_2 = set([1, 2])
    map_set_3 = set()
    map_set_4 = set()

    board = %Board{
      cells: [
        [
          %Cell{value: nil, values: set([1, 2]), x: 0, y: 0},
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

    assert %Cell{value: nil, values: ^map_set_1} = Board.cell_at(board, 0, 0)
    assert %Cell{value: nil, values: ^map_set_2} = Board.cell_at(board, 1, 0)
    assert %Cell{value: 3, values: ^map_set_3} = Board.cell_at(board, 2, 0)
    assert %Cell{value: 4, values: ^map_set_4} = Board.cell_at(board, 3, 0)
  end

  test "equality of boards" do
    board1 = Board.new()

    new_row = %Row{
      cells: [
        %Cell{x: 1, y: 2, value: 1, values: set()},
        %Cell{x: 1, y: 3, value: nil, values: set([2, 3])}
      ]
    }

    board2 = Board.merge_row(board1, new_row)

    board3 = Board.merge_row(board1, new_row)

    refute board1 == board2
    assert board2 == board2
  end

  test "split rows" do
    assert [
             hor_1,
             hor_2,
             %Row{},
             %Row{},
             ver_1,
             ver_2,
             %Row{},
             %Row{}
           ] = Board.new() |> Board.split_rows()

    assert %Row{n_front: 3, n_back: 2} = hor_1
    assert %Row{n_front: 1, n_back: 2} = hor_2

    assert %Row{n_front: 2, n_back: 3} = ver_1
    assert %Row{n_front: 2, n_back: 2} = ver_2
  end

  @tag board_digest: true
  test "digest/1" do
    set11 = set([1, 2, 3])
    set12 = set([1, 2, 3])
    set_empty = set([])
    set14 = set([1, 2])

    set22 = set([1, 2, 4])
    set23 = set([1, 2])
    set24 = set([1, 3])

    set31 = set([2, 3])
    set32 = set([1, 2, 4])
    set33 = set([1, 2])
    set34 = set([1, 2, 3])

    set41 = set([1, 2])
    set42 = set([1, 2])

    assert %Towers.Board{
             cells: [
               [
                 %Cell{value: nil, values: ^set11, x: 0, y: 0},
                 %Cell{value: nil, values: ^set12, x: 1, y: 0},
                 %Cell{value: 4, values: ^set_empty, x: 2, y: 0},
                 %Cell{value: nil, values: ^set14, x: 3, y: 0}
               ],
               [
                 %Cell{value: 4, values: ^set_empty, x: 0, y: 1},
                 %Cell{value: nil, values: ^set22, x: 1, y: 1},
                 %Cell{value: nil, values: ^set23, x: 2, y: 1},
                 %Cell{value: nil, values: ^set24, x: 3, y: 1}
               ],
               [
                 %Cell{value: nil, values: ^set31, x: 0, y: 2},
                 %Cell{value: nil, values: ^set32, x: 1, y: 2},
                 %Cell{value: nil, values: ^set33, x: 2, y: 2},
                 %Cell{value: nil, values: ^set34, x: 3, y: 2}
               ],
               [
                 %Cell{value: nil, values: ^set41, x: 0, y: 3},
                 %Cell{value: nil, values: ^set42, x: 1, y: 3},
                 %Cell{value: 3, values: ^set_empty, x: 2, y: 3},
                 %Cell{value: 4, values: ^set_empty, x: 3, y: 3}
               ]
             ]
           } =
             Board.digest(%Towers.Board{
               cells: [
                 [
                   %Cell{values: set([1, 2, 3]), x: 0, y: 0},
                   %Cell{values: set([1, 2, 3]), x: 1, y: 0},
                   %Cell{values: set([4]), x: 2, y: 0},
                   %Cell{values: set([1, 2]), x: 3, y: 0}
                 ],
                 [
                   %Cell{values: set([4]), x: 0, y: 1},
                   %Cell{values: set([1, 2, 4]), x: 1, y: 1},
                   %Cell{values: set([1, 2]), x: 2, y: 1},
                   %Cell{values: set([1, 3]), x: 3, y: 1}
                 ],
                 [
                   %Cell{values: set([2, 3]), x: 0, y: 2},
                   %Cell{values: set([1, 2, 4]), x: 1, y: 2},
                   %Cell{values: set([1, 2]), x: 2, y: 2},
                   %Cell{values: set([1, 2, 3]), x: 3, y: 2}
                 ],
                 [
                   %Cell{values: set([1, 2]), x: 0, y: 3},
                   %Cell{values: set([1, 2, 3]), x: 1, y: 3},
                   %Cell{values: set([3]), x: 2, y: 3},
                   %Cell{values: set([4]), x: 3, y: 3}
                 ]
               ]
             })
  end

  def set(list \\ []), do: MapSet.new(list)
end
