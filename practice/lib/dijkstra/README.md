
# Dijsktra algorithm
## Find shortest distance between initial node and rest of nodes

    Example graph:

        A   
     1/   \2

     B     C  
    3|     4|
        1
     D  -  E
     6\  1/ \9
         
        F  3-  G

    For this graph, result (min_distances) would be:
    
    %{
        a: {0, nil},
        b: {1, :a},
        c: {2, :a},
        d: {4, :b},
        e: {5, :d},
        f: {6, :e},
        g: {9, :f}
    }

Start values:

    1. 1 item (initial node A) priority_queue:
    [
        %{dist: 0, name: (A), prev: nil}
    ]

    2. N items min_distances table (N == number of nodes in a graph)
    %{
        a: %{0, nil},
        b: %{Infinity, nil},
        c: %{Infinity, nil}
        ...
    }

    3. 0 items in visited_nodes list

Recursive part:

    1. Dequeue smallest distance item CurrNode from priority_queue
    
    2. Check if CurrNode distance is smaller than value in min_distances table.
        true? -> update min_distances distance for CurrNode
        false? -> do nothing

    3. Enqueue not visited neighbours of CurrNode into priority_queue, with: 
        - dist:  min_distances[CurrNode] + (distance from CurrNode to neighbour)
        - prev: CurrNode

    4. Add CurrNode into visited_nodes table
    
    -> Repeat for remaining items in priority_queue, untill it's empty, passing:
        priority_queue
        min_distances 
        visited_nodes