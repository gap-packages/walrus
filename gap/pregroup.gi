#
# anatph: A new approach to proving hyperbolicity
#
# Pregroup code
#

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

InstallMethod(ViewString
             , "for a pregroup in table rep"
             , [IsPregroupTableRep],
function(pg)
    return STRINGIFY("<pregroup with ", Size(pg), " elements in table rep>");
end);

InstallMethod(Size
             , "for a pregroup in table rep"
             , [IsPregroupTableRep],
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

InstallMethod(IntermultMapIDs
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

#
# Pregroup elements
#
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

# Takes two groups, and builds the pregroup underlying the free product of
# these two groups amalgamating the third one.
#
# don't try using this on large groups.
#
#T provide embedding alm -> G1,G2 for amalgamation?
#T at the moment we do not almagamate at all
InstallGlobalFunction(PregroupFromFreeProduct,
function(G1, G2, alm)
    local e1, e2, sgp, tbl, elts, nelts, a, b,
          pa, pb, s1p, s2p, pr, sgpi, s1pi,
          s2pi, sgpp, eltn       # Names for elements
    ;

    # Subgroup of G1 and G2 that we amalgamate
    sgpp := [()];
    sgp := [[1,()]];
    #List(Elements(alm), x -> [1,x]);
    s1p := List(Difference(Elements(G1), sgpp), x -> [2,x]);
    s2p := List(Difference(Elements(G2), sgpp), x -> [3,x]);
    elts := Concatenation(sgp,s1p,s2p);
    eltn := List(elts, x -> ViewString(x));

    nelts := Length(elts);

    tbl := List([1..nelts], x -> [1..nelts] * 0);

    for pa in [1..nelts] do
        for pb in [1..nelts] do
            a := elts[pa];
            b := elts[pb];

            if a[1] = b[1] then
                pr := Position(elts, [a[1], a[2] * b[2]]);
		            if pr = fail then
			              pr := Position(elts, [1, a[2] * b[2]]);
		            fi;
            elif (a[1] = 1 and b[1] = 2) or
                 (a[1] = 2 and b[1] = 1) then
                pr := Position(elts, [2, a[2] * b[2]]);
                if pr = fail then
                    pr := Position(elts, [1, a[2] * b[2]]);
                fi;
            elif (a[1] = 1 and b[1] = 3) or
                 (a[1] = 3 and b[1] = 1) then
                pr := Position(elts, [3, a[2] * b[2]]);
                if pr = fail then
                    pr := Position(elts, [1, a[2] * b[2]]);
                fi;
            else
                pr := 0;
            fi;
	          if pr = fail then
		            Error("Could not determine product of ", a, " and ", b, ".\n");
	          fi;
            tbl[pa][pb] := pr;
        od;
    od;
    return PregroupByTable(eltn, tbl);
end);

InstallGlobalFunction(PregroupOfFreeGroup,
function(n)
    local i, tbl, eltn, invs;

    eltn := ["1"];
    invs := ();
    tbl := NullMat(2*n + 1, 2*n + 1);
    tbl[1][1] := 1;
    for i in [1..n] do
        invs := invs * (2*i, 2*i + 1);
        eltn[2*i] := Concatenation("x",String(i));
        eltn[2*i + 1] := Concatenation("X",String(i));
        tbl[1][2*i] := 2*i;
        tbl[1][2*i + 1] := 2*i + 1;
        tbl[2*i][1] := 2*i;
        tbl[2*i+1][1] := 2*i + 1;
        tbl[2*i][2*i+1] := 1;
        tbl[2*i+1][2*i] := 1;
    od;
    return PregroupByTable(eltn, x -> x^invs, tbl);
end);

    


