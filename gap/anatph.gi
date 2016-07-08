########################################################################
#
# anatph: A new approach to proving hyperbolicity
#
# WARNING
#
########################################################################
#
# TODO (documentation)
#  - Examples
#  - notes on the implementation (design decisions etc)
#
# TODO (technical)
#  - MakeIsReducedDiagram a method
#  - Sort out families of elements etc
#  - what to do about the __ID hack?
#  - What to do about float vs rational?
#  - provide a way to label of generators
#  - Introduce an InfoLevel and log things with info levels, remove Print
#    statements
#  - Put relators of different presentations into different families
#  - Check whether some sub-functions could be cleaned out from functions
#    and would become more generally useful
#
# TODO (mathematical/functional)
#  - Write tests
#  - Interleaving
#  - Preparing the presentation
#  - check LocationBlobGraph + distances
#  - Make the distance computation in LBG more efficient?
#  - Check OneStepReachables
#  - Check RSymTest
#
########################################################################
#
# Some notes on the implementation
#
# - Stored curvature is always "negative curvature", so in most cases a 
#   positive value.
# - Curvature values are stored as rationals at first, later converted to
#   floats. This might not be the best way to do this (we might want to 
#   always use rationals or always use floats)
#

# An R-letter is a letter that occurs in any (interleave) of
# a relation (Definition 7.4)
# XXX: Note that the code below does not do interleaves yet!
InstallGlobalFunction(IsRLetter,
function(pres, x)
    # determine whether x occurs in I(R)
    return ForAny(RelatorsAndInverses(pres), r -> x in r);
end);

# Definition 3.3: A diagram is semi-reduced, if no distinct adjacent faces
# are labelled by ww_1 and w_1^{-1}w for a relator ww_1 and have a common
# consolidated edge labelled by w and w^-1
# it is reduced if this also holds for a face incident with itself.

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

        if r1[i] <> PregroupInverse(r2[j]) then
            return true;
        fi;
    until (i = iend) or (j = jend);

    return false;
end);

