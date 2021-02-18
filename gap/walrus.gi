########################################################################
#
# walrus: Computational Methods for Finitely Generated Monoids and Groups
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
#  - MakeIsReducedDiagram an operation
#  - Sort out families of elements etc
#  - what to do about the __ID hack?
#  - What to do about float vs rational?
#  - provide a way to label generators
#  - Introduce an InfoLevel and log things with info levels, remove Print
#    statements
#  - Put relators of different presentations into different families
#  - Check whether some sub-functions could be cleaned out from functions
#    and would become more generally useful
#  - Better indexing of locations on relator/places
#  - Better datastructure for storing one step reachables
#    (basically a hashmap from orb I think) plus wrapper functions
#  - PlaceQuadruples should be an object or a record
#  - Add proper error messages for "This shouldn't happen" with a pointer
#    towards the github issue tracker
#  - Make a reasonably standard format (and exporter/importer) to exchange
#    pregroup presentations so we can move them between GAP/other
#    implementations for cross-checking

#
# TODO (mathematical/functional)
#  - Write tests
#  - Interleaving
#  - Preparing the presentation (User choosing Pregroup/removing generators, relators)
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

# Alternative to LocationBlobGraph, only has pairs, coloured Green for location pair
# and red for intermult pair
# a bit hacky though
InstallMethod(VertexGraph, "for a pregroup presentation",
              [IsPregroupPresentation and IsPregroupPresentationRep],
function(pres)
    local mat, v, vd, vg, e, loc, loc2, pg, p, ploc, ploc2, imp, i, backmap, len, li, labels;

    pg := Pregroup(pres);

    li := LocationIndex(pres);

    # Green vertices [[a, b], 0] correspond to locations
    v := List(Keys(li), l -> [l, 0]);
    # Red vertices correspond to intermult pairs
    Append(v, List(IntermultPairs(pg), p -> [p, 1]));

    e := function(a,b)
        if (a[2] = 0) and (b[2] = 0) then              # both vertices are green
            if PregroupInverse(a[1][2]) = b[1][1] then # There are locations R(i,a,b) and R'(j,b^-1,c)
                ploc := li[a[1]];
                ploc2 := li[b[1]];
                for loc in ploc do
                    for loc2 in ploc2 do
                        if CheckReducedDiagram(loc, loc2) then
                            return 1;
                        fi;
                    od;
                od;
                return infinity;
            fi;
        elif (a[2] = 0) and (b[2] = 1) then            # a is green, b is red
            if PregroupInverse(a[1][2]) = b[1][1] then # There is location R(i,a,b)
                return 1;
            fi;
        elif (a[2] = 1) and (b[2] = 0) then            # a is red, b is green
            if PregroupInverse(a[1][2]) = b[1][1] then #
                return 0;
            fi;
        fi;
        return infinity;
    end;

    backmap := HashMap();
    for i in [1..Length(v)] do
        backmap[ [__ID(v[i][1][1]), __ID(v[i][1][2]), v[i][2] ] ] := i;
    od;

    vg := Digraph(v, {i,j} -> e(i,j) <> infinity);
    SetDigraphVertexLabels(vg, v);
 
    mat := List(DigraphVertices(vg), i -> List(DigraphVertices(vg), j -> e(v[i], v[j]) ) );
    vg!.mat := mat;
    vg!.backmap := backmap;

    return vg;
end);

InstallMethod(VertexGraphDistances, "for a pregroup presentation",
              [IsPregroupPresentation and IsPregroupPresentationRep],
function(pres)
    local vg, wt, f, vertices, n, mat, i, j, k, a, b, t, out;

    vg := VertexGraph(pres);
    vertices := DigraphVertices(vg);
    mat := vg!.mat;

#    SC_FLOYD_WARSHALL(mat);

    for k in vertices do
        for i in vertices do
            for j in vertices do
                t := mat[i, k] + mat[k, j];
                if t < mat[i,j] then
                    mat[i,j] := t;
                fi;
            od;
        od;
    od;
    # Can there be more than one such entry?
    return mat;
end);

