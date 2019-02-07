

# Define a pregroup by giving a list of generator names and
# a (partial) multiplication table
InstallGlobalFunction(PregroupByTableNC,
function(enams, inv, table)
    local r,e;

    r := rec( PregroupElementNames := enams
            , inv := inv
            , table := table );
    r.fam := NewFamily( "PregroupElementsFamily", IsElementOfPregroup );
    r.elt_t := NewType( r!.fam, IsElementOfPregroupRep );
    r.wfam := NewFamily( "PregroupWordFamily", IsPregroupWord );
    r.word_t := NewType( r!.wfam, IsPregroupWordListRep );
    r.elts := List( [1..Length(table)], i -> Objectify(r.elt_t, rec(parent := r, elt := i)));
    r.invs := [];
    for e in [1..Length(r.elts)] do
        r.elts[e]!.inv := r.elts[inv(e)];
    od;
    Objectify(PregroupByTableType, r);
    SetPregroupElementNames(r, enams);
    return r;
end);

InstallGlobalFunction(PregroupInversesFromTable,
function(table)
    local i,j,inv;

    inv := [];
    for i in [1..Length(table)] do
        for j in [1..Length(table[i])] do
            if table[i][j] = 1 then
                if IsBound(inv[i]) then
                    if inv[i] <> j then
                        Error("inverses not well-defined");
                    fi;
                else
                    inv[i] := j;
                fi;
            fi;
        od;
    od;
    inv := PermList(inv);
    if inv = fail then
        Error("inverses not well-defined");
    fi;
    return x -> x^inv;
end);

InstallGlobalFunction(PregroupByTable,
function(enams, table)
    local nels, inv, row, e, f, g, h;

    # We assume that the length of the list of
    # element names is the number of elements
    nels := Length(enams);

    if Length(table) <> nels then
        Error("PregroupByTable: Length of enams does not match number of rows in table");
    fi;
    for row in table do
        if Length(row) <> nels then
            Error("PregroupByTable: Multiplication table is not square");
        fi;
        for e in row do
            if (not IsInt(e)) or (e < 0) or (e > nels) then
                Error("PregroupByTable: Table entry ", e, " is invalid, needs to be an integer between 0 and ", nels);
            fi;
        od;
    od;

    inv := PregroupInversesFromTable(table);
    for e in [1..nels] do
        if inv(inv(e)) <> e then
            Error("PregroupByTable: inv needs to be an involution");
        fi;
    od;
    for e in [1..nels] do
        if (table[1][e] <> e) or (table[e][1] <> e) then
            Error("PregroupByTable: ",e,"*1 = ", e, " or 1*", e, " = ", e, " not satisfied");
        fi;
        if (table[e][inv(e)] <> 1) or (table[inv(e)][e] <> 1) then
            Error("PregroupByTable: inverses");
        fi;
    od;

    for e in [1..nels] do
        for f in [1..nels] do
            for g in [1..nels] do
                if table[e][f] > 0 and table[f][g] > 0 then
                    if (table[table[e][f]][g] = 0 and table[e][table[f][g]] > 0) or
                       (table[table[e][f]][g] > 0 and table[e][table[f][g]] = 0) then
                        Error("PregroupByTable: associativity");
                    fi;
                fi;
            od;
        od;
    od;

    for e in [1..nels] do
        for f in [1..nels] do
            if table[e][f] > 0 then
                for g in [1..nels] do
                    if table[f][g] > 0 then
                        for h in [1..nels] do
                            if table[g][h] > 0 then
                                if table[table[e][f]][g] = 0 and table[table[f][g]][h] = 0 then
                                    Error("PregroupByTable: P5 violated");
                                fi;
                            fi;
                        od;
                    fi;
                od;
            fi;
        od;
    od;
    return PregroupByTableNC(enams, inv, table);
end);

InstallMethod(\[\]
             , "for a pregroup in table rep"
             , [IsPregroupTableRep, IsInt],
function(f,a)
    return f!.elts[a];
end);

InstallMethod(Iterator
             , "for a pregroup"
             , [IsPregroupTableRep],
function(pgp)
    local r;

    r := rec( pgp := pgp
            , pos := 0
            , length := Size(pgp)
            , NextIterator := function(iter)
                if iter!.pos < iter!.length then
                    iter!.pos := iter!.pos + 1;
                    return iter!.pgp[iter!.pos];
                else
                    return fail;
                fi;
            end
            , IsDoneIterator := iter -> iter!.pos = iter!.length
            , ShallowCopy := iter -> rec( pgp := iter!.pgp, pos := iter!.pos )
            );

    return IteratorByFunctions(r);
end);

