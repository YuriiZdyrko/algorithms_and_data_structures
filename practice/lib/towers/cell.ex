defmodule Towers.Cell do
  alias __MODULE__

  defstruct [:x, :y, value: nil, values: MapSet.new()]
  @enforce_keys [:x, :y]

  @board_size 4

  def new(x, y) when x < @board_size and y < @board_size do
    %Cell{x: x, y: y}
  end

  def assign_value(%Cell{value: _value, values: values} = cell, discovered_values) do
    values = MapSet.difference(values, discovered_values)

    if MapSet.size(values) == 1 do
      %Cell{
        cell
        | values: MapSet.new(),
          value: Enum.at(values, 0)
      }
    else
      %Cell{
        cell
        | values: values
      }
    end
  end

  def discovered?(%Cell{value: value}),
    do: not is_nil(value)
end
