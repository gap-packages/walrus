#
# anatph: A new approach to proving hyperbolicity
#
# Implementations
#
#
# Run to test (tg_pgp is a pregroup presentation for a triangle group, with
#              tg_pg better have more):
#  - IntermultPairs(tg_pg);
#  - Locations(tg_pgp);
#  - Places(tg_pgp);
#  - LocationBlobGraph(tg_pgp);
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

InstallMethod(Generators
             , "for a pregroup presentation"
             , [IsPregroupPresentation],
function(pres)
    local gens;
 
    gens := List(Pregroup(pres), x->x);
    Remove(gens, 1);
    return gens;
end);

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
#XXX cleanup
# Locations are tied to relations
InstallMethod(Locations, "for a pregroup presentation",
              [IsPregroupPresentation and IsPregroupPresentationRep],
function(pres)
    local rels, rel, locs, ls, r, w, k, i;

    rels := Relations(pres);
    locs := [];

    for rel in [1..Length(rels)] do
        r := MaxPowerK(rels[rel]);
        w := r[1];

        Add(locs, [rel, 1, w[Length(w)], w[1]]);
        Append(locs, List([2..Length(w)], i -> [rel, i, w[i-1], w[i]]));
    od;
    return locs;
end);

# Definition 3.3: A diagram is semi-reduced, if no distinct adjacent faces
# are labelled by ww_1 and w_1^{-1}w for a relator ww_1 and have a common
# consolidated edge labelled by w and w^-1
# it is reduced if this also holds for a face incident with itself.
#XXX When is a face "incident with itself" again?)
#XXX Is this then just checking that the two relators do not behave like
#    above?
#XXX Check correctness, but this is confirmed correct behaviour
InstallGlobalFunction(CheckReducedDiagram,
function(pres, l1, l2)
    local i, j, rels, r1, r2;

    rels := Relations(pres);

    r1 := rels[l1[1]];
    r2 := rels[l2[1]];

    i := l1[2];
    j := l2[2];

    repeat
        i := i + 1;
        if i > Length(r1) then i := 1; fi;
        j := j - 1;
        if j = 0 then j := Length(r2); fi;

        if r1[i] <> PregroupInverse(r2[j]) then
            return true;
        fi;
    until (i = l1[1]) or (j = l2[1]);
    return false;
end);

# Given a pregroup presentation as the input, find all places
# Pregroup presentations consist of a pregroup and a list of relations

# A place is a 4-tuple (location, letter, colour, boundary)
# such that
#
#XXX I think places on a relation are better, so this function should take a relation
#XXX note though that for the check whether there exists a reduced diagram, we have
#    to access all other Locations (i.e. relations)
InstallMethod(Places, "for a pregroup presentation",
              [IsPregroupPresentation and IsPregroupPresentationRep],
function(pres)
    local loc, loc2, c, C, B, X,
          places, a, b,
          gens, rels, rel, rel2,
          locs,
          places_for_rel,
          r,l;

    rels := Relations(pres);
    locs := Locations(pres);
    places := [];

    for loc in locs do
        a := loc[3];
        b := loc[4];
        for c in Generators(pres) do
            # C = 'B', i.e. red, I still find this confusing
            if IsIntermultPair(PregroupInverse(b), c) then
                if IsRLetter(pres, c) then
                    Add(places, [loc, c, "red", false]);
                fi;
                Add(places, [loc, c, "red", true] );
            fi;
            # C = 'G'
            # find location R'.
            for loc2 in locs do
                if loc2[3] = PregroupInverse(b) and loc2[4] = c then
                    # Is this really just checking that rel starting at b is
                    # not equal to rel2
                    if CheckReducedDiagram(pres, loc, loc2) then
                        Add(places, [loc, c, "green", true]);
                    else
                        Add(places, [loc, c, "green", false]);
                    fi;
                fi;
            od;
        od;
    od;

    return places;
end);

