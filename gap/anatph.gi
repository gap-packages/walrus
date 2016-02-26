#
# anatph: A new approach to proving hyperbolicity
#
# Implementations
#


# Define a pregroup by giving a list of generator names and
# a (partial) multiplication table
InstallGlobalFunction(PreGroupByTableNC,
function(enams, inv, table)
    local r;

    r := rec( enams := enams
            , inv := inv
            , table := table );
    r.fam := NewFamily( "PreGroupElementsFamily", IsElementOfPreGroup );
    r.elt_t := NewType( r!.fam, IsElementOfPreGroupRep );

    return Objectify(PreGroupByTableType, r);
end);

InstallGlobalFunction(PreGroupByTable,
function(gens, t)

end);

InstallMethod(\[\]
             , "for a pregroup in table rep"
             , [IsPreGroupTableRep, IsInt],
function(f,a)
    return Objectify(f!.elt_t, rec( parent := f, elt := a ));
end);

InstallMethod(ViewString
             , "for a pregroup in table rep"
             , [IsPreGroupTableRep],
function(pg)
    return STRINGIFY("<pregroup with ", Length(pg!.enams), " elements in table rep>");
end);

InstallMethod(ViewString
             , "for a pregroup element"
             , [IsElementOfPreGroupRep],
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
             , [IsElementOfPreGroup, IsElementOfPreGroup]
             , 0,
function(x,y)
    local pg, r;

    pg := x!.parent;

    r := pg!.table[x!.elt][y!.elt];

    return Objectify(pg!.elt_t, rec( parent := pg, elt := r ));
end);

