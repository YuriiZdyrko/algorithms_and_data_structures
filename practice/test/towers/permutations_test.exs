defmodule Towers.PermutationsTest do
  use ExUnit.Case

  import Towers.Permutations

  @arr [
    [1, 2, 3],
    [5, 6],
    [7, 8, 9]
  ]

  @result [
    [1, 5, 7],
    [2, 5, 7],
    [3, 5, 7],
    [1, 6, 7],
    [2, 6, 7],
    [3, 6, 7],
    [1, 5, 8],
    [2, 5, 8],
    [3, 5, 8],
    [1, 6, 8],
    [2, 6, 8],
    [3, 6, 8],
    [1, 5, 9],
    [2, 5, 9],
    [3, 5, 9],
    [1, 6, 9],
    [2, 6, 9],
    [3, 6, 9]
  ]

  test "tail_recursive" do
    assert @result == do_tail_recursive(@arr)
  end

  test "recursive" do
    assert @result == do_recursive(@arr)
  end

  test "reduce" do
    assert @result == do_reduce(@arr)
  end
end
