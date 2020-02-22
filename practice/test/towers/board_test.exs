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
    map_set_1 = MapSet.new()
    map_set_2 = MapSet.new([2, 3])

    board =
      Board.new()
      |> Board.merge_row(%Row{
        cells: [
          %Cell{x: 1, y: 2, value: 1, values: MapSet.new()},
          %Cell{x: 1, y: 3, value: nil, values: MapSet.new([2, 3])}
        ]
      })

    %Cell{value: 1, values: ^map_set_1} = Board.cell_at(board, 1, 2)
    %Cell{value: nil, values: ^map_set_2} = Board.cell_at(board, 1, 3)
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
end
