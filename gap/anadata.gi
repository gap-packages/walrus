
InstallGlobalFunction(NewANAMap,
function()
    return Objectify(ANAMapListType, [[]]);
end);

# Far from universal of course.
InstallMethod(AddOrUpdate, "for an anamap",
              [IsANAMap and IsANAMapListRep, IsPregroupPlace, IsInt, IsRat ],
function(map, place, length, val)
    if IsBound(map![1][__ID(place)]) then
        if IsBound(map![1][__ID(place)][length]) then
            if map![1][__ID(place)][length] > val then
                map![1][__ID(place)][length] := val;
            fi;
        else
            map![1][__ID(place)][length] := val;
        fi;
    else
        map![1][__ID(place)] := [];
        map![1][__ID(place)][length] := val;
    fi;
end);


InstallMethod(Keys, "for an anamap",
              [IsANAMap and IsANAMapListRep],
              map -> BoundPositions(map![1])
             );

InstallMethod(Values, "for an anamap",
              [IsANAMap and IsANAMapListRep],
function(map)
    local res, p, q, m;
    m := map![1];
    res := [];
    for p in BoundPositions(m) do
        for q in BoundPositions(m[p]) do
            Add(res, [p,q,m[p][q]]);
        od;
    od;
    return res;
end);


# this is essentially useless
InstallMethod(Merge, "for an anamap",
              [IsANAMap and IsANAMapListRep, IsANAMap and IsANAMapListRep],
function(map1, map2)
    local p, l, res;

    for p in BoundPositions(map2![1]) do
        if not IsBound(map1![1][p]) then
            map1![1][p] := map2![1][p];
        else
            for l in BoundPositions(map2![1][p]) do
                if IsBound(map1![1][p][l]) and
                   (map1![1][p][l] <= map2![1][p][l]) then
                    continue;
                fi;
                map1![1][p][l] := map2![1][p][l];
            od;
        fi;
    od;
    return map1;
end);

InstallMethod(ViewString, "for an anamap",
              [IsANAMap],
function(map)
    return STRINGIFY("<an anamap with "
                    , Length(BoundPositions(map![1]))
                    , " bound positions>");
end);

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

InstallGlobalFunction( IndexMinEnter,
function(idx, key, value)
    local i, it;

    it := idx;
    for i in key do
        if not IsBound(it[i]) then
            it[i] := [];
        fi;
        it := it[i];
    od;

    if it = [] then
        it[1] := value;
    else
        it[1] := Minimum(it[1], value);
    fi;
end);

InstallGlobalFunction( EnterAllSubwords,
function(idx, word, value)
    local i, pos, ww;
    pos := [1..Length(word)];
    ww := List(word, x -> __ID(x));
    for i in pos do
        IndexMinEnter(idx, ww{ CyclicSubList(pos, i, 3) }, value);
    od;
end);