# Location blob graph
# vertices: locations and intermult pairs
# directed edges:
#  - I(a,b) -> R(j,b^(-1),c)
#  - R(i,a,b) -> I(b^(-1),c)
#  - R(i,a,b) -> R'(j,b^(-1),c) if there is a reduced diagram that has
#                               faces labelled R and R'
#XXX This is horribly inefficient, since we are much sparser
#    on edges than |v|^2
InstallGlobalFunction(LocationBlobGraph,
function(pres)
    local v, e, r, l, ls, lbg;

    v := List(Locations(pres), x->['L', x]);
    for r in [1..Length(Relations(pres))] do
        Append(v, List(IntermultPairs(Pregroup(pres)), x -> ['I', x]));
    od;

    e := function(a,b)
        if a[1] = 'L' then
            if b[1] = 'L' then
                if a[2][4] = PregroupInverse(b[2][3]) and
                   CheckReducedDiagram(pres, a[2], b[2]) then
                    return true;
                fi;
            elif b[1] = 'I' then
                if a[2][4] = PregroupInverse(b[2][2]) then
                    return true;
                fi;
            else
                Error("This shouldn't happen");
            fi;
        elif a[1] = 'I' then
            if b[1] = 'L' then
                if a[2][2] = PregroupInverse(b[2][3]) then
                    return true;
                fi;
            fi;
        fi;

        return false;
    end;

    lbg := Digraph(v,e);
    SetDigraphVertexLabels(lbg, v);
    return lbg;
end);

LocationBlobGraphDistances := function(lbg)
    local wt, f, d;

    wt := function(i,j)
        if DigraphVertexLabel(lbg, i)[1] = 'I' then
            return 1;
        else
            return 0;
        fi;
    end;

    f := function(mat, i, j, k)
        local t;

        if mat[i][j] = -1 then
            mat[i][j] := wt(i,j);
        else
            mat[i][j] := Minimum(mat[i][j], mat[i][k] + mat[k][j]);
        fi;
    end;

    return DigraphFloydWarshall(lbg, f, infinity, -1 );
end;

#XXX This can probably be simplified. Refer to section 7.3 for the
#    description
InstallGlobalFunction(ComputePlaceTriples,
function(pres)
    local v, v1, v2, lv, lv1, lv2,
          d, #
          dist,
          p,
          ps,
          pls,
          lp,
          lps,
          lpl,
          lbg,
          lbgd,
          locs,
          places, xi;

    lbg := LocationBlobGraph(pres);
    lbgd := LocationBlobGraphDistances(lbg);
    locs := Locations(pres);
    places := Places(pres);
    pls := Places(pres);

    lpl := ListWithIdenticalEntries(Length(places), []);

    for v in DigraphVertices(lbg) do
        lv := DigraphVertexLabel(lbg, v);
#        pls := Filtered(places, x -> x = v[2]);
        if lv[1] = 'L' then
            for v1 in InNeighboursOfVertex(lbg, v) do
                lv1 := DigraphVertexLabel(lbg, v1);
                for v2 in OutNeighboursOfVertex(lbg, v) do
                    lv2 := DigraphVertexLabel(lbg, v2);
                    if lv[1] = 'L' then
                        if lv2[1] = 'L' then   # v1 and v2 are locations
                            for p in [1..Length(pls)] do
                                if (pls[p][1] = lv[2]) and (pls[p][3] = "green") then
                                    if pls[p][4] = false then
                                        if lbgd[v2][v1] = 0 then
                                            Add(lpl[p], [v1, v2, -1/6]);
                                        elif lbgd[v2][v1] = 1 then
                                            Add(lpl[p], [v1, v2, -1/4]);
                                        elif lbgd[v2][v1] = 2 then
                                            Add(lpl[p], [v1, v2, -3/10]);
                                        else
                                            Add(lpl[p], [v1, v2, -1/3]);
                                        fi;
                                    else
                                        Add(lpl[p], [v1,v2, -1/3]);
                                    fi;
                                fi;
                            od;
                        elif lv2[1] = 'I' then # v1 location, v2 intermult
                            for p in [1..Length(pls)] do
                                if (pls[p][1] = lv[2]) and (pls[p][3] = "green") then
                                    if pls[p][4] = false then
                                        if lbgd[v2][v1] = 0 then
                                            Add(lpl[p], [v1, v2, 0]);
                                        elif lbgd[v2][v1] = 1 then
                                            Add(lpl[p], [v1, v2, -1/6]);
                                        else
                                            Add(lpl[p], [v1, v2, -1/4]);
                                        fi;
                                    else
                                        Add(lpl[p], [v1, v2, -1/4]);
                                    fi;
                                fi;
                            od;
                        else
                            Error("this shouldn't happen");
                        fi;
                    elif lv1[1] = 'I' then
                        if lv2[1] = 'L' then
                            for p in [1..Length(pls)] do
                                if (pls[p][1] = lv[2][2]) and (pls[p][3] = "red") then
                                    if pls[p][4] = false then
                                        if lbgd[v2][v1] = 0 then
                                            Add(lpl[p], [v1, v2, 0]);
                                        elif lbgd[v2][v1] = 1 then
                                            Add(lpl[p], [v1, v2, -1/6]);
                                        else
                                            Add(lpl[p], [v1, v2, -1/4]);
                                        fi;
                                    else
                                        Add(lpl[p], [v1, v2, -1/4]);
                                    fi;
                                fi;
                            od;
                        elif lv2[1] = 'I' then # Both intermult pair
                            for p in [1..Length(pls)] do
                                if (pls[p][1] = lv[2][2]) and (pls[p][3] = "red") then
                                    if pls[p][4] = false then
                                        Add(lpl[p], [v1, v2, 0]);
                                    else
                                        Add(lpl[p], [v1, v2, -1/4]);
                                    fi;
                                fi;
                            od;
                        else
                            Error("this shouldn't happen");
                        fi;
                    fi;
                od;
            od;
        fi;
    od;
    return lpl;
end);

