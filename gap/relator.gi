#
# walrus: Computational Methods for Finitely Generated Monoids and Groups
#

InstallGlobalFunction(NewPregroupWord,
function(pg, word)
    local maxk, rel;
    maxk := MaxPowerK(word);
    return Objectify(IsPregroupRelatorType,
                     rec( pregroup := pg
                        , base := maxk[1]
                        , exponent := maxk[2]
                        , baselen := Length(maxk[1]) ) );
end);

InstallGlobalFunction(NewPregroupRelator,
function(pres, word, id)
    local maxk, rel;
    maxk := MaxPowerK(word);
    rel := Objectify(IsPregroupRelatorType,
                     rec( pres := pres
                        , base := maxk[1]
                        , exponent := maxk[2]
                        , baselen := Length(maxk[1])
                        , __ID := id)
                    );
    return rel;
end);

InstallMethod(Base, "for a pregroup relator",
              [IsPregroupRelator and IsPregroupRelatorRep ],
              r -> r!.base);

InstallMethod(Exponent, "for a pregroup relator",
              [IsPregroupRelator and IsPregroupRelatorRep ],
              r -> r!.exponent);

InstallMethod(Inverse, "for a pregroup relator",
              [ IsPregroupRelator and IsPregroupRelatorRep ],
              r -> Objectify(IsPregroupRelatorType,
                             rec( pres := r!.pres
                                , base := List(Reversed(r!.base), PregroupInverse)
                                , exponent := r!.exponent
                                , baselen := r!.baselen
                                , __ID := -r!.__ID)
                            ));
InstallMethod(PregroupPresentationOf,
              "for pregroup relators",
              [IsPregroupRelator],
              r -> r!.pres);

InstallMethod(Locations, "for a pregroup relator",
              [IsPregroupRelator],
function(r)
    return List([1..r!.baselen], i -> NewLocation(r, i));
end);

InstallMethod(\[\], "for a pregroup relator",
              [IsPregroupRelator and IsPregroupRelatorRep, IsInt],
function(r, p)
    local i, l;
    i := RemInt(p - 1, r!.baselen);
    if i < 0 then
        i := i + r!.baselen;
    fi;
    return r!.base[i + 1];
end);

InstallMethod(Length, "for a pregroup relator",
    [ IsPregroupRelator and IsPregroupRelatorRep ],
function(r)
    return r!.baselen * r!.exponent;
end);

# we could possibly store this on creation
# But this is run at most once anyway
InstallMethod(Places, "for a pregroup relator",
              [ IsPregroupRelator and IsPregroupRelatorRep ],
function(r)
    local P, res;

    res := [];

    for P in Places(PregroupPresentationOf(r)) do
        if Relator(P) = r then
            Add(res, P);
        fi;
    od;
    return res;
end);

InstallMethod(ViewString, "for a pregroup relator",
    [IsPregroupRelator],
function(r)
    if Exponent(r) > 1 then
        return STRINGIFY("<pregroup relator ("
                        , List(r!.base, ViewString)
                        , ")^", r!.exponent, ">");
    else
        return STRINGIFY("<pregroup relator "
                        , List(r!.base, ViewString)
                        , ">");
    fi;
end);

InstallMethod(IsBound\[\], "for a pregroup relator, and an position",
              [IsPregroupRelator, IsInt], ReturnTrue );


InstallMethod(\=, "for a pregroup relator, and a pregroup relator",
              [IsPregroupRelator, IsPregroupRelator],
function(l,r)
    # id is uniqe wrt pregroup presentation. We should probably
    # make a family of relators for each presentation etc
    return l!.__ID = r!.__ID;
    return (l!.exponent = r!.exponent)
           and (l!.base = r!.base);
end);

InstallMethod(\in, "for a generator and a pregroup relator",
              [ IsElementOfPregroup, IsPregroupRelator and IsPregroupRelatorRep],
function(e,r)
    return e in r!.base;
end);

#T redo and move to pregroup files
InstallGlobalFunction(ReduceUPregroupWord,
function(word)
    local rw, rw2, i, j, one;

    if Length(word) = 0 then
        return [];
    fi;

    one := PregroupOf(word[1])[1];
    rw := ShallowCopy(word);

    for i in [2..Length(rw)] do
        if rw[i-1] * rw[i] <> fail then
            rw[i] := rw[i-1] * rw[i];
            rw[i-1] := one;
        fi;
    od;

    i := 1; j := 1;
    rw2 := [];
    while i <= Length(rw) do
        if rw[i] <> one then
            rw2[j] := rw[i];
            j := j + 1;
        fi;
        i := i + 1;
    od;

    return rw2;
end);