# Location blob graph
# vertices: locations and intermult pairs
# directed edges:
# Here "I" means "IntermultPair"
#  - I(a,b) -> R(j,b^(-1),c)
#  - R(i,a,b) -> I(b^(-1),c)
#  - R(i,a,b) -> R'(j,b^(-1),c) if there is a reduced diagram that has
#                               faces labelled R and R'
#XXX This is horribly inefficient, since we are much sparser
#    on edges than |v|^2
InstallMethod(LocationBlobGraph, "for a pregroup presentation",
              [IsPregroupPresentation and IsPregroupPresentationRep],
function(pres)
    local v, e, lbg;

    v := ShallowCopy(Locations(pres));
    Append(v, List(IntermultPairs(Pregroup(pres)), x -> ['I', x]));

    # Edge relation for LocationBlobGraph
    e := function(a,b)
        if IsPregroupLocation(a) then
            if IsPregroupLocation(b) then
                if OutLetter(a) = PregroupInverse(InLetter(b)) and
                   CheckReducedDiagram(a, b) then
                    return true;
                fi;
            elif IsList(b) then # IsList is a hack to recognise intermult pairs
                if OutLetter(a) = PregroupInverse(b[2][1]) then
                    return true;
                fi;
            else
                Error("This shouldn't happen");
            fi;
        elif IsList(a) then
            if IsPregroupLocation(b) then
                if PregroupInverse(a[2][2]) = InLetter(b) then
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

# Can we analyse connected components?
# At the moment this is the slowest bit of the algorithm
InstallMethod(LocationBlobGraphDistances, "for a pregroup presentation",
              [IsPregroupPresentation and IsPregroupPresentationRep],
function(pres)
    local lbg, wt, f;

    lbg := LocationBlobGraph(pres);
    wt := function(i,j)
        if IsPregroupLocation(DigraphVertexLabel(lbg, i))
           and (IsPregroupLocation(DigraphVertexLabel(lbg, j)) or
                IsList(DigraphVertexLabel(lbg,j))) then
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
    # Can there be more than one such entry?
    return DigraphFloydWarshall(lbg, f, infinity, -1 );
end);

#XXX This can probably be simplified. Refer to section 7.3 for the
#    description
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

    # All locations are vertices in the LocationBlobGraph
    # And actually, since we put the locations *first* we could
    # stop this loop as soon as we run out of locations?
    for v in DigraphVertices(lbg) do
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
                                            Add(lpl[__ID(p)], [v1, v2, 1/6]);
                                        elif lbgd[v2][v1] = 1 then
                                            Add(lpl[__ID(p)], [v1, v2, 1/4]);
                                        elif lbgd[v2][v1] = 2 then
                                            Add(lpl[__ID(p)], [v1, v2, 3/10]);
                                        else
                                            Add(lpl[__ID(p)], [v1, v2, 1/3]);
                                        fi;
                                    else
                                        Add(lpl[__ID(p)], [v1,v2, 1/3]);
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
                                            Add(lpl[__ID(p)], [v1, v2, 1/6]);
                                        else
                                            Add(lpl[__ID(p)], [v1, v2, 1/4]);
                                        fi;
                                    else
                                        Add(lpl[__ID(p)], [v1, v2, 1/4]);
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
                                   and (Colour(p) = "green") then
                                    if Boundary(p) = false then
                                        if lbgd[v2][v1] = 0 then
                                            Add(lpl[__ID(p)], [v1, v2, 0]);
                                        elif lbgd[v2][v1] = 1 then
                                            Add(lpl[__ID(p)], [v1, v2, 1/6]);
                                        else
                                            Add(lpl[__ID(p)], [v1, v2, 1/4]);
                                        fi;
                                    else
                                        Add(lpl[__ID(p)], [v1, v2, 1/4]);
                                    fi;
                                fi;
                            od;
                        elif IsList(lv2) then # Both intermult pair
                            for p in Places(lv) do
                                if Colour(p) = "red" then
                                    if Boundary(p) = false then
                                        Add(lpl[__ID(p)], [v1, v2, 0]);
                                    else
                                        Add(lpl[__ID(p)], [v1, v2, 1/4]);
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


# Here we use rationals still
InstallGlobalFunction(Vertex,
function(pres, v1, place, v2)
    local v,     # Vertex in locationblobgraph
          trp,   # triple
          lbg,   # LocationBlobGraph
          lpl,   # L_P list
          loc,   # Location(place)
          min;   # Minimal curvature

    if not IsPregroupPlace(place) then
        Error("Vertex: <place> needs to be a place!");
    fi;

    lbg := LocationBlobGraph(pres);

    # This is the list L_P, the place triples
    # are at the moment indexed the same way
    # as places in the presentation
    lpl := PlaceTriples(pres)[__ID(place)];
    loc := Location(place);

    #X Find the vertex in LBG that is labelled by Location(place)
    #X Better vertex indexing is necessary in digraphs: we need
    #X bijective labelling map.
    #X at the moment as a hack we could use __ID(), i.e.
    # v = __ID(loc);
    #for v in DigraphVertices(lbg) do
    #    if DigraphVertexLabel(lbg, v) = loc then
    #        break;
    #    fi;
    #od;
    v := __ID(loc);
    if DigraphVertexLabel(lbg, v) <> loc then
        Error("This is a bug\n");
    fi;

    # -Xi is the negative curvature, i.e. positive (yeah, I know)
    min := infinity;
    for trp in lpl do
        if (trp[1] in DigraphInEdges(lbg, v)) and
           (trp[2] in DigraphOutEdges(lbg, v)) and
           (trp[3] < min) then
            min := trp[3];
        fi;
    od;

    # Since floating point infinity gets in the way we only convert to
    # it late.
    if min = infinity then
        min := 1.0 / 0.0;
    fi;

    # This is a negative curvature, i.e. a positive value.
    return min;
end);

#T redo
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

#T this is very ad-hoc
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
    local i, pos, ww;
    pos := [1..Length(word)];
    ww := List(word, x -> __ID(x));
    for i in pos do
        IndexMinEnter(idx, ww{ CyclicSubList(pos, i, 3) }, value);
    od;
end;

#XXX Computes triples (a,b,c) that are infixes 
#    of strings found here with appropriate numbers
InstallMethod(ShortRedBlobIndex, "for a pregroup presentation",
              [IsPregroupPresentation],
function(pres)
    local pg, n, imm, index, nrl, cand, word, nonrletts, len, c
    ;

    pg := Pregroup(pres);
    n := Size(pg);
    imm := IntermultMap(pg);
    index := [];
    cand := [[2..n]];

    nonrletts := [];
    word := [];

    len := 1;

    # minimum length 3
    while (len > 0) and (len < 7) do
        if Length(cand[len]) > 0 then
            c := Remove(cand[len], 1);
            word[len] := pg[c];
            nonrletts[len] := not IsRLetter(pres, pg[c]);
            # Possible not go further if we have too many R-letters?
            if IsIntermultPair(word[len], word[1]) and
               ReduceUPregroupWord(word{ [1..len] }) = [] then
                nrl := SizeBlist(nonrletts{[1..len]});
                if len = 3 then
                    # if len = 3 then no proper subword can be equal to 1
                    # because we only look at intermult pairs, and pairs
                    # of inverses are explicitly not intermult pairs
                    if nrl = 0 then
                        EnterAllSubwords(index, word{[1..len]}, 1/6);
                    elif nrl = 1 then
                        EnterAllSubwords(index, word{[1..len]}, 1/4);
                    else
                        # Print("? nrl", nrl, "\n");
                    fi;
                elif len = 4 then
                    if nrl = 0 then
                        EnterAllSubwords(index, word{[1..len]}, 1/4);
                    elif nrl = 1 then
                        EnterAllSubwords(index, word{[1..len]}, 1/3);
                    else
                        # Print("? nrl", nrl, "\n");
                    fi;
                elif len = 5 then
                    if (nrl = 0) then
                        EnterAllSubwords(index, word{[1..len]}, 3/10);
                    fi;
                elif (len = 6)
                     and (ReduceUPregroupWord(word{[2,3,4]}) <> [])
                     and (ReduceUPregroupWord(word{[3,4,5]}) <> []) then
                    if nrl = 0 then
                        EnterAllSubwords(index, word{[1..len]}, 1/3);
                    else
                        # Print("? nrl", nrl, "\n");
                    fi;
                fi;
                # We have entered, so backtrack
                len := len - 1;
            else
                # Expand if not substring that is equal to 1?
                if (len = 6)
                   and (ReduceUPregroupWord(word{[2,3,4]}) <> [])
                   and (ReduceUPregroupWord(word{[3,4,5]}) <> []) then
                else
                    len := len + 1;
                    cand[len] := ShallowCopy(imm[c]);
                fi;
            fi;
        else
            len := len - 1;
        fi;
    od;
    return index;
end);

# This should become an operation
#InstallMethod(Blob, "for a pregroup presentation, an element, an element, and an element"
#             , [ IsPregroupPresentation, IsPregroupElement, IsPregroupElement, IsPregroupElement ]
#             , function(pres, a, b, c) end);
InstallGlobalFunction(Blob,
function(pres, a, b, c)
    local it;

    it := ShortRedBlobIndex(pres);
    if IsBound(it[__ID(a)]) then
        it := it[__ID(a)];
        if IsBound(it[__ID(b)]) then
            it := it[__ID(b)];
            if IsBound(it[__ID(c)]) then
                return it[__ID(c)][1];
            fi;
        fi;
    fi;
    return 5/14;
end);

InstallGlobalFunction(LBGVertexForLoc,
function(lbg, loc)
    return __ID(loc);
end);

# This assumes all previous have been checked already!
NextPlaces := function(loc1, loc2, l)
    local P, res, i, j;

    res := [];

    i := Position(loc1) + l;
    j := Position(loc2) - l - 1;

    # Poor man's cyclic access
    # TODO check correctness?
    # mhm.
    if Relator(loc1)[i] = PregroupInverse(Relator(loc2)[j]) then
        for P in Places(Relator(loc1)) do
            if Position(Location(P)) = i then
                Add(res, P);
            fi;
        od;
    fi;
    return res;
end;



InstallMethod(OneStepReachablePlaces, "for a pregroup presentation",
              [IsPregroupPresentation],
function(pres)
    local rel, pl, P, Q, places, osr, curv, pows, lbg, gens, b, c, binv, rels
          , OneStepRedCase
          , OneStepGreenCase
          , OneStepByPlace
          , ConsolidatedEdgePlaces;

    gens := Generators(pres);
    places := Places(pres);
    lbg := LocationBlobGraph(pres);
    rels := Relators(pres);

    OneStepByPlace := [];

    curv := List(places, function(x)
                    if Colour(x) = "red" then
                        return [ 0, 1.0 / 0.0 ];
                    elif Colour(x) = "green" then
                        return List([0..QuoInt(Exponent(Relator(x)), 2)], y -> [ y, 1.0 / 0.0 ]);
                    else
                        Error("invalid colour");
                    fi;
                end);

    OneStepRedCase := function(P)
        local Q, b, y, v, v2, Pl, Ql, res, xi1, xi2;

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
                        v := LBGVertexForLoc(lbg, Location(Q));
                        for v2 in OutNeighboursOfVertex(lbg, v) do
                            xi1 := Blob(pres, y, binv, Letter(P));
                            xi2 := Vertex(pres, [y, binv], Q, v2);
                            # Note that xi1, xi2 are negative
                            # Here we only have 0 offset
                            # Add(OneStepByPlace[__ID(P)], [Q, 1, xi1 + xi2]);
                            Add(res, [Q, 1, xi1 + xi2]);
                        od;
                    fi;
                od;
            fi;
        od;
        return res;
    end;

    # Compute places reachable from loc1 on Relator(loc1) by a
    # consolidated edge between Relator(loc1) and Relator(loc2)
    # At the moment we assume that OutLetter(loc1) = InLetter(loc2),
    # better indexing would make this more efficent,
    # not iterating over places
    ConsolidatedEdgePlaces := function(loc1, loc2)
        local P, pos, res, i, j, l, r1, r2, e;

        r1 := Relator(loc1);
        r2 := Relator(loc2);

        res := Set([]);

        pos := [];;

        l := 1;

        i := Position(loc1);
        j := Position(loc2) - 1;

        # Compute a list of positions on r1 that
        # can be reached by a consolidated edge
        # together with the length of that edge
        while (r1[i] = PregroupInverse(r2[j]))
              and (l < Length(r1)) do
            Add(pos, [i, l]);
            i := i + 1; j := j - 1; l := l + 1;
        od;

        # need to be careful here with power/exponent rep of
        # relators, the positions we stored above are on the
        # relator, to get to positions for locations, we need
        # to do the modulo dance.
        #T prettier soloution: we should be able to get the Location
        #T of relator[i] directly
        e := Length(Base(r1));
        for P in Places(Relator(loc1)) do
            for l in pos do
                if Position(Location(P)) = ((l[1] - 1) mod e) + 1 then
                    Add(res, [P,l[2]]);
                fi;
            od;
        od;

        return res;
    end;

    # P is the place we're working on
    OneStepGreenCase := function(P)
        local L, L2, b, c, loc, pls, is_consoledge, v, nu1, nu2, xi1, xi2,
              R, R2, P2, P2s, P2P, i, j, next, res, len;
        res := [];

        L := Location(P);
        b := OutLetter(L);
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
            R2 := Relator(L2);

            # L2 instantiates place on R2, have to test consolidated
            #    edges between R and R2 starting from L/L2 on R/R2
            #    respectively
            if (InLetter(L2) = PregroupInverse(b))
               and (OutLetter(L2) = c) then

                # We compute all consolidated edge places,
                # we could do this incrementally, but I don't
                # currently see a use in doing so
                P2s := ConsolidatedEdgePlaces(L, L2);

                for P2P in P2s do
                    P2 := P2P[1];  # Place reachable on R1 by consolidated edge
                    len := P2P[2]; # length of consolidated edge
                    v := LBGVertexForLoc(lbg, Location(P2));
                    for nu1 in DigraphInEdges(lbg, v) do
                        for nu2 in DigraphOutEdges(lbg, v) do
                            if Colour(nu2) = Colour(P2) then
                                xi1 := Vertex(nu1, P2, nu2);
                                if Colour(P2) = "green" then
                                    Add(res, [P2,len,xi1]);
                                elif Colour(P2) = "red" then
                                    #X is this application of OneStepRedCase correct?
                                    next := OneStepRedCase(P2);
                                    Append(res, List(next, x -> [x[1], len + 1, x[3] + xi1]));
                                    #Append(OneStepByPlace[__ID(P)], List(next, x -> [x[1], l + 1, x[3] + xi1]));
                                    # Add(OneStepByPlace[__ID(P)], [Q,l+1,xi1 + xi2])
                                else
                                    Error("Invalid colour");
                                fi;
                            fi;
                        od;
                    od;
                od;
            fi
            ;
        od;
        return res;
    end;

    # for every place we compute a list of
    # one-step reachable places
    for P in Places(pres) do
        if Colour(P) = "red" then
            OneStepByPlace[__ID(P)] := OneStepRedCase(P);
        elif Colour(P) = "green" then
            OneStepByPlace[__ID(P)] := OneStepGreenCase(P);
        else
            Error("Invalid colour for place ", P, "\n");
        fi;
    od;
    return OneStepByPlace;
end);

# The RSym tester
# The epsilon is chosen by the user
InstallMethod(RSymTest, "for a pregroup presentation, and a float",
              [IsPregroupPresentation, IsFloat],
function(pres, eps)
    local i, j, rel, R,
          places, Ps, P, Q, Pq,
          osrp, # a one-step reachable place
          L,
          zeta,
          xi, osr, psip, pp;
    zeta := Maximum(Int(Round((6 * (1 + eps)) + 1/2)),
                       LengthLongestRelator(pres));
    Print("RSymTest start\n");
    Print("zeta: ", zeta, "\n");
    osr := OneStepReachablePlaces(pres);

    for rel in Relators(pres) do
        places := Places(rel);
        for Ps in places do
            L := [ [Ps, 0, 0, 0] ]; # This list is called L in the paper
            # The meaning of the components of the quadruples q is
            # - q[1] is a place 
            # - q[2] is the distance of q[1] from Ps
            # - q[3] is the number of steps that q[1] is from Ps
            # - q[4] is a curvature value
            for i in [1..zeta] do
                for Pq in L do      # Pq is for "PlaceQuadruple", which is
                                    # a silly name
                    if Pq[3] = i - 1 then  # Reachable in i - 1 steps
                        for osrp in osr[__ID(Pq[1])] do
                            if Pq[2] + osrp[2] <= Length(rel) then
                                psip := Pq[4]
                                        + osrp[2] * (1 + eps) / Length(rel)
                                        + osrp[3];
                                if psip < 0.0 then
                                elif (Pq[4] > 0.0) and
                                     (osrp[1] = Ps) and
                                     (Pq[2] + osrp[2] = Length(rel)) then
                                    return [fail, L];
                                else
                                    pp := PositionProperty(L, x -> (x[1] = osrp[1]) and (x[2] = Pq[2]));
                                    if pp = fail then
                                        Add(L, [osrp[1], Pq[2] + osrp[2], i, psip] );
                                    else
                                        # Can there be more than one such entry?
                                        if L[pp][4] > psip then
                                            L[pp][3] := i;
                                            L[pp][4] := psip;
                                        fi;
                                    fi;
                                fi;
                            fi;
                        od;
                    fi;
                od;
            od;
        od;
    od;

    return true;
end);