InstallMethod(VertexTriples, "for a pregroup presentation",
            [IsPregroupPresentation and IsPregroupPresentationRep],
function(pres)
    local v, v1, v2, v1l, v2l, vl, vg, lv, vgd, dist, vtl;

    vg := VertexGraph(pres);
    vgd := VertexGraphDistances(pres);
    vtl := HashMap(16384);

    for v in DigraphVertices(vg) do

        vl := DigraphVertexLabel(vg, v);
        # Only green vertices
        if (vl[2] = 0) then
          for v1 in InNeighboursOfVertex(vg, v) do
              v1l := DigraphVertexLabel(vg, v1);
              for v2 in OutNeighboursOfVertex(vg, v) do
                  v2l := DigraphVertexLabel(vg, v2);
                  dist := vgd[v2][v1];
                  if (v1l[2] = 0) and (v2l[2] = 0) then
                      if dist = 1 then
                          vtl[ [v, v1, v2 ] ] := 1/6;
                      elif dist = 2 then
                          vtl[ [ v, v1, v2 ] ] := 1/4;
                      elif dist = 3 then
                          vtl[ [ v, v1, v2 ] ] := 3/10;
                      elif dist > 3 then
                          vtl[ [ v, v1, v2 ] ] := 1/3;
                      else
                          Error("this shouldn't happen");
                      fi;
                  elif (v1l[2] = 0) and (v2l[2] = 1) then
                      if dist = 0 then
                          vtl[ [ v, v1, v2 ] ] := 0;
                      elif dist = 1 then
                          vtl[ [ v, v1, v2 ] ] := 1/6;
                      elif dist > 1 then
                          vtl[ [ v, v1, v2 ] ] := 1/4;
                      else
                          Error("this shouldn't happen");
                      fi;
                  elif (v1l[2] = 1) and (v2l[2] = 0) then
                      if dist = 1 then
                          vtl[ [ v, v1, v2 ] ] := 0;
                      elif dist = 2 then
                          vtl[ [ v, v1, v2 ] ] := 1/6;
                      elif dist > 2 then
                          vtl[ [ v, v1, v2 ] ] := 1/4;
                      else
                          Error("this shouldn't happen");
                      fi;
                  elif (v1l[2] = 1) and (v2l[2] = 1) then
                      vtl[ [ v, v1, v2 ] ] := 0;
                      # what if dist=infinity (i.e. no path)
                  else
                      Error("this should not happen");
                  fi;
              od;
          od;
        fi;
    od;
    return vtl;
end);

InstallGlobalFunction(WalrusVertex,
function(pres, v1, v, v2)
    local vt, t;

    t := VertexTriples(pres)[ [v, v1, v2] ];
    if t <> fail then
        return t;
    else
        return 1/3;
    fi;
end);

