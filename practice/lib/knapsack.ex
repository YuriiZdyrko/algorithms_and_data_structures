defmodule Knapsack do
  @cols_count 6

  def test do
    list = prepare_data_structure()
    end_list = iterate_list(list, &iterator/2)

    IO.puts("RESULT:")
    result = get_cell_value(end_list, {length(list) - 1, @cols_count - 1})
  end

  def prepare_data_structure do
    list = [
      {:water, 3, 10},
      {:book, 1, 3},
      {:food, 2, 9},
      {:jacket, 2, 5},
      {:camera, 1, 6}
    ]

    list =
      Enum.map(list, fn item ->
        Tuple.append(item, List.duplicate({0, []}, @cols_count))
      end)
  end

  def iterate_list(list, f, coords \\ {0, 0})

  def iterate_list(list, f, {i, j} = coords) when @cols_count > j do
    last_j_in_a_row = j == @cols_count - 1

    new_list = f.(list, coords)

    next_coords =
      if last_j_in_a_row,
        do: {i + 1, 0},
        else: {i, j + 1}

    if last_j_in_a_row && i == length(list) - 1 do
      new_list
    else
      iterate_list(new_list, f, next_coords)
    end
  end

  def iterate_list(list, _f, {i, j} = _coords) do
    list
  end

  def iterator(list, {i, j} = coords) do
    _prev_val = {p_price, p_value} = get_cell_value(list, {i - 1, j})

    _row = {row_name, row_weight, row_price, row_values} = Enum.at(list, i)

    rem_space_j = j - row_weight

    {r_price, r_value} =
      if rem_space_j >= 0 do
        get_cell_value(list, {i - 1, rem_space_j})
      else
        {0, []}
      end

    new_list =
      if row_price + r_price > p_price && row_weight <= j + 1 do
        update_cell_value(
          list,
          coords,
          {row_price + r_price, r_value ++ [row_name]}
        )
      else
        update_cell_value(
          list,
          coords,
          {p_price, p_value}
        )
      end

    IO.inspect(new_list)
    Process.sleep(200)
    new_list
  end

  def update_cell_value(list, {i, j} = _coords, new_value) do
    list
    |> List.update_at(i, fn {row_name, row_weight, row_price, row_values} ->
      new_row_values =
        row_values
        |> List.update_at(j, fn _ ->
          new_value
        end)

      {row_name, row_weight, row_price, new_row_values}
    end)
  end

  def get_cell_value(list, {i, j} = _coords) do
    case Enum.at(list, i) do
      nil ->
        nil

      {row_name, row_weight, row_price, row_values} ->
        Enum.at(row_values, j)
    end
  end
end
