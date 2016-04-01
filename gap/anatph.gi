#
# anatph: A new approach to proving hyperbolicity
#
# Implementations
#

InstallGlobalFunction(PregroupPresentation,
function(pg, rels)
    local res;

    res := rec();

    res.pg := pg;
    res.rels := rels;

    return Objectify(PregroupPresentationType, res);
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

InstallMethod(Relations
             , "for a pregroup presentation"
             , [IsPregroupPresentation],
             pgp -> pgp!.rels);

InstallMethod(GeneratorsOfPregroupPresentation
             , "for a pregroup presentation"
             , [IsPregroupPresentation],
             x -> fail);

####################################
#
#
# Assumptions
#  I(Rels) only contains cyclic conjugates of R in Rels


# we have a bijection between \underline{\abs{P}} and P, i.e. number
# the elements of P.
# we also have an involution sigma : P -> P which inverts elements
# notational convention -i = sigma(i)
#
# We also have names for elements of P for better readability
# 
# relations are (compressed?) strings over P, i.e. lists of pairs
# [i,e] 

#
# Rels rep'd as a list of ints, for instance x^2y^-2 -> [[1,2],[2, -2]]
# unfortunately of course [x,-2] = [-x,2]
#


# MaxPowerK: Input a word v over X, output w such that w^k = v, k maximal with this property
#
# in the following w is the output of MaxPowerK
#
# location (i,a,b) where i in [1..Length(w)] a = w[i-1] and b = w[i] (so a
# location on R can be represented by just  the, well, location on w (?))
# R(i,a,b) if the relator is R, and so this involved MaxPowerK(R) as well!

# Place (R(i,a,b), c, C, B) R(i,a,b) is a place c is a generator C in [G,B], B
# in [true,false]


# If input is Rels then?

# A pregroup presentation will be a structure that has
# Generators(pres) (elements of pregroup except 1)
# Pregroup(pres)   (the pregroup structure)
# Relations(pres)  (the set \mathcal{R})

# An R-letter is a letter that occurs in any (intersperse) of
# a relation (Definition 7.4)
# XXX: Note that the code below does not do intersperses yet!
# XXX: Colva said we can go without intersperse I think
# XXX: Check
InstallGlobalFunction(IsRLetter,
function(pres, x)
    # determine whether x occurs in I(R)
    local r,l;

    for r in Relations(pres) do
        for l in r do
            return true;
        od;
    od;
    return false;
end);

# MaxPowerK: Input a word (relator) v over X, output w such that w^k = v, k maximal with this property
# There might be a better way of doing this? Colva mentioned that it's in one
# of Derek's books?
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

# at the moment a relation is just a list
# of integers referring to elements of the
# pregroup underlying the pregroup presentation
#
# for the moment a location is triple [i,a,b]. This is of course redundant, since
# we know a and b from i and R.
InstallGlobalFunction(Locations,
function(rel)
    local res, r, w, k, i;

    res := [];

    r := MaxPowerK(rel);
    w := r[1];

    res := List([2..Length(w)], i -> [i, w[i-1], w[i]]);
    Add(res, [1, w[Length(w)], w[1]]);

    return res;
end);

# Definition 3.3: A diagram is reduced  
InstallGlobalFunction(CheckReducedDiagram,
function(r1, r2)
    return false;
end);


# Given a pregroup presentation as the input, find all places
# Pregroup presentations consist of a pregroup and a list of relations
InstallGlobalFunction(Places,
function(pres)
    local loc, loc2, c, C, B,
          places, a, b,
          gens, rels, rel, rel2,
          places_for_rel;

    gens := [2..Size(Pregroup(pres))];
    rels := Relations(pres);

    places := [];

    for rel in rels do
        for loc in Locations(rel) do
            a := loc[2];
            b := loc[3];
            for c in Pregroup(pres) do
                #C = 'B'
                if IsIntermultPair(PregroupInverse(b), c) then
                    if IsRLetter(pres, c) then
                        Add(places, [loc,c,'B',false]);
                    fi;
                    Add(places, [loc, c, 'B', true] );
                fi;
                #C = 'G'
                # find location
                for rel2 in Relations(pres) do
                    for loc2 in Locations(rel2) do
                        if loc2[2] = PregroupInverse(b) and loc2[3] = c then
                            if CheckReducedDiagram(rel, rel2) then
                                Add(places, [loc, c, 'G', true]);
                            else
                                Add(places, [loc, c, 'G', false]);
                            fi;
                        fi;
                    od;
                od;
            od;
        od;
    od;

    return places;
end);

