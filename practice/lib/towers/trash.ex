# def random_shot(board) do
#   cell =
#     board.cells
#     |> List.flatten()
#     |> Enum.filter(fn %Cell{values: values} -> MapSet.size(values) == 2 end)
#     |> Enum.sort_by(fn %Cell{values: values} -> MapSet.size(values) end)
#     |> List.first()

#   new_value = Enum.at(cell.values, :rand.uniform(MapSet.size(cell.values) - 1))

#   new_cell = %Cell{
#     cell
#     | value: new_value,
#       values: MapSet.new()
#   }

#   replace_cell(board, new_cell)
# end

# def replace_cell(board = %Board{cells: cells}, %Cell{} = cell) do
#   %Board{
#     board
#     | cells:
#         List.replace_at(
#           cells,
#           cell.y,
#           cell
#         )
#   }
# end
