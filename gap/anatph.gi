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


# Alternative to LocationBlobGraph, only has pairs, coloured Green for location pair
# and red for intermult pair
# a bit hacky though
InstallMethod(VertexGraph, "for a pregroup presentation",
              [IsPregroupPresentation and IsPregroupPresentationRep],
function(pres)
    local v, vd, vg, e, loc, loc2, pg, p, ploc, ploc2, imp, i, backmap, len;

    pg := Pregroup(pres);

    # 0 - green, 1 - red
    v := Set([]);
    vd := NewDictionary([One(pg), One(pg), 0], true);
    for loc in Locations(pres) do
        p := [InLetter(loc), OutLetter(loc), 0];
        ploc := LookupDictionary(vd, p);
        if ploc = fail then
            AddDictionary(vd, p, [loc]);
            AddSet(v, p);
        else
            Add(ploc, loc);
        fi;
    od;
    for imp in IntermultPairs(pg) do
        p := [imp[1],imp[2], 1];
        AddDictionary(vd, p, []);
        AddSet(v, p);
    od;

    e := function(a,b)
        if (a[3] = 0) and (b[3] = 0) then # both vertices are green
            if PregroupInverse(a[2]) = b[1] then # There are locations R(i,a,b) and R'(j,b^-1,c)
                ploc := LookupDictionary(vd, a);
                ploc2 := LookupDictionary(vd, b);
                for loc in ploc do
                    for loc2 in ploc2 do
                        if CheckReducedDiagram(loc, loc2) then
                            return true;
                        fi;
                    od;
                od;
                return false;
            fi;
        elif (a[3] = 0) and (b[3] = 1) then # a is green, b is red
            if PregroupInverse(a[2]) = b[1] then # There is location R(i,a,b)
                return true; # weight 1
            fi;
        elif (a[3] = 1) and (b[3] = 0) then # a is red, b is green
            if PregroupInverse(a[2]) = b[1] then #
                return true; # weight 0
            fi;
        fi;
        return false;
    end;
    len := Size(pg);
    backmap := ListWithIdenticalEntries(len * len * 2 + 1, 0);
    backmap[Length(backmap)] := [len, len, 2];
    for i in [1..Length(v)] do
        backmap[
                 coordinateF( backmap[Length(backmap)]
                            , [__ID(v[i][1]), __ID(v[i][2]), v[i][3] + 1] )
            ] := i;
    od;
    vg := Digraph(v,e);
    SetDigraphVertexLabels(vg, v);
    vg!.backmap := backmap;
    return vg;
end);

InstallMethod(VertexGraphDistances, "for a pregroup presentation",
              [IsPregroupPresentation and IsPregroupPresentationRep],
function(pres)
    local vg, wt, f;

    vg := VertexGraph(pres);
    wt := function(i,j)
        local a,b;
        a := DigraphVertexLabel(vg, i);

        if (a[3] = 0) then # edges originating at green vertex
                           # have weight 1
            return 1;
        elif (a[3] = 1) then # edges originating at red vertex
                             # have weight 0
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
    return DigraphFloydWarshall(vg, f, infinity, -1 );
end);

