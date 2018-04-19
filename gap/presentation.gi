#
# anatph: A new approach to proving hyperbolicity
#

## Presentations
InstallGlobalFunction(NewPregroupPresentation,
function(pg, rels)
    local res;

    res := rec( pg := pg );
    res.rels := List([1..Length(rels)], x -> NewPregroupRelator(res, rels[x], x));
    # Orgh. Make sure Locations and Places are all computed for the moment
    Objectify(IsPregroupPresentationType, res);
    Locations(res);
    Places(res);
    SetVertexTripleCache(res, HashMap());

    return res;
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

    rels := RelatorsAndInverses(pres);
    gens := Generators(pres);
    rlett := Set([]);
    for r in rels do
        for x in gens do
            if x in r then AddSet(rlett, x); fi;
        od;
    od;
    return rlett;
end);

# An R-letter is a letter that occurs in any (interleave) of
# a relation (Definition 7.4)
# XXX: Note that the code below does not do interleaves yet!
InstallGlobalFunction(IsRLetter,
function(pres, x)
    # determine whether x occurs in I(R)
    return x in RLetters(pres);
end);

InstallMethod(Locations, "for a pregroup presentation",
              [IsPregroupPresentation and IsPregroupPresentationRep],
function(pres)
    local rel, locs, w, i, index;

    locs := [];

    for rel in RelatorsAndInverses(pres) do
        Append(locs, Locations(rel));
    od;

    # Hack
    # In particular this ID is ID within presentation
    index := HashMap(x -> HashBasic([__ID(x[1]), __ID(x[2])]));
    for i in [1..Length(locs)] do
        locs[i]![6] := i;

        if IsBound( index[ [ InLetter(locs[i]), OutLetter(locs[i]) ] ] ) then
            Add( index[ [ InLetter(locs[i]), OutLetter(locs[i]) ] ], locs[i] );
        else
            index[ [ InLetter(locs[i]), OutLetter(locs[i]) ] ] := [ locs[i] ];
        fi;
    od;
    SetLocationIndex(pres, index);
    return locs;
end);


# For a location R(i,a,b) find a matching location
# R'(j,b^(-1),c) such that a reduced diagram only
# containing R and R' exists
FindMatchingLocation := function(loc, c)
    local locs, b, binv, loc2;

    b := OutLetter(loc);
    binv := PregroupInverse(b);
    locs := LocationIndex(Presentation(loc));
    locs := locs[ [binv, c] ];

    if locs <> fail then
        for loc2 in locs do
            if CheckReducedDiagram(loc, loc2) then
                return loc2;
            fi;
        od;
    fi;
    return fail;
end;

# Given a pregroup presentation as the input, find all places
# B is true if a place will always occur on the boundary
InstallMethod(Places, "for a pregroup presentation",
              [IsPregroupPresentation and IsPregroupPresentationRep],
function(pres)
    local loc, loc2,
          places, a, b, c,
          rels,
          locs, i;

    # rels := RelatorsAndInverses(pres);
    rels := Relators(pres);
    locs := Locations(pres);
    places := [];

    for loc in locs do
        a := InLetter(loc);
        b := OutLetter(loc);
        for c in Generators(pres) do
            # Colour is "red"
            if IsIntermultPair(PregroupInverse(b), c) then
                Add(places, NewPlace(loc, c, "red"));
            fi;
            # Colour is "green"
            # find location R'(j,b^(-1),c) and check that a diagram that
            # meets at the edge b doesn't collapse.

            if FindMatchingLocation(loc, c) <> fail then
                Add(places, NewPlace(loc, c, "green"));
            fi;
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

# Definition 3.3: A diagram is semi-reduced, if no distinct adjacent faces
# are labelled by ww_1 and w_1^{-1}w for a relator ww_1 and have a common
# consolidated edge labelled by w and w^-1
# it is reduced if this also holds for a face incident with itself.
#
# test whether label on Relator(l2) beginning at b^(-1) is equal to inverse
# of label on Relator(l1) ending at b
InstallGlobalFunction(CheckReducedDiagram,
function(l1, l2)
    local i, j, r1, r2, iend, jend;

    r1 := Relator(l1);
    i := Position(l1);
    iend := i + 1;
    if iend > Length(r1) then iend := iend - Length(r1); fi;

    r2 := Relator(l2);
    j := Position(l2) - 1;
    jend := j - 1;
    if jend < 0 then jend := jend + Length(r2); fi;

    # Here inverses should match, or otherwise the passed
    # locations are already incompatible
    if r1[i] <> PregroupInverse(r2[j]) then
        Error("loc1 and loc2 are not compatible");
        return fail;
    fi;

    repeat
        i := i - 1;
        if i = 0 then i := Length(r1); fi;
        j := j + 1;
        if j > Length(r2) then j := 1; fi;

#        # Print("r1[", i, "] = ", r1[i], " r2[", j, "] = ", r2[j], "\n");
        if r1[i] <> PregroupInverse(r2[j]) then
            return true;
        fi;
    until (i = iend) or (j = jend);

    return false;
end);



