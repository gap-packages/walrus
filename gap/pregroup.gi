#
# anatph: A new approach to proving hyperbolicity
#
# Pregroup code
#

# Define a pregroup by giving a list of generator names and
# a (partial) multiplication table
InstallGlobalFunction(PregroupByTableNC,
function(enams, inv, table)
    local r;

    r := rec( enams := enams
            , inv := inv
            , table := table );
    r.fam := NewFamily( "PregroupElementsFamily", IsElementOfPregroup );
    r.elt_t := NewType( r!.fam, IsElementOfPregroupRep );

    return Objectify(PregroupByTableType, r);
end);

InstallGlobalFunction(PregroupByTable,
function(enams, inv, table)
    local nels, row, e, f, g, h;

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
    return Objectify(f!.elt_t, rec( parent := f, elt := a ));
end);

InstallMethod(Iterator
             , "for a pregroup"
             , [IsPregroupTableRep],
function(pgp)
    local r;

    r := rec( pgp := pgp
            , pos := 0
            , NextIterator := function(iter)
                if iter!.pos < Size(iter!.pgp) then
                    iter!.pos := iter!.pos + 1;
                    return iter!.pgp[iter!.pos];
                else
                    return fail;
                fi;
            end
            , IsDoneIterator := iter -> iter!.pos = Size(iter!.pgp)
            , ShallowCopy := iter -> rec( pgp := iter!.pgp, pos := iter!.pos )
            );

    return IteratorByFunctions(r);
end);

InstallMethod(ViewString
             , "for a pregroup in table rep"
             , [IsPregroupTableRep],
function(pg)
    return STRINGIFY("<pregroup with ", Length(pg!.enams), " elements in table rep>");
end);

InstallMethod(Size
             , "for a pregroup in table rep"
             , [IsPregroupTableRep],
function(pg)
    return Length(pg!.enams);
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
    for i in [2..Length(pg!.enams)] do
        for j in [2..Length(pg!.enams)] do
            if (i <> pg!.inv(j)) then
                if (pg!.table[i][j] > 0) then
                    Add(pairs, [pg[i],pg[j]]);
                else
                    for k in [2..Length(pg!.enams)] do
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

InstallMethod(IntermultPairsIds
             , "for a pregroup in table rep"
             , [IsPregroupTableRep],
function(pg)
    local i, j, k, pairs;

    pairs := [];
    for i in [2..Length(pg!.enams)] do
        for j in [2..Length(pg!.enams)] do
            if (i <> pg!.inv(j)) then
                if (pg!.table[i][j] > 0) then
                    Add(pairs, [i,j]);
                else
                    for k in [2..Length(pg!.enams)] do
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

InstallMethod(IntermultMap
             , "for a pregroup in table rep"
             , [IsPregroupTableRep],
function(pg)
    local i, j, k, map;

    map := [];
    for i in [1..Size(pg)] do
        map[i] := [];
    od;

    for i in [2..Length(pg!.enams)] do
        for j in [2..Length(pg!.enams)] do
            if (i <> pg!.inv(j)) then
                if (pg!.table[i][j] > 0) then
                    Add(map[i], j);
                else
                    for k in [2..Length(pg!.enams)] do
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

#
# Pregroup elements
#
InstallMethod(ViewString
             , "for a pregroup element"
             , [IsElementOfPregroupRep],
function(pge)
    if pge!.elt > 0 then
        return pge!.parent!.enams[pge!.elt];
    else
        return "undefined";
    fi;
end);

InstallMethod(String
             , "for a pregroup element"
             , [IsElementOfPregroupRep],
function(pge)
    if pge!.elt > 0 then
        return pge!.parent!.enams[pge!.elt];
    else
        return "undefined";
    fi;
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
        return Objectify(pg!.elt_t, rec( parent := pg, elt := r ));
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
function(a)
    local pg;

    pg := PregroupOf(a);

    return Objectify(pg!.elt_t, rec( parent := pg, elt := pg!.inv(a!.elt) ) );
end);

InstallMethod(PregroupElementId
             , "for pregroup elements"
             , [ IsElementOfPregroupRep]
             , 0,
function(a)
    return a!.elt;
end);

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
