defmodule Towers.Cell do
  alias __MODULE__

  defstruct [:x, :y, value: nil, values: MapSet.new()]
  @enforce_keys [:x, :y]

  @board_size 4

  def new(x, y) when x < @board_size and y < @board_size do
    %Cell{x: x, y: y}
  end
end