InstallMethod(VertexTriples, "for a pregroup presentation",
            [IsPregroupPresentation and IsPregroupPresentationRep],
function(pres)
    local v, v1, v2, v1l, v2l, vl, vg, lv, vgd, dist, vtl;

    vg := VertexGraph(pres);
    vgd := VertexGraphDistances(pres);
    vtl := [];

    for v in DigraphVertices(vg) do
        lv := HTCreate([0,0]);
        vtl[v] := lv;

        vl := DigraphVertexLabel(vg, v);
        # Only green vertices
        if (vl[3] = 0) then
          for v1 in InNeighboursOfVertex(vg, v) do
              v1l := DigraphVertexLabel(vg, v1);
              for v2 in OutNeighboursOfVertex(vg, v) do
                  v2l := DigraphVertexLabel(vg, v2);
                  dist := vgd[v2][v1];
                  if (v1l[3] = 0) and (v2l[3] = 0) then
                      if dist = 1 then
                          HTAdd(lv, [v1, v2], 1/6);
                      elif dist = 2 then
                          HTAdd(lv, [v1, v2], 1/4);
                      elif dist = 3 then
                          HTAdd(lv, [v1, v2], 3/10);
                      elif dist > 3 then
                          HTAdd(lv, [v1, v2], 1/3);
                      else
                          Error("this shouldn't happen");
                      fi;
                  elif (v1l[3] = 0) and (v2l[3] = 1) then
                      if dist = 0 then
                          HTAdd(lv, [v1,v2], 0);
                      elif dist = 1 then
                          HTAdd(lv, [v1,v2], 1/6);
                      elif dist > 1 then
                          HTAdd(lv, [v1,v2], 1/4);
                      else
                          Error("this shouldn't happen");
                      fi;
                  elif (v1l[3] = 1) and (v2l[3] = 0) then
                      if dist = 1 then
                          HTAdd(lv, [v1,v2], 0);
                      elif dist = 2 then
                          HTAdd(lv, [v1,v2], 1/6);
                      elif dist > 2 then
                          HTAdd(lv, [v1,v2], 1/4);
                      else
                          Error("this shouldn't happen");
                      fi;
                  elif (v1l[3] = 1) and (v2l[3] = 1) then
                      HTAdd(lv, [v1,v2], 0);
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

InstallGlobalFunction(Vertex,
function(pres, v1, v, v2)
    local vt, t;

   t := HTValue(VertexTriples(pres)[v], [v1,v2]);
   if t <> fail then
       return t;
   else
       return 1/3;
   fi;


    #if v1 = fail then
    #    Error("v1 was fail");
    #fi;
    vt := VertexTriples(pres)[v];
    for t in vt do
        if (t[1] = v1) and (t[2] = v2) then
            return t[3];
        fi;
    od;
    Print("for ", [v1,v,v2], " fallback?\n");
    if (v1 = v) or (v = v2) then
        Error("wat?");
    fi;
    return 1/3;
    # Or should it?
    Error("This shouldn't happen");
    return fail;
end);

#XXX Computes triples (a,b,c) that are infixes
#    of strings found here with appropriate numbers
InstallMethod(ShortRedBlobIndex, "for a pregroup presentation",
              [IsPregroupPresentation],
function(pres)
    local pg, n, imm, index, nrl, cand, word, nonrletts, len, c
    ;

    pg := Pregroup(pres);
    n := Size(pg);
    imm := IntermultMapIDs(pg);

    index := ListWithIdenticalEntries(n ^ 3 + 1, 5/14);
    index[Length(index)] := [n,n,n];
        #HTCreate([0,0,0], rec( hashlen := NextPrimeInt(Size(Pregroup(pres)) ^ 3 )));

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
InstallMethod(Blob, "for a pregroup presentation, an element, an element, and an element"
              , [ IsPregroupPresentation
                , IsElementOfPregroup
                , IsElementOfPregroup
                , IsElementOfPregroup ],
function(pres, a, b, c)
    local it, v, n;

    n := Size(Pregroup(pres));
    it := ShortRedBlobIndex(pres);
    return it[coordinateF([n,n,n], [__ID(a), __ID(b), __ID(c)])];

    v := HTValue(it, [__ID(a), __ID(b), __ID(c)]);
    if v = fail then
        v := 5/14;
    fi;
    return v;

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

# TODO: Use a map
InstallGlobalFunction(VertexFor,
function(vg, trip)
    local ltrip;
    ltrip := [__ID(trip[1]), __ID(trip[2]), trip[3] + 1];
    return vg!.backmap[coordinateF(vg!.backmap[Length(vg!.backmap)], ltrip)];

    # Linear scan, is not too bad as long
    # Pregroup is small
#   local v;
#   for v in DigraphVertices(vg) do
#       if DigraphVertexLabel(vg, v) = trip then
#           return v;
#       fi;
#   od;
#   return fail;
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

# The RSym tester
# The epsilon is chosen by the user
InstallMethod(RSymTest, "for a pregroup presentation, and a float",
              [IsPregroupPresentation, IsObject],
function(pres, eps)
    local i, j, rel, R, pplaces,
          places, Ps, P, Q, Pq,
          osrp, # a one-step reachable place
          L,
          zeta,
          xi, psip, pp;
    # Make sure epsilon is a float
    # FIXME: To experiment and find out about rounding errors
    #        we try running this thing with rationals
    eps := Rat(eps);
    # FIXME: Deleted Round() for rationals experiment
    # FIXME: CAREFUL, if the zeta value is wrong, the RSymTester
    #        does not work correctly
    zeta := Minimum(Int(6 * (1 + eps) + 1) - 1,
                    LengthLongestRelator(pres));
    Info(InfoANATPH, 10
         , "RSymTest start");
    Info(InfoANATPH, 10
         , "zeta: ", zeta);

    pplaces := Places(pres);

    for rel in Relators(pres) do
        Info(InfoANATPH, 20
             , "relator: ", ViewString(rel), "\n");
        places := Places(rel);
        for Ps in places do
            Info(InfoANATPH, 20
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
                Info(InfoANATPH, 30
                     , STRINGIFY("L = ", ViewString(L)), ", i = ", i);
                for Pq in L do      # Pq is for "PlaceQuadruple", which is
                                    # a silly name
                    Info(InfoANATPH, 30,
                         STRINGIFY("Considering: ", Pq));
                    if Pq[3] = i - 1 then  # Reachable in i - 1 steps
                        for osrp in Keys(OneStepReachablePlaces(pplaces[Pq[1]])) do
                            Info(InfoANATPH, 30,
                                 STRINGIFY("OneStepReachable: ", osrp));
                            if Pq[2] + osrp[2] <= Length(rel) then
                                psip := Rat(Pq[4])
                                        + osrp[2] * (1 + eps) / Length(rel)
                                        # storing positive values -> subtract here
                                        - Rat(Lookup(OneStepReachablePlaces(pplaces[Pq[1]]), osrp[1], osrp[2]));
                                Info(InfoANATPH, 30
                                     , STRINGIFY("psi' = "
                                                , Rat(Pq[4]), " + "
                                                , osrp[2] * (1+eps) / Length(rel), " - "
                                                , Lookup(OneStepReachablePlaces(pplaces[Pq[1]]), osrp[1], osrp[2]), " = "
                                                , psip, "\n")
                                    );
                                if psip < 0 then
                                elif (Rat(Pq[4]) > 0) and
                                     (osrp[1] = __ID(Ps)) and
                                     (Pq[2] + osrp[2] = Length(rel)) then
                                    return [fail, L, Pq];
                                else
                                    pp := PositionProperty(L, x -> (x[1] = osrp[1])
                                                              and (x[2] = Pq[2] + osrp[2]));
                                    if pp = fail then
                                        Add(L, Immutable([osrp[1], Pq[2] + osrp[2], i, psip]) );
                                    else
                                        if L[pp][4] > psip then
                                            L[pp] := Immutable([-1, -1, -1, -1]); # to not confuse the loop over "L"
                                            Add(L, Immutable([osrp[1], Pq[2] + osrp[2], i, psip]));
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
