defmodule Towers.Cell do
  alias __MODULE__
  import IEx

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

  def apply_values(%Cell{value: val} = cell) do
    cell
  end

  def apply_singles(%Cell{values: values} = cell, set) do
    if MapSet.size(values) > 1 do
      values = MapSet.difference(values, set)

      %Cell{
        cell
        | values: values
      }
    else
      cell
    end
  end

  def apply_discovered(%Cell{values: values} = cell, set, size) do
    if MapSet.size(set) == size - 1 && is_nil(cell.value) do
      new_value =
        1..size
        |> Enum.into(MapSet.new())
        |> MapSet.difference(set)
        |> MapSet.to_list()
        |> List.first()

      %Cell{
        cell
        | values: MapSet.new(),
          value: new_value
      }
    else
      values = MapSet.difference(values, set)

      %Cell{
        cell
        | values: values
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
