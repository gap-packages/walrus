#
# anatph: A new approach to proving hyperbolicity
#

InstallGlobalFunction(NewPregroupRelator,
function(pres, word)
    local maxk;
    maxk := MaxPowerK(word);
    return Objectify(IsPregroupRelatorType,
                     rec( pres := pres
                        , base := maxk[1]
                        , exponent := maxk[2] )
                    );
end);

InstallMethod(Base, "for a pregroup relator",
              [IsPregroupRelator],
              r -> r!.base);

InstallMethod(Exponent, "for a pregroup relator",
              [IsPregroupRelator],
              r -> r!.exponent);

InstallMethod(Inverse, "for a pregroup relator",
              [IsPregroupRelator],
              r -> Objectify(IsPregroupRelatorType,
                             rec( pres := r!.pres
                                , base := List(Reversed(r!.base), PregroupInverse)
                                , exponent := r!.exponent )
                            ));

InstallMethod(Presentation,
              "for pregroup relators",
              [IsPregroupRelator],
              r -> r!.pres);

# Cyclic access good?
InstallMethod(\[\], "for a pregroup relator",
              [IsPregroupRelator and IsPregroupRelatorRep, IsPosInt],
function(r, p)
    local i, l;

    i := p - 1;
    l := Length(r!.base);

    return r!.base[ RemInt(i, l) + 1];
end);

InstallMethod(Length, "for a pregroup relator",
    [IsPregroupRelator],
function(r)
    return Length(r!.base) * r!.exponent;
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

InstallMethod(\=, "for a pregroup relator, and a pregroup relator",
              [IsPregroupRelator, IsPregroupRelator],
function(l,r)
    return (l!.base = r!.base) and (l!.exponent = r!.exponent);
end);

InstallMethod(\in, "for a generator and a pregroup relator",
              [ IsElementOfPregroup, IsPregroupRelator and IsPregroupRelatorRep],
function(e,r)
    return e in r!.base;
end);