InstallMethod(PregroupElementNames
             , "for a pregroup"
             , [IsPregroupTableRep]
             , p -> p!.elementnames );

InstallMethod(SetPregroupElementNames
             , "for a pregroup"
             , [IsPregroupTableRep, IsList]
             , function(p, n)
                 p!.elementnames := n;
             end );

InstallMethod(ViewString
             , "for a pregroup in table rep"
             , [IsPregroupTableRep],
function(pg)
    return STRINGIFY("<pregroup with ", Size(pg), " elements in table rep>");
end);

InstallMethod(Size
             , "for a pregroup in table rep"
             , [IsPregroup and IsPregroupTableRep],
function(pg)
    return Length(pg!.elts);
end);

#XXX at the moment [1,x] and [x,1] intermult, but I don't think
#    this is really needed?
#XXX Intermult is only defined for elements other than 1
InstallMethod(IntermultPairs
             , "for a pregroup in table rep"
             , [IsPregroupTableRep],
function(pg)
    local i, j, k, pairs;

    pairs := [];
    for i in [2..Size(pg)] do
        for j in [2..Size(pg)] do
            if (i <> pg!.inv(j)) then
                if (pg!.table[i][j] > 0) then
                    Add(pairs, [pg[i],pg[j]]);
                else
                    for k in [2..Size(pg)] do
                        if (pg!.table[i][k] > 0) and
                           (pg!.table[pg!.inv(k)][j] > 0) then
                            Add(pairs, [pg[i],pg[j]]);
                            break;
                        fi;
                    od;
                fi;
            fi;
        od;
    od;
    return pairs;
end);

InstallMethod(IntermultPairsIDs
             , "for a pregroup in table rep"
             , [IsPregroupTableRep],
function(pg)
    local i, j, k, pairs;

    pairs := [];
    for i in [2..Size(pg)] do
        for j in [2..Size(pg)] do
            if (i <> pg!.inv(j)) then
                if (pg!.table[i][j] > 0) then
                    Add(pairs, [i,j]);
                else
                    for k in [2..Size(pg)] do
                        if (pg!.table[i][k] > 0) and
                           (pg!.table[pg!.inv(k)][j] > 0) then
                            Add(pairs, [i,j]);
                            break;
                        fi;
                    od;
                fi;
            fi;
        od;
    od;
    return pairs;
end);


InstallMethod(IntermultMapIDs
             , "for a pregroup in table rep"
             , [IsPregroupTableRep],
function(pg)
    local i, j, k, map;

    map := [];
    for i in [1..Size(pg)] do
        map[i] := [];
    od;

    for i in [2..Size(pg)] do
        for j in [2..Size(pg)] do
            if (i <> pg!.inv(j)) then
                if (pg!.table[i][j] > 0) then
                    Add(map[i], j);
                else
                    for k in [2..Size(pg)] do
                        if (pg!.table[i][k] > 0) and
                           (pg!.table[pg!.inv(k)][j] > 0) then
                            Add(map[i],j);
                            break;
                        fi;
                    od;
                fi;
            fi;
        od;
    od;
    return map;
end);

InstallMethod(IntermultMap
             , "for a pregroup in table rep"
             , [IsPregroupTableRep],
function(pg)
    return List(IntermultMapIDs(pg), x -> List(x, i -> pg[i]));
end);

InstallMethod(IntermultTable
             , "for a pregroup in table rep"
             , [IsPregroupTableRep],
function(pg)
    local i, j, k, map;

    map := [];
    for i in [1..Size(pg)] do
        map[i] := [false];
    od;

    for i in [2..Size(pg)] do
        for j in [2..Size(pg)] do
            map[i][j] := false;
            if (i <> pg!.inv(j)) then
                if (pg!.table[i][j] > 0) then
                    map[i][j] := true;
                else
                    for k in [2..Size(pg)] do
                        if (pg!.table[i][k] > 0) and
                          (pg!.table[pg!.inv(k)][j] > 0) then
                            map[i][j] := true;
                            break;
                        fi;
                    od;
                fi;
            fi;
        od;
    od;
    return map;
end);

InstallMethod(One, "for a pregroup",
              [IsPregroup],
              pg -> pg!.elts[1]);

