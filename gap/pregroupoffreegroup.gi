#
# Pregroup of free groups is special (at the moment at least)
#
InstallGlobalFunction(PregroupOfFreeGroup,
function(n)
    local i, r, e, inv, enams;

    #T maybe for n <= 26 just use a,b,c,?
    enams := [1..2*n+1];
    for i in [1..n] do
        enams[2 * i] := Concatenation("x", String(i));
        enams[2 * i + 1] := Concatenation("X", String(i));
    od;

    inv := function(x)
        if x = 1 then
            return 1;
        elif IsEvenInt(x) then
            return x + 1;
        else
            return x - 1;
        fi;
    end;

    r := rec( rank := n );

    r.fam := NewFamily( "PregroupElementsFamily", IsElementOfPregroup );
    r.elt_t := NewType( r!.fam, IsElementOfPregroupOfFreeGroupRep );
    r.elts := List( [ 1 .. (2*n + 1) ], i -> Objectify(r.elt_t, rec(parent := r, elt := i)));
    r.invs := [];
    for e in [1..Length(r.elts)] do
        r.elts[e]!.inv := r.elts[inv(e)];
    od;
    Objectify(PregroupOfFreeGroupType, r);
    SetPregroupElementNames(r, enams);
    return r;
end);

InstallMethod(ViewString
             , "for a pregroup of a free group"
             , [IsPregroupOfFreeGroupRep],
             function(pg)
                 return STRINGIFY("<pregroup of free group of rank ", pg!.rank, ">");
             end);

InstallMethod(Size
             , "for a pregroup of a free group"
             , [IsPregroupOfFreeGroupRep],
             pg -> 2 * pg!.rank + 1);

InstallMethod(\[\]
             , "for a pregroup of a free group"
             , [IsPregroupOfFreeGroupRep, IsInt],
             function(f,a)
                 return f!.elts[a];
             end);

InstallMethod(Iterator
             , "for a pregroup of a free group"
             , [IsPregroupOfFreeGroupRep],
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
             , [IsPregroupOfFreeGroupRep]
             , p -> p!.elementnames );

InstallMethod(SetPregroupElementNames
             , "for a pregroup"
             , [IsPregroupOfFreeGroupRep, IsList]
             , function(p, n)
                 p!.elementnames := n;
             end );

InstallMethod(IntermultPairs
             , "for a pregroup in table rep"
             , [IsPregroupOfFreeGroupRep],
             pg -> []);

InstallMethod(IntermultPairsIDs
             , "for a pregroup in table rep"
             , [IsPregroupOfFreeGroupRep],
             pg -> []);

InstallMethod(IntermultMapIDs
             , "for a pregroup in table rep"
             , [IsPregroupOfFreeGroupRep],
             pg -> ListWithIdenticalEntries(Size(pg), []));

InstallMethod(IntermultMap
             , "for a pregroup in table rep"
             , [IsPregroupOfFreeGroupRep],
             pg -> ListWithIdenticalEntries(Size(pg), []));

InstallMethod(One, "for a pregroup",
              [IsPregroupOfFreeGroupRep],
              pg -> pg!.elts[1]);

#
# PregroupOfFreeGroup elements
#
InstallMethod(IntermultMap
             , "for a pregroup element"
             , [IsElementOfPregroupOfFreeGroupRep],
             pge -> []);

InstallMethod(ViewString
             , "for a pregroup element"
             , [IsElementOfPregroupOfFreeGroupRep],
function(pge)
    if pge!.elt > 0 then
        return PregroupElementNames(pge!.parent)[pge!.elt];
    else
        return "undefined";
    fi;
end);

InstallMethod(String
             , "for a pregroup element"
             , [IsElementOfPregroupOfFreeGroupRep],
function(pge)
    if pge!.elt > 0 then
        return PregroupElementNames(pge!.parent)[pge!.elt];
    else
        return "undefined";
    fi;
end);

#XXX Is fail as a result for multiplication acceptable?
InstallMethod(\*
             , "for pregroup elements"
             , IsIdenticalObj
             , [IsElementOfPregroupOfFreeGroupRep, IsElementOfPregroupOfFreeGroupRep]
             , 0,
function(x,y)
    if x!.elt = 1 then
        return y;
    elif y!.elt = 1 then
        return x;
    elif x!.inv = y then
        return One(PregroupOf(x));
    else
        return fail;
    fi;
end);

InstallMethod(\=
             , "for pregroup elements"
             , IsIdenticalObj
             , [IsElementOfPregroupOfFreeGroupRep, IsElementOfPregroupOfFreeGroupRep]
             , 0,
function(x,y)
    return x!.elt = y!.elt;
end);

# Artificial ordering on pregroup to make sets work
InstallMethod(\<
             , "for pregroup elements"
             , IsIdenticalObj
             , [ IsElementOfPregroupOfFreeGroupRep, IsElementOfPregroupOfFreeGroupRep]
             , 0,
function(x,y)
    return x!.elt < y!.elt;
end);

InstallMethod(PregroupOf
             , "for pregroup elements"
             , [ IsElementOfPregroupOfFreeGroupRep ]
             , 0,
function(a)
    return a!.parent;
end);

InstallMethod(PregroupInverse
             , "for pregroup elements"
             , [ IsElementOfPregroupOfFreeGroupRep ]
             , 0,
             a -> a!.inv);

InstallMethod(PregroupElementId
             , "for pregroup elements"
             , [ IsElementOfPregroupOfFreeGroupRep ]
             , 0,
             a -> a!.elt);

InstallMethod(__ID
             , "for pregroup elements"
             , [ IsElementOfPregroupOfFreeGroupRep ]
             , 0,
             x -> x!.elt);

InstallMethod(IsDefinedMultiplication
             , "for pregroup elements"
             , IsIdenticalObj
             , [ IsElementOfPregroupOfFreeGroupRep, IsElementOfPregroupOfFreeGroupRep ]
             , 0,
function(a,b)
    return (a!.elt = 1) or (b!.elt = 1) or (a!.inv = b);
end);

# We could cache intermult pairs,
# or predetermine them, depending
# on the number of intermult lookups
# that could benefit runtime
InstallMethod(IsIntermultPair
             , "for pregroup elements"
             , IsIdenticalObj
             , [IsElementOfPregroupOfFreeGroupRep, IsElementOfPregroupOfFreeGroupRep]
             , 0,
function(a,b)
    return false;
end);

