#
# anatph: A new approach to proving hyperbolicity
#

## Presentations
InstallGlobalFunction(NewPregroupPresentation,
function(pg, rels)
    local res;
    res := rec();
    res.pg := pg;
    res.rels := List(rels, x -> NewPregroupRelator(res, x));
    return Objectify(IsPregroupPresentationType, res);
end);

InstallMethod(ViewString
             , "for a pregroup presentation"
             , [IsPregroupPresentationRep],
function(pgp)
    # Note that we do not really regard 1 as a generator
    local res;

    return STRINGIFY("<pregroup presentation with "
                    , Size(pgp!.pg)-1, " generators and "
                    , Length(pgp!.rels), " relators>");
end);

InstallMethod(Pregroup
             , "for a pregroup presentation"
             , [IsPregroupPresentation],
             pgp -> pgp!.pg);

InstallMethod(Generators
             , "for a pregroup presentation"
             , [IsPregroupPresentation],
function(pres)
    local gens;

    gens := List(Pregroup(pres), x->x);
    Remove(gens, 1);
    return gens;
end);

InstallMethod(Relators
             , "for a pregroup presentation"
             , [IsPregroupPresentation],
             pgp -> pgp!.rels);

InstallMethod(RelatorsAndInverses
             , "for a pregroup presentation"
             , [IsPregroupPresentation],
function(pgp)
    local r;
    r := Relators(pgp);
    return Concatenation(r, List(r, Inverse));
end);

InstallMethod(Powers
             , "for a pregroup presentation"
             , [IsPregroupPresentation],
             x -> x!.powers);

InstallMethod(RLetters
             , "for a pregroup presentation"
             , [IsPregroupPresentation],
function(pres)
    local rels, gens, x, r, rlett;

    rels := Relators(pres);
    gens := Generators(pres);
    rlett := Set([]);
    for r in rels do
        for x in gens do
            if x in r then AddSet(rlett, x); fi;
        od;
    od;
    return rlett;
end);

InstallMethod(Locations, "for a pregroup presentation",
              [IsPregroupPresentation and IsPregroupPresentationRep],
function(pres)
    local rel, locs, w, i;

    locs := [];
    for rel in RelatorsAndInverses(pres) do
        w := Base(rel);
        Add(locs, NewLocation(rel, 1, w[Length(w)], w[1]));
        Append(locs, List([2..Length(w)], i -> NewLocation(rel, i, w[i-1], w[i])));
    od;

    # Hack
    for i in [1..Length(locs)] do
        locs[i]![5] := i;
    od;
    return locs;
end);

# Given a pregroup presentation as the input, find all places

# B is true if a place will always occur on the boundary
InstallMethod(Places, "for a pregroup presentation",
              [IsPregroupPresentation and IsPregroupPresentationRep],
function(pres)
    local loc, loc2,
          places, a, b, c,
          rels,
          locs, i;

    rels := Relators(pres);
    locs := Locations(pres);
    places := [];

    for loc in locs do
        a := InLetter(loc);
        b := OutLetter(loc);
        for c in Generators(pres) do
            # Colour is "red"
            if IsIntermultPair(PregroupInverse(b), c) then
                if IsRLetter(pres, c) then
                    Add(places, NewPlace(loc, c, "red", false));
                else
                    Add(places, NewPlace(loc, c, "red", true));
                fi;
            fi;
            # Colour is "green"
            # find location R'.
            for loc2 in locs do
                if InLetter(loc2) = PregroupInverse(b) and OutLetter(loc2) = c then
                    # Is this really just checking that rel starting at b is
                    # not equal to rel2
                    if CheckReducedDiagram(loc, loc2) then
                        Add(places, NewPlace(loc, c, "green", true));
                    else
                        Add(places, NewPlace(loc, c, "green", false));
                    fi;
                fi;
            od;
        od;
    od;
    # Hack
    for i in [1..Length(places)] do
        places[i]![5] := i;
    od;
    return places;
end);

InstallMethod(LengthLongestRelator, "for a pregroup presentation",
              [IsPregroupPresentation and IsPregroupPresentationRep],
function(pres)
    return Maximum(List(Relators(pres), Length));
end);

