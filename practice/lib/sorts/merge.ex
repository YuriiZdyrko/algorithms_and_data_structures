defmodule Sorts.Merge do
  @moduledoc """
  [40 2 6 5 12 10 100]
  [[40] [2] [6] [5] [12] [10] [100]]    
  [2 40] [5 6] [10 12] [100]
  [2 5 6 40] [10 12 100]
  [2 5 6 10 12 40 100]
  """

  alias __MODULE__.{Recursive, TailRecursive}

  def benchmark() do
    list =
      2_000_0..1
      |> Enum.into([])

    for mod <- [Recursive, TailRecursive] do
      {uSecs, _} = :timer.tc(mod, :run, [list])
      IO.inspect("#{mod} took: #{uSecs / 1000} msecs")
    end
  end
end

defmodule Sorts.Merge.Recursive do
  def run(list \\ [200, 40, 2, 6, 5, 12, 10, 100, 1, 50]) do
    loop(list)
  end

  def loop([el]), do: [el]
  def loop([]), do: []

  def loop(list) do
    {l, r} = Enum.split(list, floor(length(list) / 2))
    merge(loop(l), loop(r))
  end

  def merge(l1, l2, result \\ [])
  def merge([], l2, result), do: result ++ l2
  def merge(l1, [], result), do: result ++ l1

  def merge([h1 | t1] = l1, [h2 | t2] = l2, result) do
    case h1 < h2 do
      true -> merge(t1, l2, result ++ [h1])
      _ -> merge(l1, t2, result ++ [h2])
    end
  end
end

defmodule Sorts.Merge.TailRecursive do
  def run(list \\ [200, 40, 2, 6, 5, 12, 10, 100, 1, 50]) do
    list
    |> Enum.map(&[&1])
    |> loop()
  end

  def loop([result]), do: result

  def loop(list) do
    list
    |> Enum.chunk_every(2)
    |> Enum.map(&merge/1)
    |> loop()
  end

  def merge(l, result \\ [])
  def merge([end_result], _), do: end_result
  def merge([[], l2], result), do: result ++ l2
  def merge([l1, []], result), do: result ++ l1

  def merge([l1, l2] = [[h1 | t1], [h2 | t2]] = l, result) do
    case h1 < h2 do
      true -> merge([t1, l2], result ++ [h1])
      _ -> merge([l1, t2], result ++ [h2])
    end
  end
end
