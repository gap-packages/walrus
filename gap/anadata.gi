# In reality we only need a list indexed by triples, so we
# will quite probably end up with a tree where the leaves have
# weights as labels.
InstallGlobalFunction(CyclicSubList,
function(l, pos, len)
    local r, i, j, llen;

    llen := Length(l);
    r := [];
    i := pos; j := 1;
    while j <= len do
        r[j] := l[i];
        i := i + 1; j := j + 1;
        if i > llen then
            i := 1;
        fi;
    od;

    return r;
end);

InstallGlobalFunction( EnterAllSubwords,
function(idx, word, value)
    local i, v, pos, ww;
    pos := [1..Length(word)];
    ww := List(word, x -> __ID(x));
    for i in pos do
        v := idx[ ww{ CyclicSubList(pos, i, 3) } ];
        if value < v then
            idx[ ww{ CyclicSubList(pos, i, 3) } ] := value;
        fi;
    od;
end);


#
InstallGlobalFunction( DigraphDijkstraST,
function(graph, s, t)
    local vertices, dist, prev, queue, u, v, alt;

    dist := [];
    prev := [];
    queue := BinaryHeap({x,y} -> x[1] < y[1]);

    for v in DigraphVertices(graph) do
        dist[v] := infinity;
        prev[v] := -1;
    od;

    dist[s] := 0;
    Push(queue, [0, s]);

    while not IsEmpty(queue) do
        u := Pop(queue);
        u := u[2];
        if u = t then
            return [ dist, prev ];
        fi;
        for v in OutNeighbours(graph)[u] do
            alt := dist[u] + DigraphEdgeLabel(graph, u, v);
            if alt < dist[v] then
                dist[v] := alt;
                prev[v] := u;
                Push(queue, [dist[v], v]);
            fi;
        od;
    od;
    return infinity;
end);

InstallGlobalFunction( DigraphDijkstraS,
function(graph, s)
    local vertices, dist, prev, queue, u, v, alt;

    dist := [];
    prev := [];
    queue := BinaryHeap({x,y} -> x[1] < y[1]);

    for v in DigraphVertices(graph) do
        dist[v] := infinity;
        prev[v] := -1;
    od;

    dist[s] := 0;
    Push(queue, [0, s]);

    while not IsEmpty(queue) do
        u := Pop(queue);
        u := u[2];
        for v in OutNeighbours(graph)[u] do
            alt := dist[u] + DigraphEdgeLabel(graph, u, v);
            if alt < dist[v] then
                dist[v] := alt;
                prev[v] := u;
                Push(queue, [dist[v], v]);
            fi;
        od;
    od;

    return [ dist, prev ];
end);


