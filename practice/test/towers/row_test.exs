defmodule Towers.RowTest do
  use ExUnit.Case
  alias Towers.{Row, Cell}

  @tag new_row: true
  test "Returns new Row struct" do
    n_front = 3
    n_back = 2

    cells =
      for {x, y} <- [{0, 0}, {1, 0}, {2, 0}, {3, 0}] do
        Cell.new(x, y)
      end

    values_1 = set([1, 2])
    values_2 = set([2, 3])
    values_3 = set([4])
    values_4 = set([1, 2, 3])

    assert %Row{
             n_back: ^n_back,
             n_front: ^n_front,
             cells: [
               %Cell{value: nil, values: ^values_1, x: 0, y: 0},
               %Cell{value: nil, values: ^values_2, x: 1, y: 0},
               %Cell{value: nil, values: ^values_3, x: 2, y: 0},
               %Cell{value: nil, values: ^values_4, x: 3, y: 0}
             ]
           } = Row.new(n_front, n_back, cells)
  end

  test "permutations/1 returns all possible combinations" do
    assert [[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]] ==
             Row.permutations([1, 2, 3])
  end

  test "permutation_valid?/2 returns correct values" do
    # 3-item array
    assert Row.permutation_valid?(%Row{n_front: 2, n_back: 2}, [1, 3, 2])
    assert Row.permutation_valid?(%Row{n_front: 3, n_back: 1}, [1, 2, 3])
    refute Row.permutation_valid?(%Row{n_front: 3, n_back: 1}, [3, 2, 1])
    assert Row.permutation_valid?(%Row{n_front: 1, n_back: 3}, [3, 2, 1])

    # Longer array
    assert Row.permutation_valid?(%Row{n_front: 4, n_back: 3}, [1, 3, 4, 7, 5, 6, 2])
    refute Row.permutation_valid?(%Row{n_front: 4, n_back: 3}, [1, 3, 4, 7, 6, 5, 2])
  end

  test "given n_front and n_back, digest_clues/2 sets values correctly" do
    row = %Row{
      n_front: 1,
      n_back: 3,
      cells:
        for {x, y} <- [{0, 0}, {1, 0}, {2, 0}, {3, 0}] do
          Cell.new(x, y)
        end
    }

    cell_1_values = MapSet.new([4])
    cell_2_values = MapSet.new([1, 2, 3])
    cell_3_values = MapSet.new([1, 3])
    cell_4_values = MapSet.new([1, 2])

    assert %Row{
             n_front: _,
             n_back: _,
             cells: [
               %Cell{values: ^cell_1_values},
               %Cell{values: ^cell_2_values},
               %Cell{values: ^cell_3_values},
               %Cell{values: ^cell_4_values}
             ]
           } = Row.digest_clues(row)
  end

  test "given only n_front, digest_clues/2 sets values correctly" do
    row = %Row{
      n_front: 1,
      n_back: 0,
      cells:
        for {x, y} <- [{0, 0}, {1, 0}, {2, 0}, {3, 0}] do
          Cell.new(x, y)
        end
    }

    cell_1_values = MapSet.new([4])
    cell_values = MapSet.new([1, 2, 3])

    assert %Row{
             n_front: _,
             n_back: _,
             cells: [
               %Cell{values: ^cell_1_values},
               %Cell{values: ^cell_values},
               %Cell{values: ^cell_values},
               %Cell{values: ^cell_values}
             ]
           } = Row.digest_clues(row)
  end

  @tag no_clues: true
  test "given no clues, all permutations are returned" do
    row = %Row{
      n_front: 0,
      n_back: 0,
      cells:
        for {x, y} <- [{0, 0}, {1, 0}, {2, 0}, {3, 0}] do
          Cell.new(x, y)
        end
    }

    cell_values = MapSet.new([1,2,3,4])

    assert %Row{
             n_front: _,
             n_back: _,
             cells: [
               %Cell{values: ^cell_values},
               %Cell{values: ^cell_values},
               %Cell{values: ^cell_values},
               %Cell{values: ^cell_values}
             ]
           } = Row.digest_clues(row)
  end

  test "digest/1 updates cells:
    - cleans up discovered values from Cell.values (1)
    - if Cell.values has a unique item, set Cell.value (4)
    - if Cell.values contains single item, set Cell.value (2, 3)
  " do
    row = %Row{
      cells: [
        %Cell{
          value: nil,
          values: MapSet.new([1, 2, 3, 4])
        },
        %Cell{
          value: 1,
          values: MapSet.new()
        },
        %Cell{
          value: nil,
          values: MapSet.new([2])
        },
        %Cell{
          value: nil,
          values: MapSet.new([2, 3])
        }
      ]
    }

    values_empty = MapSet.new()

    assert %Row{
             cells: [
               %Cell{
                 value: 4,
                 values: ^values_empty
               },
               %Cell{
                 value: 1,
                 values: ^values_empty
               },
               %Cell{
                 value: 2,
                 values: ^values_empty
               },
               %Cell{
                 value: 3,
                 values: ^values_empty
               }
             ]
           } = Row.digest(row)
  end

  @tag row_digest: true
  test "digest/1" do
    empty_set = set()
    set_1_2 = set([1, 2])

    assert %Row{
             cells: [
               %Cell{value: 4, values: ^empty_set},
               %Cell{value: nil, values: ^set_1_2},
               %Cell{value: nil, values: ^set_1_2},
               %Cell{value: 3, values: ^empty_set}
             ]
           } =
             Row.digest(%Row{
               cells: [
                 %Cell{values: set([4]), x: 0, y: 1},
                 %Cell{values: set([1, 2]), x: 1, y: 1},
                 %Cell{values: set([1, 2]), x: 2, y: 1},
                 %Cell{values: set([1, 3]), x: 3, y: 1}
               ]
             })
  end

  @tag row_digest: true
  test "digest/1 - 3" do
    set_1_2_3_4 = set([1, 2, 3, 4])

    assert %Row{
             cells: [
               %Cell{value: nil, values: ^set_1_2_3_4},
               %Cell{value: nil, values: ^set_1_2_3_4},
               %Cell{value: nil, values: ^set_1_2_3_4},
               %Cell{value: nil, values: ^set_1_2_3_4}
             ]
           } =
             Row.digest(%Row{
               cells: [
                 %Cell{values: set_1_2_3_4, x: 0, y: 1},
                 %Cell{values: set_1_2_3_4, x: 1, y: 1},
                 %Cell{values: set_1_2_3_4, x: 2, y: 1},
                 %Cell{values: set_1_2_3_4, x: 3, y: 1}
               ]
             })
  end

  def set(list \\ []), do: MapSet.new(list)
end