#XXX Computes triples (a,b,c) that are infixes
#    of strings found here with appropriate numbers
InstallMethod(ShortRedBlobIndex, "for a pregroup presentation",
              [IsPregroupPresentation],
function(pres)
    local pg, n, imm, index, nrl, cand, word, nonrletts, len, c;

    pg := Pregroup(pres);
    n := Size(pg);
    imm := IntermultMapIDs(pg);

    # TODO: This would be better done by a tree structure
    index := HashMap();

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
                if (len = 6) then
                    len := len - 1;
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
InstallMethod(Blob, "for a pregroup presentation, an element, an element, and an element"
              , [ IsPregroupPresentation
                , IsElementOfPregroup
                , IsElementOfPregroup
                , IsElementOfPregroup ],
function(pres, a, b, c)
    local it, v, n;

    n := Size(Pregroup(pres));
    it := ShortRedBlobIndex(pres);
    v := it[ [__ID(a), __ID(b), __ID(c)] ];

    if v <> fail then
        return v;
    fi;
    return 5/14;
end);

# TODO: Use a map
InstallGlobalFunction(VertexFor,
function(vg, trip)
    return vg!.backmap[ [ __ID(trip[1]), __ID(trip[2]), trip[3] ] ];
end);

# Compute a list of
#  - places reachable from loc1 on Relator(loc1), and
#  - the corresponding location on Relator(loc2)
# by a consolidated edge between Relator(loc1) and Relator(loc2)
InstallGlobalFunction(ConsolidatedEdgePlaces,
function(loc1, loc2)
    local res, length, r1_loc, r2_loc, r1_length;

    res := [];
    length := 0;

    r1_loc := loc1;
    r2_loc := loc2;
    r1_length := Length(Relator(loc1));

    if OutLetter(r1_loc) <> PregroupInverse(InLetter(r2_loc)) then
        Error("This shouldn't happen");
#        return [];
    fi;

    repeat
        r1_loc := NextLocation(r1_loc);
        r2_loc := PrevLocation(r2_loc);
        length := length + 1;
        Append(res, List(Places(r1_loc), x -> [x, r2_loc, length]));
    until (OutLetter(r1_loc) <> PregroupInverse(InLetter(r2_loc)))
          or (length = r1_length);

    # Meh.
    if (length = r1_length) or
       (length = Length(Relator(loc2))) then
        return [];
    else
        return res;
    fi;
end);

# Helper function to add or update
# a "place quadruple"
AddOrUpdatePQ := function(L, pq)
    local pp;

    pp := PositionProperty(L, x -> x[1] = pq[1] and x[2] = pq[2]);
    if pp = fail then
        Add(L, Immutable(pq));
    else
        if L[pp][4] < pq[4] then
            L[pp] := Immutable(pq);
        fi;
    fi;
end;

# The RSym tester
# The epsilon is chosen by the user
InstallMethod(RSymTestOp, "for a pregroup presentation, and a rational",
              [IsPregroupPresentation, IsRat],
function(pres, eps)
    local i, j, rel, R, pplaces,
          places, Ps, P, Q, Pq,
          osrp, # a one-step reachable place
          osrpp,
          L,
          zeta,
          xi, psip, pp;
    # Make sure epsilon is a float
    # FIXME: To experiment and find out about rounding errors
    #        we try running this thing with rationals
    eps := Rat(eps);
    # FIXME: CAREFUL, if the zeta value is wrong, the RSymTester
    #        does not work correctly
    zeta := Minimum(Int(6 * (1 + eps) + 1) - 1,
                    LengthLongestRelator(pres));
    Info(InfoWalrus, 10
         , "RSymTest start");
    Info(InfoWalrus, 10
         , "zeta: ", zeta);

    # Precompute some things so it doesn't show up in weird places
    # in the profiling data
    # Some of this we might want to compute on demand?
    VertexGraphDistances(pres);
    pplaces := Places(pres);
    if not IsEmpty(pplaces) then
        OneStepReachablePlaces(pplaces[1]);
    fi;

    for rel in Relators(pres) do
        Info(InfoWalrus, 20
             , "relator: ", ViewString(rel), "\n");
        places := Places(rel);
        for Ps in places do
            Info(InfoWalrus, 20
                 , "  start place: "
                 , ViewString(Ps)
                 , "\n" );
            L := [ [__ID(Ps), 0, 0, 0] ]; # This list is called L in the paper
            # This is the list of possible decompositions
            # The meaning of the components of the quadruples q is
            # - q[1] is a place
            # - q[2] is the distance of q[1] from Ps
            # - q[3] is the number of steps that q[1] is from Ps
            # - q[4] is a curvature value
            for i in [1..zeta] do
                Info(InfoWalrus, 30
                     , STRINGIFY("L = ", ViewString(L)), ", i = ", i);
                for Pq in L do      # Pq is for "PlaceQuadruple", which is
                                    # a silly name
                    Info(InfoWalrus, 30,
                         STRINGIFY("Considering: ", Pq));
                    if Pq[3] = i - 1 then  # Reachable in i - 1 steps
                        osrpp := OneStepReachablePlaces(pplaces[Pq[1]]);
                        for osrp in Keys(osrpp) do
                            Info(InfoWalrus, 30,
                                 STRINGIFY("OneStepReachable: ", osrp));
                            if Pq[2] + osrp[2] <= Length(rel) then
                                psip := Pq[4]
                                        + osrp[2] * (1 + eps) / Length(rel)
                                        # storing positive values -> subtract here
                                        - osrpp[osrp];
                                Info(InfoWalrus, 30
                                     , STRINGIFY("psi' = "
                                                , Pq[4], " + "
                                                , osrp[2] * (1+eps) / Length(rel), " - "
                                                , osrpp[osrp], " = "
                                                , psip, "\n")
                                    );
                                if psip < 0 then
                                elif (Pq[4] > 0) and
                                     (osrp[1] = __ID(Ps)) and
                                     (Pq[2] + osrp[2] = Length(rel)) then
                                    # Add the place that caused the failure
                                    Add( L, Immutable( [ osrp[1], Pq[2] + osrp[2], i, psip ] ) );
                                    return [fail, L, Pq];
                                else
                                    AddOrUpdatePQ(L, [osrp[1], Pq[2] + osrp[2], i, psip]);
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


InstallGlobalFunction(RSymTest,
function(args...)
    local pg, pgp, rgreen, inv;

    if Length(args) >= 2 then
        if IsPregroupPresentation(args[1]) then
            return RSymTestOp(args[1], args[2]);
        fi;
        if IsFreeGroup(args[1]) then
            pgp := PregroupPresentationFromFp(args[1], args[2], args[3]);
            return RSymTestOp(pgp, args[4]);
        fi;
    else
        # TODO: Usage message
    fi;
end);

InstallMethod(IsHyperbolic, "for a free group, a list, a list, and a rational number",
              [IsFreeGroup, IsObject, IsObject, IsRat],
              {freeg, rrel, grel, eps} -> RSymTest(freeg, rrel, grel, eps));


InstallMethod(IsHyperbolic, "for a pregroup presentation, and a rational number",
              [IsPregroupPresentation, IsRat],
              {pres, eps} -> RSymTest(pres,eps));

