defmodule Sorts.Insertion do
    @moduledoc """
    To accomplish iteration over list and sorted left part,
    I used nested tail recursion.
    """
    def run do
        list = [3,5,10,1,55,20,100,2]
        sort(list)
    end

    def sort(list, sorted_part \\ [])
    def sort([], sorted_part), do: sorted_part
    def sort([h | t] = list, sorted_part) do
        sorted_part = calc_front(sorted_part, h)
        sort(t, sorted_part)
    end

    def calc_front(sorted_part, value, sorted_result \\ [])
    def calc_front([], value, sorted_result) do
        sorted_result ++ [value] 
        |> IO.inspect(charlists: false)
    end 
        
    def calc_front([h | t] = sorted_part, value, sorted_result) do
        IO.inspect("inner loop: #{inspect sorted_part, charlists: false} vs #{value}")

        if (value < h) do
            sorted_result ++ [value] ++ sorted_part
            |> IO.inspect(charlists: false)
        else
            calc_front(t, value, sorted_result ++ [h])
        end
    end
end