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
function(gens, t)

end);

InstallMethod(\[\]
             , "for a pregroup in table rep"
             , [IsPregroupTableRep, IsInt],
function(f,a)
    return Objectify(f!.elt_t, rec( parent := f, elt := a ));
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

InstallMethod(ViewString
             , "for a pregroup element"
             , [IsElementOfPregroupRep],
function(pge)
    if pge!.elt > 0 then
        return String(pge!.parent!.enams[pge!.elt]);
    else
        return "undefined";
    fi;
end);

InstallMethod(\*
             , "for pregroup elements"
             , IsIdenticalObj
             , [IsElementOfPregroupRep, IsElementOfPregroupRep]
             , 0,
function(x,y)
    local pg, r;

    pg := x!.parent;

    r := pg!.table[x!.elt][y!.elt];

    return Objectify(pg!.elt_t, rec( parent := pg, elt := r ));
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

    return Objectify(pg!.elt_t, rec( parent := pg, elt := pg!.inv(a) ) );
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
# or predetermine them
InstallMethod(IsIntermultPair
             , "for pregroup elements"
             , IsIdenticalObj
             , [IsElementOfPregroup, IsElementOfPregroup]
             , 0,
function(a,b)
    local x;

    if a = PregroupInverse(b) then
        return false;
    elif IsDefinedMultiplication(a, b) then
        return true;
    else
        for x in PregroupOf(a) do
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

