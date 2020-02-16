defmodule Sorts.Radix do
  @moduledoc """
  Comparison sorting algorithms can have n*log(n) complexity at best.
  Radix is faster kind (non-comparison), but works only on integers.

  Visualisation:

  0: 
  1: 
  2: 902, 92, 2
  3: 
  4: 54, 994
    => 902, 92, 2, 54, 994

  0: 902, 2
  1: 
  2: 
  ..
  5: 54
  9: 92, 994
    => 902, 2, 54, 92, 994

  0: 2, 54, 92
  1: 
  2: 
  3: 902, 994
    => 2, 54, 92, 902, 994

  0: 2, 54, 92, 902, 994
  1: 
  2:
  3:
    END => 2, 54, 92, 902, 994
  """

  def run(arr \\ [1, 23, 3224, 234, 2344, 3, 0, 2_342_342, 342]) do
    max_count =
      arr
      |> Enum.map(&digit_count(&1))
      |> Enum.max()

    loop(arr, 0, max_count)
  end

  @doc """
  Repeatedly bucketize-flatten array, until 
  nirvana (max_count) is reached.
  """
  def loop(arr, max_count, max_count), do: arr

  def loop(arr, curr_pos, max_count) do
    arr
    |> bucketize(curr_pos)
    |> List.flatten()
    |> loop(curr_pos + 1, max_count)
  end

  @doc """
  Splits array items into
  [[]*9] buckets by digit at curr_pos
  """
  def bucketize(arr, curr_pos) do
    buckets = List.duplicate([], 9)

    arr
    |> Enum.reduce(buckets, fn item, buckets ->
      buckets
      |> List.update_at(get_digit(item, curr_pos), &(&1 ++ [item]))
    end)
    |> IO.inspect()
  end

  @doc """
  Returns digit at position n, counting from the end of number
  """
  def get_digit(num, n) do
    floor(abs(num) / :math.pow(10, n))
    |> rem(10)
  end

  @doc """
  Returns count of digits in number
  """
  def digit_count(0), do: 1

  def digit_count(n) do
    (:math.log10(abs(n)) + 1)
    |> floor()
  end
end
