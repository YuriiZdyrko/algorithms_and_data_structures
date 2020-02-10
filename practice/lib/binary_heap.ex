defmodule MaxBinaryHeap do
    @moduledoc """
    Time complexity:
    - log(n) for insertion and removal
    - n for search

    In max binary heap parent is always larger than children.

    def parent_index(n), do: floor((n - 1)/2)
    
    def children_indexes(0), do: {1, 2}
    def children_indexes(n), do: {(2 * n) + 1, (2 * n) + 2}

    Priority Queue - a special case of Binary Heap, where each Node
    has {Priority, Value}, and Priority is used for comparison.
    """
    
    #         41
    #      39     33
    #   18   27      12

    @heap [41, 39, 33, 18, 27, 12]

    def test_insert do
        insert(@heap, 36)
    end

    def test_remove_root do
        remove_root(@heap)
    end

    @doc """
    Method name for priority queue: dequeue(heap)

    - put last [num] in front
    - recursively swap [num] with largest child if child > [num]
    """
    def remove_root(heap) do
        [_ | t] = heap
        heap_last = List.last(heap)
        heap = [heap_last | List.delete_at(t, length(t) - 1)]

        sink_loop(heap, heap_last, 0)
    end

    def sink_loop(heap, value, n) when n >= length(heap) - 1 do
        heap
    end
    def sink_loop(heap, value, n) do
        {l_child_index, r_child_index} = children_indexes(n)
        
        l_child_v = Enum.at(heap, l_child_index)
        r_child_v = Enum.at(heap, r_child_index)

        if (value < max(l_child_v, r_child_v)) do
            larger_child_index = if (l_child_v > r_child_v),
                do: l_child_index,
                else: r_child_index

            heap
            |> swap(larger_child_index, n)
            |> sink_loop(value, larger_child_index)
        else
            heap
        end
    end

    @doc """
    Method signature for priority queue: enqueue(heap, value, priority)

    - put new [num] in the end
    - recursively swap [num] with parent if parent < [num]
    """
    def insert(heap, value) do
        heap = heap ++ [value]
        n = length(heap) - 1

        bubble_loop(heap, value, n)
    end

    def bubble_loop(heap, value, 0), do: heap
    def bubble_loop(heap, value, n) do
        parent_n = parent_index(n)
        parent_v = Enum.at(heap, parent_n)

        if (parent_v < value) do
            heap
            |> swap(parent_n, n)
            |> bubble_loop(value, parent_n)
        else
            heap
        end
    end

    def swap(heap, n, m) do
        n_v = Enum.at(heap, n)
        m_v = Enum.at(heap, m)

        heap
        |> List.update_at(n, fn _ -> m_v end)
        |> List.update_at(m, fn _ -> n_v end)
    end 
    
    def parent_index(n), do: floor((n - 1) / 2)
    
    def children_indexes(0), do: {1, 2}
    def children_indexes(n), do: {(2 * n) + 1, (2 * n) + 2}
end