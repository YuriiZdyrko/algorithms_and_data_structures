defmodule QuickSort do
  @moduledoc """
  Long, ugly approach
  """
  # https://www.youtube.com/watch?v=MZaf_9IZCrc
  def run(arr \\ [1, 5, 3, 6, 7, 2, 4]) do
    pvt = Enum.at(arr, length(arr) - 1)
    loop(arr, pvt)
  end

  def loop(arr, pvt, i \\ 0, j \\ 0)
  def loop(arr, _, _, _) when length(arr) < 2, do: arr
  def loop([a, b] = arr, _, _, _) when a < b, do: arr
  def loop([a, b] = arr, _, _, _) when a > b, do: [b, a]

  def loop(arr, pvt, i, j) when j < length(arr) do
    # IO.inspect(arr)
    # IO.inspect(pvt)
    # IO.inspect(i)
    # IO.inspect(j)
    # IO.inspect("\n")
    # Process.sleep(200)

    at_j = Enum.at(arr, j)

    cond do
      at_j < pvt ->
        # shift items < pvt to the left
        at_i = Enum.at(arr, i)
        arr = List.replace_at(arr, i, at_j)
        arr = List.replace_at(arr, j, at_i)
        loop(arr, pvt, i + 1, j + 1)

      at_j >= pvt ->
        loop(arr, pvt, i, j + 1)
    end
  end

  def loop(arr, pvt, i, j) when j == length(arr) do
    # Move pivot to i + 1
    arr =
      arr
      |> List.delete_at(length(arr) - 1)
      |> List.insert_at(i, pvt)

    # Recurse
    {left, right} = Enum.split(arr, i)

    IO.inspect("<<!")
    IO.inspect(left)
    IO.inspect(right)
    IO.inspect("!>>")

    run(left) ++ run(right)
  end
end

defmodule QuickSortSimple do
  @moduledoc """
  Nice and short
  """

  def run(arr \\ [7, 8, 2, 3, 5, 6])
  def run(arr) when length(arr) < 2, do: arr

  def run([h | t]) do
    smaller = Enum.filter(t, &(&1 < h))
    larger = Enum.filter(t, &(&1 > h))
    run(smaller) ++ [h] ++ run(larger)
  end
end
