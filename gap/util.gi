#
# anatph: A new approach to proving hyperbolicity
#
#### Utility functions
# MaxPowerK: Input a word (relator) v over X, output w such that w^k = v, k maximal with this property
InstallGlobalFunction(MaxPowerK,
function(rel)
    local len, d, divs, isrep,
          checkrep;

    len := Length(rel);
    divs := ShallowCopy(DivisorsInt(len));
    Remove(divs, 1);

    checkrep := function(d)
        local j,k;
        for j in [1..d] do
            for k in [1..(len / d) - 1] do
                if rel[j] <> rel[j + k*d] then
                    return false;
                fi;
            od;
        od;
        return true;
    end;

    for d in divs do
        if checkrep(d) then
            return [ rel{[1..d]}, len / d ];
        fi;
    od;

    return [ rel, 1 ];
end);

InstallGlobalFunction(MaxPowerK2,
function(rel)
    local len, divs, checkrep, w, k, d, r;

    len := Length(rel);
    divs := Reversed(DivisorsInt(len));
    Remove(divs,1);

    checkrep := function(d)
        local j,k;
        for j in [1..d] do
            for k in [1..(len / d) - 1] do
                if rel[j] <> rel[j + k*d] then
                    return false;
                fi;
            od;
        od;
        return true;
    end;

    w := rel;
    k := divs[1];

    for d in divs do
        if not checkrep(d) then
            return [w,k];
        else
            r := MaxPowerK(w{[1..d]});
            k := k * r[2];
            w := r[1];
        fi;
    od;
end);

InstallGlobalFunction(AnatphTestStandard,
function()
    List(DirectoriesPackageLibrary("anatph", "tst/standard"), TestDirectory);
end);

#
# We make a string right away so we do not have to install awkward
# Print/View methods for relators, and we have full control over
# what we print for KBMAG
#
#T Put pregroup relations in (if pregroup is not the pregroup of the free group)
#T Choose sensible generator names and print them (maybe just use x1,x2,... or a,b,c))
InstallGlobalFunction(PregroupPresentationToKBMAG,
function(pres)
    local res, eqns, preqn;

    preqn := function(rel)
        return Concatenation( "[ "
                            , JoinStringsWithSeparator(List(rel, String), "*")
                            , ", IdWord ]");
    end;

    eqns := JoinStringsWithSeparator(List(Relators(pres), preqn), ",");

    res := Concatenation(
               "_RWS := rec(\n"
             , "   isRWS := true,\n"
             , "   ordering := \"shortlex\",\n"
             , "   generatorOrder := ", PrintString(Generators(pres)), ",\n"
             , "   inverses := ", PrintString(List(Generators(pres), PregroupInverse)), ",\n"
             , "   equations := [ ", eqns, "]"
             , " );");
    return res;
end);

# Writes out pregroup as a multiplication table
# and then the relators
InstallGlobalFunction(PregroupPresentationToStream,
function(pres, stream)
    local row, col, table, n, i, rel;

    table := MultiplicationTableIDs(Pregroup(pres));
    n := Length(table);
    AppendTo(stream, "pregroup:\n" );

    for row in [1..n] do
        AppendTo(stream, "  ");
        for col in [1..n-1] do
            AppendTo(stream, String(table[row][col]));
            AppendTo(stream, " ");
        od;
        AppendTo(stream, String(table[row][n]));
        AppendTo(stream, "\n");
    od;

    AppendTo(stream, "relators:\n");
    for rel in Relators(pres) do
        AppendTo(stream, "  ");
        for i in [1..Length(rel)-1] do
            AppendTo(stream, String(__ID(rel[i])));
            AppendTo(stream, " ");
        od;
        AppendTo(stream, String(__ID(rel[Length(rel)])));
        AppendTo(stream, "\n");
    od;
end);

InstallGlobalFunction(PregroupPresentationFromStream,
function(pres, stream)

end);

