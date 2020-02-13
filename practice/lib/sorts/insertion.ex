defmodule Sorts.Insertion do
    def run do
        list = [3,5,10,1,55,20,100,2]
        sort(list)
    end

    def sort(list, sorted_part \\ [])
    def sort([], sorted_part), do: sorted_part
    def sort([h | t] = list, sorted_part) do
        # result = calc_front([h | result], h)
        sorted_part = calc_front(sorted_part, h)
        IO.inspect("outer")
        sort(t, sorted_part)
    end

    def calc_front(sorted_part, value, sorted_result \\ [])
    def calc_front([], value, sorted_result), 
        do: sorted_result ++ [value]
    def calc_front([h | t] = sorted_part, value, sorted_result) do
        IO.inspect("#{inspect sorted_part, charlists: false} vs #{value}")

        if (value < h) do
            sorted_result ++ [value] ++ sorted_part
        else
            calc_front(t, value, sorted_result ++ [h])
        end
    end
end