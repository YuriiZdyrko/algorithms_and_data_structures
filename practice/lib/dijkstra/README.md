
Dijsktra shortest path algorithm
Finds shortest path between 2 vertexes

Algorithm:
- start with A vertex
- pick neighbor with smallest distance from Current (N)
- for each of its neighbors X:
    if we find new shortest path to X vertex, we update:
    - "Pick the smallest table" value for X
    - "Backtrack table" value for X
    - update Visited, when all N's neighbours have been visited

1. Pick the smallest. (priority queue can be used)
Vertex                                | Shortest dist to A
    a (crosseds)                        0
    b (cross if b's neighbours visited) 10
    c                                   40
    d                                   100
    e                                   Infinity

2. Visited
[A, C]

3. Backtrack (previous value for shortest path)
{
    A: null,
    B: A,
    C: A
}

for each of neighbours
    - compare distance to neighbour with current shortest
    if smaller:
        - update "shortest distances" table
        - update "backtrack" table
    if not smaller:
        - ignore
push neighbour into visited (cross out in "shortest distances")

        pick smallest not crossed from "shortest distances"