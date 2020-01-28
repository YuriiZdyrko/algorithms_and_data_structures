defmodule BinarySearch do
  def run(num \\ 12) do
    list = [1, 2, 4, 5, 6, 12, 14, 15, 55, 56, 76, 87, 1000]
    search(list, num)
  end

  def search(list, num) do
    {first, [h | _] = second} =
      list
      |> Enum.split(div(length(list), 2))

    IO.inspect(list)
    Process.sleep(100)

    cond do
      num == h -> true
      length(list) == 1 -> false
      num > h -> search(second, num)
      num < h -> search(first, num)
    end
  end
end
