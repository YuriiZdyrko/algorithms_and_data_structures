defmodule Towers.Cell do
  alias __MODULE__
  defstruct [:x, :y, value: nil, values: MapSet.new()]
  @enforce_keys [:x, :y]

  def new(x, y) do
    %Cell{x: x, y: y}
  end

  def apply_values(%Cell{value: nil, values: values} = cell) do
    if MapSet.size(values) == 1 do
      %Cell{
        cell
        | values: MapSet.new(),
          value: Enum.at(values, 0)
      }
    else
      cell
    end
  end

  def apply_values(cell), do: cell

  def apply_discovered(%Cell{values: values} = cell, set, size) do
    if is_nil(cell.value) && MapSet.size(set) == size - 1 do
      value =
        1..size
        |> Enum.into(MapSet.new())
        |> MapSet.difference(set)
        |> Enum.at(0)

      %Cell{
        cell
        | values: MapSet.new(),
          value: value
      }
    else
      %Cell{
        cell
        | values: MapSet.difference(values, set)
      }
    end
  end

  def apply_uniques(cell, set) do
    matching_unique = MapSet.intersection(cell.values, set)

    if MapSet.size(matching_unique) == 1 do
      %Cell{
        cell
        | value: Enum.at(matching_unique, 0),
          values: MapSet.new()
      }
    else
      cell
    end
  end

  def pristine?(%Cell{value: nil, values: values}),
    do: MapSet.size(values) == 0

  def pristine?(%Cell{}), do: false
end
