defmodule Towers.PuzzleSolverTest do
  use ExUnit.Case
  alias PuzzleSolver

  @tag solver: true
  test "test 1" do
    check(
      [2, 2, 1, 3, 2, 2, 3, 1, 1, 2, 2, 3, 3, 2, 1, 3],
      [[1, 3, 4, 2], [4, 2, 1, 3], [3, 4, 2, 1], [2, 1, 3, 4]]
    )
  end

  @tag solver: true
  test "test 2" do
    check(
      [0, 0, 1, 2, 0, 2, 0, 0, 0, 3, 0, 0, 0, 1, 0, 0],
      [[2, 1, 4, 3], [3, 4, 1, 2], [4, 2, 3, 1], [1, 3, 2, 4]]
    )
  end

  @tag solver: true
  test "test 3" do
    check(
      [0, 1, 0, 0, 0, 0, 1, 2, 0, 2, 0, 0, 0, 3, 0, 0],
      [[1, 4, 3, 2], [3, 2, 4, 1], [2, 3, 1, 4], [4, 1, 2, 3]]
    )
  end

   @tag solver: true
    test "test 4" do
      check(
        [0, 2, 0, 0, 0, 3, 0, 0, 0, 1, 0, 0, 0, 0, 1, 2],
        [[3, 2, 1, 4], [4, 1, 3, 2], [1, 4, 2, 3], [2, 3, 4, 1]]
      )
    end

  defp check(clues, result) do
    assert PuzzleSolver.solve(clues) == result
  end
end
