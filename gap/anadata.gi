
coordinateF := function(ql, key)
    local i, cc, res;
    cc := 1;
    res := 0;
    for i in [1..Length(ql)] do
        res := res + cc * (key[i] - 1);
        cc := cc * ql[i];
    od;
    return res + 1;
end;

InstallGlobalFunction(NewANAMap,
function(pres)
    local res, x, y;

    x := Length(Places(pres));
    y := Maximum(List(Relators(pres), Length));

    res := [];

    res[1] := ListWithIdenticalEntries(x * y + 1, infinity);
    res[2] := [x,y];
    res[3] := [];

    return Objectify(ANAMapListType, res);
end);

# Far from universal of course.
InstallMethod(AddOrUpdate, "for an anamap",
              [IsANAMap and IsANAMapListRep, IsPregroupPlace, IsInt, IsRat ],
function(map, place, length, val)
    local coord, v;

    coord := coordinateF(map![2], [__ID(place), length]);
    v := map![1][coord];
    map![1][coord] := Minimum(v, val);
    if v = infinity then
        AddSet(map![3], [__ID(place), length]);
    fi;
    
#   if IsBound(map![1][__ID(place)]) then
#       if IsBound(map![1][__ID(place)][length]) then
#           if map![1][__ID(place)][length] > val then
#               map![1][__ID(place)][length] := val;
#           fi;
#       else
#           map![1][__ID(place)][length] := val;
#       fi;
#   else
#       map![1][__ID(place)] := [];
#       map![1][__ID(place)][length] := val;
#   fi;
end);


InstallMethod(Keys, "for an anamap",
              [IsANAMap and IsANAMapListRep],
              map -> map![3]
             );

InstallMethod(Values, "for an anamap",
              [IsANAMap and IsANAMapListRep],
function(map)
    Error("not implemented");
end);

InstallMethod(Lookup, "for an anamap",
              [IsANAMap and IsANAMapListRep, IsPregroupPlace, IsInt],
function(map, place, length)
    local coord;

    coord := coordinateF(map![2], [__ID(place), length]);
    return map![1][coord];
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
                    , Length(BoundPositions(map![3]))
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
    local it;

    it := coordinateF(idx[Length(idx)], key);
    idx[it] := Minimum(idx[it], value);
    return;


    it := HTUpdate(idx, key, value);
    if it = fail then
        HTAdd(idx, key, value);
    elif it < value then
        HTUpdate(idx, key, it);
    fi;

    return;

#   it := HTValue(idx, key);
#   if it = fail then
#       HTAdd(idx, k, value);
#   elif value < it then
#       HTUpdate(idx, key, value);
#   fi;
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



