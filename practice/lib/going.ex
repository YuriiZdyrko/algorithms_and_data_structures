defmodule Going do
  @moduledoc """
  Compute following, with approximation to 6 after comma:
  u1 = (1 / 1!) * (1!)
  u2 = (1 / 2!) * (1! + 2!)
  u3 = (1 / 3!) * (1! + 2! + 3!)
  un = (1 / n!) * (1! + 2! + 3! + ... + n!)

  My solution should go to Codewars wall of shame :)

  Most upvoted solution:
  defmodule Going do
    def going(1), do: 1
    def going(n), do: going(n-1) / n + 1    
  end
  """

  def going(n) do
    {sum_factorial_n, cache} =
      1..n
      |> Enum.reduce(
        {0, %{}},
        fn n, {sum, cache} ->
          {factorial_n, cache} = factorial(n, cache)
          {sum + factorial_n, cache}
        end
      )

    factorial_n = trim_large_int(cache[n])
    sum_factorial_n = trim_large_int(sum_factorial_n)

    1 / factorial_n * sum_factorial_n
    |> Float.ceil(6)
  end

  @doc """
  Trimming to prevent arithmetic error during division, 
  caused by ridiculously large integers.
  """
  def trim_large_int(int) do
    int
    |> to_string()
    |> String.slice(0, 10)
    |> Integer.parse()
    |> elem(0)
  end

  @doc """
  Compute factorials, and store already computed results in a cache map
  """
  def factorial(1, cache), do: {1, %{1 => 1}}

  def factorial(n, cache) do
    case Map.get(cache, n) do
      nil ->
        {factorial_n_prev, cache} = factorial(n - 1, cache)
        factorial_n = n * factorial_n_prev
        {factorial_n, Map.put(cache, n, factorial_n)}

      factorial_n ->
        {factorial_n, cache}
    end
  end
end
