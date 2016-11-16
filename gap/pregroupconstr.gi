# Takes two groups, and builds the pregroup underlying the free product of
# these two groups
#
# don't try using this on large groups.
#
InstallMethod(PregroupOfFreeProduct, "for two finite groups",
              [IsGroup and IsFinite, IsGroup and IsFinite],
function(G, H)
    local i, j, size, table, eltn;

    size := Size(G) + Size(H) - 1;
    table := NullMat(size,size);

    table{[2..Size(G)]}{[2..Size(G)]} := MultiplicationTable(G){[2..Size(G)]}{[2..Size(G)]};
    table{[Size(G)+1..size]}{[Size(G)+1..size]} := Size(G) - 1 + MultiplicationTable(H){[2..Size(H)]}{[2..Size(H)]};

    for i in [Size(G) + 1 .. size ] do
        for j in [Size(G) + 1 .. size ] do
            if table[i][j] = Size(G) then
                table[i][j] := 1;
            fi;
        od;
    od;

    for i in [1..size] do
        table[1][i] := i;
        table[i][1] := i;
    od;

    eltn := List([1..size], String);
    return PregroupByTable(eltn, table);
end);