# This is very inefficient, but I don't care at the moment
InstallMethod(MultiplicationTableIDs,
              "for a pregroup",
              [IsPregroup],
function(pg)
    local i, j, table;

    table := [];
    for i in [1..Size(pg)] do
        table[i] := [];
        for j in [1..Size(pg)] do
            table[i][j] := pg[i] * pg[j];
            if table[i][j] = fail then
                table[i][j] := 0;
            else
                table[i][j] := __ID(table[i][j]);
            fi;
        od;
    od;
    return table;
end);

InstallMethod(MultiplicationTable,
              "for a pregroup",
              [IsPregroup],
function(pg)
    local i, j, table;

    table := [];
    for i in [1..Size(pg)] do
        table[i] := [];
        for j in [1..Size(pg)] do
            table[i][j] := pg[i] * pg[j];
        od;
    od;
    return table;
end);

#
# Pregroup elements
#
InstallMethod(IntermultMap
             , "for a pregroup element"
             , [IsElementOfPregroupRep],
function(pge)
    return IntermultMap(pge!.parent)[__ID(pge)];
end);

InstallMethod(ViewString
             , "for a pregroup element"
             , [IsElementOfPregroupRep],
function(pge)
    if pge!.elt > 0 then
        return PregroupElementNames(pge!.parent)[pge!.elt];
    else
        return "undefined";
    fi;
end);

InstallMethod(String
             , "for a pregroup element"
             , [IsElementOfPregroupRep],
function(pge)
    if pge!.elt > 0 then
        return PregroupElementNames(pge!.parent)[pge!.elt];
    else
        return "undefined";
    fi;
end);

InstallMethod(InverseOp
             , "for a pregroup element"
             , [IsElementOfPregroupRep]
             , 0,
function(x)
    return PregroupInverse(x);
end);

#XXX Is fail as a result for multiplication acceptable?
InstallMethod(\*
             , "for pregroup elements"
             , IsIdenticalObj
             , [IsElementOfPregroupRep, IsElementOfPregroupRep]
             , 0,
function(x,y)
    local pg, r;

    pg := x!.parent;

    r := pg!.table[x!.elt][y!.elt];

    if r > 0 then
        return pg!.elts[r];
    else
        return fail;
    fi;
end);

InstallMethod(\=
             , "for pregroup elements"
             , IsIdenticalObj
             , [IsElementOfPregroupRep, IsElementOfPregroupRep]
             , 0,
function(x,y)
    return x!.elt = y!.elt;
end);

# Artificial ordering on pregroup to make sets work
InstallMethod(\<
             , "for pregroup elements"
             , IsIdenticalObj
             , [ IsElementOfPregroupRep, IsElementOfPregroupRep]
             , 0,
function(x,y)
    return x!.elt < y!.elt;
end);

InstallMethod(PregroupOf
             , "for pregroup elements"
             , [ IsElementOfPregroupRep ]
             , 0,
function(a)
    return a!.parent;
end);

InstallMethod(PregroupInverse
             , "for pregroup elements"
             , [ IsElementOfPregroupRep ]
             , 0,
             a -> a!.inv);

InstallMethod(PregroupElementId
             , "for pregroup elements"
             , [ IsElementOfPregroupRep]
             , 0,
             a -> a!.elt);

InstallMethod(__ID
             , "for pregroup elements"
             , [IsElementOfPregroup]
             , 0,
             x -> x!.elt);

InstallMethod(IsDefinedMultiplication
             , "for pregroup elements"
             , IsIdenticalObj
             , [IsElementOfPregroup, IsElementOfPregroup]
             , 0,
function(a,b)
    local pg;

    pg := PregroupOf(a);

    return pg!.table[a!.elt][b!.elt] > 0;
end);

# We could cache intermult pairs,
# or predetermine them, depending
# on the number of intermult lookups
# that could benefit runtime
InstallMethod(IsIntermultPair
             , "for pregroup elements"
             , IsIdenticalObj
             , [IsElementOfPregroup, IsElementOfPregroup]
             , 0,
function(a,b)
    local x, nontriv;

    return IntermultTable(a!.parent)[__ID(a)][__ID(b)];

    if a = PregroupInverse(b) then
        return false;
    elif IsDefinedMultiplication(a, b) then
        return true;
    else
        nontriv := List(PregroupOf(a), x -> x);
        Remove(nontriv, 1);
        for x in nontriv do
            if IsDefinedMultiplication(a,x)
               and IsDefinedMultiplication(PregroupInverse(x), b) then
                return true;
            fi;
        od;
        return false;
    fi;
    # Should not be reached
    Error("This shouldn't happen.");
end);

