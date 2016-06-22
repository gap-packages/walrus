#
# anatph: A new approach to proving hyperbolicity
#
#
# TODO
#  - Better Handling for relations:
#     - Make a type for relations
#     - they belong to a presentation
#     - They can have a root-power-presentation
#     - They should be testable for overlaps
#  - A type for Locations
#  - A type for Places
#  - Check correctness of IsReducedDiagram
#  - MakeIsReducedDiagram a method
#  - Put relators of different presentations into different families
#  - Write some tests
#  - Straighten out negative/positive curvature storage


#
# Run to test (tg_pgp is a pregroup presentation for a triangle group, with
#              tg_pg better have more):
#  - IntermultPairs(tg_pg);
#  - Locations(tg_pgp);
#  - Places(tg_pgp);
#  - LocationBlobGraph(tg_pgp);
#

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

    for r in RelatorsAndInverses(pres) do
        if x in r then
            return true;
        fi;
    od;
    return false;
end);

# Definition 3.3: A diagram is semi-reduced, if no distinct adjacent faces
# are labelled by ww_1 and w_1^{-1}w for a relator ww_1 and have a common
# consolidated edge labelled by w and w^-1
# it is reduced if this also holds for a face incident with itself.
InstallGlobalFunction(CheckReducedDiagram,
function(l1, l2)
    local i, j, r1, r2;

    r1 := Relator(l1);
    i := Position(l1);
    r2 := Relator(l2);
    j := Position(l2);

    repeat
        i := i + 1;
        if i > Length(r1) then i := 1; fi;
        j := j - 1;
        if j = 0 then j := Length(r2); fi;

        if r1[i] <> PregroupInverse(r2[j]) then
            return true;
        fi;
    until (i = Position(l1)) or (j = Position(l2));
    return false;
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
InstallMethod(LocationBlobGraph, "for a pregroup presentation",
              [IsPregroupPresentation and IsPregroupPresentationRep],
function(pres)
    local v, e, r, l, ls, lbg;

    v := ShallowCopy(Locations(pres));
    Append(v, List(IntermultPairs(Pregroup(pres)), x -> ['I', x]));

    e := function(a,b)
        if IsPregroupLocation(a) then
            if IsPregroupLocation(b) then
                if OutLetter(a) = PregroupInverse(InLetter(b)) and
                   CheckReducedDiagram(a, b) then
                    return true;
                fi;
            elif IsList(b) then # IsList is a hack to recognise intermult pairs
                if OutLetter(a) = PregroupInverse(b[2][2]) then
                    return true;
                fi;
            else
                Error("This shouldn't happen");
            fi;
        elif IsList(a) then
            if IsPregroupLocation(b) then
                if a[2][2] = PregroupInverse(InLetter(b)) then
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

InstallMethod(LocationBlobGraphDistances, "for a pregroup presentation",
              [IsPregroupPresentation and IsPregroupPresentationRep],
function(pres)
    local lbg, wt, f, d;

    lbg := LocationBlobGraph(pres);
    wt := function(i,j)
        if not IsPregroupLocation(DigraphVertexLabel(lbg, i)) then
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
end);

#XXX This can probably be simplified. Refer to section 7.3 for the
#    description
#XXX Also at the moment this produces resuls that don't look plausible
#    Check locationblobgraph again + distances?
# InstallGlobalFunction(ComputePlaceTriples,
InstallMethod(PlaceTriples, "for a pregroup presentation",
              [IsPregroupPresentation],
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

    locs := Locations(pres);
    places := Places(pres);
    pls := Places(pres);
    lbg := LocationBlobGraph(pres);
    lbgd := LocationBlobGraphDistances(pres);

    lpl := List([1..Length(places)], x -> []);

    for v in DigraphVertices(lbg) do                            # All locations are vertices in the LocationBlobGraph

        lv := DigraphVertexLabel(lbg, v);

        if IsPregroupLocation(lv) then
            for v1 in InNeighboursOfVertex(lbg, v) do
                lv1 := DigraphVertexLabel(lbg, v1);
                for v2 in OutNeighboursOfVertex(lbg, v) do
                    lv2 := DigraphVertexLabel(lbg, v2);

                    # we have v1 -> v -> v2
                    if IsPregroupLocation(lv1) then
                        if IsPregroupLocation(lv2) then   # v1 and v2 are locations
                            for p in Places(lv) do        # places that have location v
                                # InLetter(lv2) = OutLetter(lv) is
                                # holds by construction of LocationBlobGraph
                                if (Letter(p) = OutLetter(lv2))
                                   and (Colour(p) = "green") then
                                    if Boundary(p) = false then
                                        if lbgd[v2][v1] = 0 then
                                            Add(lpl[__ID(p)], [v1, v2, -1/6]);
                                        elif lbgd[v2][v1] = 1 then
                                            Add(lpl[__ID(p)], [v1, v2, -1/4]);
                                        elif lbgd[v2][v1] = 2 then
                                            Add(lpl[__ID(p)], [v1, v2, -3/10]);
                                        else
                                            Add(lpl[__ID(p)], [v1, v2, -1/3]);
                                        fi;
                                    else
                                        Add(lpl[__ID(p)], [v1,v2, -1/3]);
                                    fi;
                                fi;
                            od;
                        elif IsList(lv2) then # v1 location, v2 intermult
                            for p in Places(lv) do
                                if (Letter(p) = lv2[2]) # tis is probably true by LBG construction?
                                   and (Colour(p) = "red") then
                                    if Boundary(p) = false then
                                        if lbgd[v2][v1] = 0 then
                                            Add(lpl[__ID(p)], [v1, v2, 0]);
                                        elif lbgd[v2][v1] = 1 then
                                            Add(lpl[__ID(p)], [v1, v2, -1/6]);
                                        else
                                            Add(lpl[__ID(p)], [v1, v2, -1/4]);
                                        fi;
                                    else
                                        Add(lpl[__ID(p)], [v1, v2, -1/4]);
                                    fi;
                                fi;
                            od;
                        else
                            Error("this shouldn't happen");
                        fi;
                    elif IsList(lv1) then # v1 intermult pair
                        if IsPregroupLocation(lv2) then
                            for p in Places(lv) do
                                if (Letter(p) = OutLetter(lv2))
                                   and (Colour(p) = "red") then
                                    if Boundary(p) = false then
                                        if lbgd[v2][v1] = 0 then
                                            Add(lpl[__ID(p)], [v1, v2, 0]);
                                        elif lbgd[v2][v1] = 1 then
                                            Add(lpl[__ID(p)], [v1, v2, -1/6]);
                                        else
                                            Add(lpl[__ID(p)], [v1, v2, -1/4]);
                                        fi;
                                    else
                                        Add(lpl[__ID(p)], [v1, v2, -1/4]);
                                    fi;
                                fi;
                            od;
                        elif IsList(lv2) then # Both intermult pair
                            for p in Places(lv) do
                                if Colour(p) = "red" then
                                    if Boundary(p) = false then
                                        Add(lpl[__ID(p)], [v1, v2, 0]);
                                    else
                                        Add(lpl[__ID(p)], [v1, v2, -1/4]);
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
#InstallMethod(Vertex, "for a pregroup presentation",
#              [IsPregroupPresentation],
function(pres, v1, place, v2)
    local v,     # Vertex in locationblobgraph
          trp,   # triple
          lbg,   # LocationBlobGraph
          lpl,   # L_P list
          loc,   # Location(place)
          min;   # Minimal curvature

    lbg := LocationBlobGraph(pres);

    # This is the list L_P, the place triples
    # are at the moment indexed the same way
    # as places in the presentation
    lpl := PlaceTriples(pres)[__ID(place)];
    loc := Location(place);

    #X Find the vertex in LBG that is labelled by Location(place)
    #X Better vertex indexing is necessary in digraphs: we need
    #X bijective labelling map.
    for v in DigraphVertices(lbg) do
        if DigraphVertexLabel(lbg, v) = loc then
            break;
        fi;
    od;
    # If we don't find the vertex (which would hint at a bug!) we're
    # stuffed here

    # -Xi does my head in...
    min := infinity;
    for trp in lpl do
        if (trp[1] in DigraphInEdges(v)) and
           (trp[2] in DigraphOutEdges(v)) and
           (-trp[3] < min) then
            min := -trp[3];
        fi;
    od;

    return min;
end);

ReduceUPregroupWord := function(word)
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
end;

# In reality we only need a list indexed by triples, so we
# will quite probably end up with a tree where the leaves have
# weights as labels.

CyclicSubList := function(l, pos, len)
    local r, i, j, llen;

    llen := Length(l);
    r := [];
    i := pos; j := 1;
    while j <= len do
        r[j] := l[i];
        i := i + 1; j := j + 1;
        if i > llen then
            i := 1;
        fi;
    od;

    return r;
end;


# Tests whether there is a proper subword
# that reduces to 1
#
# because adjacent letters are intermult pairs we only need to test
# strings of length 3 to len - 1
#
# This is probably horribly inefficient.
CyclicReducedSubwords := function(word)
    local l, i, pos;

    pos := [1..Length(word)];
    for l in [3..Length(word)] do
        for i in [1..Length(word)] do
            if ReduceUPregroupWord(word{CyclicSubList(pos, i, l)}) = [] then
                return [true, word{ CyclicSubList(pos, i, l) } ];
            fi;
        od;
    od;
    return [false];
end;

IndexMinEnter := function(idx, key, value)
    local i, it;

    it := idx;
    for i in key do
        if not IsBound(it[i]) then
            it[i] := [];
        fi;
        it := it[i];
    od;

    if it = [] then
        it[1] := value;
    else
        it[1] := Minimum(it[1], value);
    fi;
end;

EnterAllSubwords := function(idx, word, value)
    local i, pos;
    pos := [1..Length(word)];
    for i in pos do
        IndexMinEnter(idx, word{ CyclicSubList(pos, i, 3) }, value);
    od;
end;

#XXX Store only the triples (a,b,c) that are infixes 
#    of stirngs found here with appropriate numbers
#    This is done
#XXX It might not be guaranteed yet that no proper subword
#    of a word found here is equal to 1
#XXX Redo in nice
#XXX for lots of generators this becomes unbearably slow.
InstallMethod(ShortRedBlobIndex, "for a pregroup presentation",
              [IsPregroupPresentation],
function(pres)
    local i, j, k, lst, pg, alph, imm, n, elt,
          coord, levelelt, tree, level, nonrletts, cand, len, c,
          word, res, levels, redw, reduced, ww, nrl;
    pg := Pregroup(pres);
    n := Size(pg);
    imm := IntermultMap(Pregroup(pres));

    res := [];

    len := 1;
    nonrletts := [];
    word := [];
    levelelt := [];
    levels := [[],[],[],[],[],[]];
    index := [];

    cand := [[2..n]];

    # len: current length of word (depth in tree?)
    while len > 0 do
        reduced := [false];
        while (len <= 6)                     # up to depth 6
              and (cand[len] <> [])          # apply all intermult candidates
              and (not reduced[1]) do           # only go deeper if no subword is equal to id

            c := Remove(cand[len], 1);
            # the current word
            word[len] := c;
            nonrletts[len] := not IsRLetter(pres, pg[c]);
            reduced := CyclicReducedSubwords(List(word{ [1..len] }, x -> pg[x]));

            if (len < 6) and (not reduced[1]) then
                cand[len + 1] := ShallowCopy(imm[c]);
            else
                cand[len + 1] := [];
            fi;
            len := len + 1;
        od;

        len := len - 1;

        while (len > 0) and (cand[len] = []) do
            ww := ReduceUPregroupWord(List(word{[1..len]}, x -> pg[x]));
            nrl := nonrletts{[1..len]};
#            Print("word: ", word{[1..len]}, " redw: ", ww, " nrl: ", nrl, "\n");
            if (ww = []) then
                if IsIntermultPair(pg[word[1]], pg[word[len]]) then
                    if len = 3 then
                        if SizeBlist(nrl) = 0 then
#                            Add(res, [word{[1..len]}, 1/6]);
                            EnterAllSubwords(index, word{[1..len]}, 1/6);
                        elif SizeBlist(nrl) = 1 then
#                            Add(res, [word{[1..len]}, 1/4]);
                            EnterAllSubwords(index, word{[1..len]}, 1/4);
                        fi;
                    elif len = 4 then
                        if SizeBlist(nrl) = 0 then
#                            Add(res, [word{[1..len]}, 1/4]);
                            EnterAllSubwords(index, word{[1..len]}, 1/4);
                        elif SizeBlist(nrl) = 1 then
#                            Add(res, [word{[1..len]}, 1/3]);
                            EnterAllSubwords(index, word{[1..len]}, 1/3);
                        fi;
                    elif len = 5 and (SizeBlist(nrl) = 0) then
#                        Add(res, [word{[1..len]}, 3/10]);
                        EnterAllSubwords(index, word{[1..len]}, 3/10);
                    elif len = 6 and (SizeBlist(nrl) = 0) then
#                        Add(res, [word{[1..len]}, 1/3]);
                        EnterAllSubwords(index, word{[1..len]}, 1/3);
                    fi;
                fi;
            fi;
            len := len - 1;
        od;
    od;
    return index;
end);

InstallGlobalFunction(Blob,
function(pres, a, b, c)
    local it;

    it := ShortRedBlobIndex(pres);
    if IsBound(it[a]) then
        it := it[a];
        if IsBound(it[b]) then
            it := it[b];
            if IsBound(it[c]) then
                return it[c][1];
            fi;
        fi;
    fi;
    return -5/14;
end);

LengthEps := function(eps, rel, l)
    return (1 + eps)/Length(rel) * l;
end;

StepCurvature := function(places, P, Q)
end;

InstallMethod(OneStepReachablePlaces, "for a pregroup presentation",
              [IsPregroupPresentation],
function(pres)
    local rel, pl, P, Q, places, osr, curv, pows, lbg, gens, b, c, binv, rels
          , OneStepRedCase
          , OneStepGreenCase
          , OneStepByPlace;

    gens := Generators(pres);
    places := Places(pres);
    pows := Powers(pres);
    lbg := LocationBlobGraph(pres);
    rels := Relators(pres);

    OneStepByPlace := [];

    # list with places, and offsets
    # ()
    curv := List(places, function(x)
                    if x[3] = "red" then
                        return [0,infinity];
                    elif x[3] = "green" then
                        return List([0..QuoInt(pows[x[1][1]], 2)], y -> [y,infinity]);
                    else
                        Error("invalid colour");
                    fi;
                end);

    OneStepRedCase := function(P)
        local Q, b, y, v, Pl, Ql, res;

        res := [];
        Pl := Location(P);

        for Q in Places(pres) do
            # same relator, one position up
            Ql := Location(Q);
            if (Relator(Q) = Relator(P))
               and (Position(Ql) = Position(Pl) + 1)
               and (InLetter(Ql) = OutLetter(Pl)) then
                for y in gens do
                    binv := PregroupInverse(InLetter(Ql));
                    if IsIntermultPair(y, binv) then
                        v := LBGVertexForLoc(Q);
                        for v2 in OutNeighboursOfVertex(lbg, v) do
                            xi1 := Blob(y, binv, c);
                            xi2 := Vertex([y, binv], Ql, v2);
                            # Note that xi1, xi2 are negative
                            # Here we only have 0 offset
                            # Add(OneStepByPlace[__ID(P)], [Q, 1, xi1 + xi2]);
                            Add(res, OneStopByPlace[__ID(P)], [Q, 1, xi1 + xi2]);
                        od;
                    fi;
                od;
            fi;
        od;
        return res;
    end;

    # P is the place we're working on
    OneStepGreenCase := function(P)
        local L, L2, b, c, loc, pls, is_consoledge, l, v, nu1, nu2, xi1;

        L := Location(P);
        b := InLetter(L);
        c := Letter(P);

        # Every place that is instanciated with location that is in an instantiation of
        # a place P'.
        # We're interested in consolidated edges between Relator(P) and Relator(pls) 
        # from the locations that P and pls are at.
        # 
        # Have to check that Relator(P) and Relator(pls) don't entirely cancel (is this
        # assumed to be only the case when Relator(P) = Relator(pls)^{-1})
        for pls in Places(pres) do
            L2 := Location(pls); # This is the location on R'
            if (InLetter(L2) = PregroupInverse(b))
               and (OutLetter(L2) = c) then
                l := 1;
                is_consoledge := true;
                while is_consoledge do
                    P2 := Place(); # This is the place that is reachable along the consolidated
                                   # edge
                    v := LBGVertexForLoc(Location(P2));
                    for nu1 in InEdges(v) do
                        for nu2 in OutEdges(v) do
                            if Colour(nu2) = Colour(P2) then
                                xi1 := Vertex(nu1, P2, nu2);
                                if Colour(P2) = "green" then
                                    Add(OneStepByPlace[__ID(P)], [P2,l,xi1])
                                elif Colour(P2) = "red" then
                                    #T is this application of OneStepRedCase correct?
                                    next := OneStepRedCase(P2);
                                    Append(OneStepByPlace[__ID(P)], List(next, x -> [x[1], l + 1, x[3] + xi1]))
                                    # Add(OneStepByPlace[__ID(P)], [Q,l+1,xi1 + xi2])
                                else
                                    Error("Invalid colour");
                                fi;
                            fi;
                        od;
                    od;
                    
                    if Colour(P2) = "green"
                od;
            fi;
        od;
    end;

    # for every place we compute a list of
    # one-step reachable places
    for P in Places(pres) do
        if Colour(P) = "red" then
            OneStepRedCase(P);
        elif Colour(P) = "green" then
            OneStepGreenCase(P);
        else
            Error("Invalid colour for place ", P, "\n");
        fi;
    od;

    Error("OneStepReachablePlaces not completely implemented yet");
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
