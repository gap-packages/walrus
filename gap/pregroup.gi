#
# anatph: A new approach to proving hyperbolicity
#
# Implementations
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
             , [IsElementOfPregroup, IsElementOfPregroup]
             , 0,
function(x,y)
    local pg, r;

    pg := x!.parent;

    r := pg!.table[x!.elt][y!.elt];

    return Objectify(pg!.elt_t, rec( parent := pg, elt := r ));
end);


InstallMethod(IsDefinedMultiplication
             , "for pregroup elements"
             , IsIdenticalObj
             , [IsElementOfPregroup, IsElementOfPregroup]
             , 0,
function(a,b)
    local pg;
    
    pg := x!.parent;
    
    if pg!.table[x!.elt][  ]
end);

InstallMethod(IsIntermultPair
             , "for pregroup elements"
             , IsIdenticalObj
             , [IsElementOfPregroup, IsElementOfPregroup]
             , 0,
function(a,b)
    local x;

    if a = Sigma(b) then
        return false;
    elif a * b <> fail then
        return true;
    else
        for x in Pregroup(a) do
            if (a * x <> fail) and (x^(-1) * b <> fail) then
                return true;
            fi;
        od;
        return false;
    fi;
    # Should not be reached
    Error("This shouldn't happen.");
end);



