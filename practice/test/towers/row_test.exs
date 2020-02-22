defmodule Towers.RowTest do
  use ExUnit.Case
  alias Towers.{Row, Cell}

  test "Returns new Row struct" do
    n_front = 3
    n_back = 1

    cells =
      for {x, y} <- [{0, 0}, {1, 0}, {2, 0}] do
        Cell.new(x, y)
      end

    assert %Row{
             n_back: ^n_back,
             n_front: ^n_front,
             cells: ^cells
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
      n_back: nil,
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

  test "digest/1 updates cells:
    - removes discovered values from Cell.values sets
    - if Cell.values contains single item, set Cell.value" do
    row = %Row{
      cells: [
        %Cell{
          value: nil,
          values: MapSet.new([1, 2, 3])
        },
        %Cell{
          value: 1,
          values: MapSet.new()
        },
        %Cell{
          value: nil,
          values: MapSet.new([4])
        },
        %Cell{
          value: nil,
          values: MapSet.new([2, 3])
        }
      ]
    }

    values_2_3 = MapSet.new([2, 3])
    values_empty = MapSet.new()

    assert %Row{
             cells: [
               %Cell{
                 value: nil,
                 values: ^values_2_3
               },
               %Cell{
                 value: 1,
                 values: ^values_empty
               },
               %Cell{
                 value: 4,
                 values: ^values_empty
               },
               %Cell{
                 value: nil,
                 values: ^values_2_3
               }
             ]
           } = Row.digest(row)
  end
end
