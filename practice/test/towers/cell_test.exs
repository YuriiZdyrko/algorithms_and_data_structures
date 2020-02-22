defmodule Towers.CellTest do
  use ExUnit.Case
  alias Towers.{Cell}

  test "Assigns value if 1 item left in (values - discovered_values)" do
    empty_set = MapSet.new()
    discovered_values = MapSet.new([3, 4])

    assert %Cell{
             value: 1,
             values: ^empty_set
           } =
             Cell.assign_value(
               %Cell{
                 values: MapSet.new([1, 3, 4]),
                 value: nil
               },
               discovered_values
             )
  end

  test "discovered?/1 returns correct result" do
    assert Cell.discovered?(%Cell{value: 1})
    refute Cell.discovered?(%Cell{value: nil})
  end
end
