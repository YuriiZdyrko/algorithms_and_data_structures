defmodule LongestSubstring do
  def substring() do
    matrix("fish", "fosh")
    |> iterate(&substring_cell/2)
  end

  def subsequence() do
    {_, _, sum1} =
      matrix("fosh", "fish")
      |> iterate(&subsequence_cell/2)
      |> List.last()
      |> List.last()

    {_, _, sum2} =
      matrix("fosh", "fort")
      |> iterate(&subsequence_cell/2)
      |> List.last()
      |> List.last()

    IO.puts("Max is: #{max(sum1, sum2)}")
  end

  defp matrix(s1, s2) do
    s1_list = String.split(s1, "", trim: true)
    s2_list = String.split(s2, "", trim: true)

    matrix =
      for s1_char <- s1_list, s2_char <- s2_list do
        {s1_char, s2_char, 0}
      end

    matrix
    |> Enum.chunk_every(length(s1_list))
  end

  defp subsequence_cell(matrix, {i, j} = coords) do
    value = {cur_l, cur_r, _} = value_at(matrix, coords)

    prev_sum = sum_at(matrix, {i - 1, j - 1})
    prev_x_sum = sum_at(matrix, {i, j - 1})
    prev_y_sum = sum_at(matrix, {i - 1, j})

    sum =
      if cur_l == cur_r,
        do: prev_sum + 1,
        else: max(prev_x_sum, prev_y_sum)

    update_at(matrix, coords, sum)
  end

  defp substring_cell(matrix, {i, j} = coords) do
    value = {cur_l, cur_r, _} = value_at(matrix, coords)
    prev_sum = sum_at(matrix, {i - 1, j - 1})

    sum =
      if cur_l == cur_r,
        do: prev_sum + 1,
        else: 0

    update_at(matrix, coords, sum)
  end

  defp sum_at(matrix, coords) do
    with {_, _, sum} <- value_at(matrix, coords) do
      sum
    else
      nil -> 0
    end
  end

  defp value_at(matrix, {i, j} = _coords) do
    matrix
    |> Enum.at(i)
    |> Kernel.||([])
    |> Enum.at(j)
  end

  defp update_at(matrix, {i, j} = _coords, new_sum) do
    row =
      matrix
      |> Enum.at(i)

    new_row =
      row
      |> List.update_at(j, fn tuple = {l, r, _} ->
        {l, r, new_sum}
      end)

    List.replace_at(matrix, i, new_row)
  end

  defp iterate(matrix, f, coords \\ {0, 0})

  defp iterate(matrix, f, {i, j} = coords) do
    Process.sleep(300)
    IO.inspect(matrix)

    max_i = length(matrix)
    max_j = length(Enum.at(matrix, 0)) - 1
    last_j = j == max_j

    if max_i > i do
      next_coords =
        if last_j,
          do: {i + 1, 0},
          else: {i, j + 1}

      new_matrix = f.(matrix, coords)
      iterate(new_matrix, f, next_coords)
    else
      matrix
    end
  end
end
