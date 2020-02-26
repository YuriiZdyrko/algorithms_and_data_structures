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

  @tag solver: true
  test "test 6x6 - 1" do
    clues = [3, 2, 2, 3, 2, 1, 1, 2, 3, 3, 2, 2, 5, 1, 2, 2, 4, 3, 3, 2, 1, 2, 2, 4]

    expected = [
      [2, 1, 4, 3, 5, 6],
      [1, 6, 3, 2, 4, 5],
      [4, 3, 6, 5, 1, 2],
      [6, 5, 2, 1, 3, 4],
      [5, 4, 1, 6, 2, 3],
      [3, 2, 5, 4, 6, 1]
    ]

    check_size_6(clues, expected)
  end

  @tag solver: true
  test "test 6x6 - 2" do
    clues = [0, 0, 0, 2, 2, 0, 0, 0, 0, 6, 3, 0, 0, 4, 0, 0, 0, 0, 4, 4, 0, 3, 0, 0]

    expected = [
      [5, 6, 1, 4, 3, 2],
      [4, 1, 3, 2, 6, 5],
      [2, 3, 6, 1, 5, 4],
      [6, 5, 4, 3, 2, 1],
      [1, 2, 5, 6, 4, 3],
      [3, 4, 2, 5, 1, 6]
    ]

    check_size_6(clues, expected)
  end

  @tag solver: true
  test "test 6x6 - 3" do
    clues = [0, 3, 0, 5, 3, 4, 0, 0, 0, 0, 0, 1, 0, 3, 0, 3, 2, 3, 3, 2, 0, 3, 1, 0]

    expected = [
      [5, 2, 6, 1, 4, 3],
      [6, 4, 3, 2, 5, 1],
      [3, 1, 5, 4, 6, 2],
      [2, 6, 1, 5, 3, 4],
      [4, 3, 2, 6, 1, 5],
      [1, 5, 4, 3, 2, 6]
    ]

    check_size_6(clues, expected)
  end

  defp check(clues, result) do
    assert PuzzleSolver.solve(clues) == result
  end

  defp check_size_6(clues, result) do
    assert PuzzleSolver.solve_size_6(clues) == result
  end
end
