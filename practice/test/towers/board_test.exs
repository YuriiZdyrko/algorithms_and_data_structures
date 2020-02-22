defmodule Towers.BoardTest do
  use ExUnit.Case
  alias Towers.{Board, Cell}

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

  test "merge row" do
    # %Board{
    #     cells: [
    #         %Cell{
    #             x: 0,
    #             y: 0
    #         },
    #         %Cell{
    #             x: 0,
    #             y: 0
    #         }
    #     ]
    # }
  end
end