# This is horrid, and we should think about
# better indexing.
InstallGlobalFunction(Vertex,
function(pres, v1, place, v2)
    local v, vl, loc, x, lbg, found, pls, lpl, pl, pt, pp, tv1, tv2;

    pls := Places(pres);
    lbg := LocationBlobGraph(pres);
    lpl := ComputePlaceTriples(pres);
    loc := place[1];

    found := false;
    
    for v in DigraphVertices(lbg) do
        vl := DigraphVertexLabel(lbg, v);

        if vl[1] = 'L' and vl[2] = loc then
            found := true;
            break;
        fi;
    od;
    
    if found then
        found := false;
        for tv1 in InNeighboursOfVertex(lbg, v) do
            if DigraphVertexLabel(tv1) = v1 then
                found := true;
                break;
            fi;
        od;
    else
        return fail;
    fi;
    
    if found then
        found := false;
        for tv2 in OutNeighboursOfVertex(lbg, v) do
            if DigraphVertexLabel(tv2) = v2 then
                found := true;
                break;
            fi;
        od;
    else
        return fail;
    fi;
    
    if found then
        found := false;
        for pp in [1..Length(pls)] do
            if pls[pp] = place then
                found := true;
            fi;
        od;
    else
        return fail;
    fi;
    
    if found then
        found := false;
        for pt in lpl[pp] do
            if pt[1] = v1 and pt[2] = v2 then
                return pt[3];
            fi;
        od;
    else 
        return fail;
    fi;
    return fail;
end);


InstallGlobalFunction(ShortBlobWords,
function(pres)
    local i, lst, pg, alph;
    alph := Generators(tg_pgp);

    lst := [""];

    for i in [1..6] do
    od;

    Error("short blob words not complete yet");
    return lst;
end);

InstallGlobalFunction(Blob,
function()
    Error("Blob not implemented yet");

    return -5/14;
end);

LengthEps := function(eps, rel, l)
    return (1 + eps)/Length(rel) * l;
end;

StepCurvature := function(places, P, Q)
end;

OneStepReachable := function()
    Error("OneStepReachable not implemented yet");
    
end;

InitStepsCurve := function(places, p)
    local i, j, res, nplaces;
    nplaces := Length(places);
    res := [];
    for i in [1..nplaces] do
        res[i] := [];
        for j in [1..nplaces] do
            res[i][j] := [-1,0];
        od;
        res[i][i] := [0,0];
    od;
    return res;
end;

# The RSym tester
InstallGlobalFunction(RSymTester,
function(pres, eps)
    local i, j, rel,
          places, Ps, P, Q,
          stepscurve,   # Steps and curvature
          zeta,
          Xi;
    zeta := Int(Ceil(6 * (1 + eps)));

    for rel in Relations(pres) do
        places := Places(pres, rel);
        for Ps in places do
            stepscurve := InitStepsCurve(places, Ps);

            for i in [1..zeta] do
                for P in [1..Length(places)] do
                    if stepscurve[j][1] = i - 1 then
                        for Q in OneStepReachable(places[P]) do
                            Xi := stepscurve[P][2]
                                  + StepCurvature(places, P, Q)
                                  + LengthEps(eps, rel, P, Q);

                            if (Xi >= 0) and (Ps = Q) then
                                return [fail, stepscurve];
                            fi;

                            if (Xi > stepscurve[Q][1]) then
                                stepscurve[Q][1] := i;
                                stepscurve[Q][2] := Xi;
                            fi;
                        od;
                    fi;
                od;
            od;
        od;
    od;

    return true;
end);


