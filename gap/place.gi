#
# walrus: Computational Methods for Finitely Generated Monoids and Groups
#

## Places
InstallGlobalFunction(NewPlace,
function(loc, c, colour)
    local p;
    p := Objectify(PregroupPlaceType, [loc,c,colour]);
    Add(loc![3], p);
    return p;
end);

InstallMethod(Location
             , "for a pregroup place"
             , [IsPregroupPlaceRep],
             p -> p![1]);

InstallMethod(Relator
             , "for a pregroup place"
             , [IsPregroupPlace],
             p -> Relator(p![1]));

InstallMethod(Letter
             , "for a pregroup place"
             , [IsPregroupPlaceRep],
             p -> p![2]);

InstallMethod(Colour
             , "for a pregroup place"
             , [IsPregroupPlaceRep],
             p -> p![3]);

InstallMethod(NextPlaces
             , "for a pregroup place"
             , [IsPregroupPlaceRep],
function(p)
    if not IsBound(p![6]) then
        p![6] := Places(NextLocation(Location(p)));
    fi;
    return p![6];
end);

AddOrUpdate := function(map, key, val)
    local tmp;

    tmp := map[key];
    if tmp = fail or val < tmp then
        map[key] := val;
    fi;
end;

InstallGlobalFunction(OneStepRedCase,
function(P)
    local Q, Ql
          , b, c, d, x, y
          , Lp
          , v, v1, v2
          , res
          , xi1, xi2, binv, l, onv, pres, vg, xi;

    pres := PregroupPresentationOf(Relator(P));
    res := HashMap(1024);
    vg := VertexGraph(pres);

    c := Letter(P);

    for Q in NextPlaces(P) do
        # same relator, one position up
        Ql := Location(Q);
        b := InLetter(Ql); binv := PregroupInverse(b);
        d := OutLetter(Ql);
        x := Letter(Q);
        v := VertexFor(vg, [b, d, 0]);
        onv := OutNeighboursOfVertex(vg, v);

        for y in IntermultMap(binv) do
            v1 := VertexFor(vg, [y, binv, 1]);
            xi1 := Blob(pres, y, binv, c);
            for v2 in onv do
                #T this check is new, and assuming the paper
                #T is accurate correct
                if DigraphVertexLabel(vg, v2)[1][2] = x then
                    xi2 := WalrusVertex(pres, v1, v, v2);

                    AddOrUpdate(res, [ __ID(Q), 1 ], xi1 + xi2);
                fi;
            od;
        od;
    od;
    # Note this list is not necessarily dense atm.
    return res;
end);

InstallGlobalFunction(OneStepGreenCase,
function(P)
 local L, L2, b, c, loc, pls, is_consoledge, v, v1, v2, xi1, xi2,
       R, R2, P2, P2s, P2T, i, j, next, res, len, n, l, pres, vg,
       P2_loc, P2_inletter, P2_outletter, P2_outletterinv, P2_letter;

    pres := PregroupPresentationOf(Relator(P));
    res := HashMap(1024);
    vg := VertexGraph(pres);

    L := Location(P);
    b := OutLetter(L);
    c := Letter(P);

    # Every place that is instanciated with location that is in an instantiation of
    # a place P'.
    # We're interested in consolidated edges between Relator(P) and Relator(L2)
    # from the locations that P and pls are at.
    #
    # Do we have to check that Relator(P) and Relator(pls) don't entirely cancel?
    for L2 in Locations(pres) do
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

            for P2T in P2s do
                P2 := P2T[1];  # Place reachable on R1 by consolidated edge
                
                P2_loc := Location(P2);
                P2_inletter := InLetter(P2_loc);
                P2_outletter := OutLetter(P2_loc);
                P2_outletterinv := PregroupInverse(P2_outletter);
                P2_letter := Letter(P2);

                # P2T[2] location on R2 reachable by the edge
                len := P2T[3]; # length of consolidated edge
                v1 := VertexFor(vg, [ InLetter(P2T[2]), OutLetter(P2T[2]), 0 ]);
                v := VertexFor(vg, [ P2_inletter, P2_outletter, 0 ]);
                for v2 in OutNeighboursOfVertex(vg, v) do
                    if DigraphVertexLabel(vg, v2)[1][1] = P2_outletterinv and
                       P2_letter = DigraphVertexLabel(vg, v2)[1][2] then

                        xi1 := WalrusVertex(pres, v1, v, v2);
                        if Colour(P2) = "green" then
                            AddOrUpdate(res, [ __ID(P2), len ], xi1);

                        elif Colour(P2) = "red" then
                            next := OneStepRedCase(P2);
                            # testhack
                            for n in Keys(next) do
                                AddOrUpdate( res, [ n[1], len + 1 ]
                                           , xi1 + next[n] );
                            od;
                        else
                            Error("Invalid colour");
                        fi;
                    else

                    fi;
                od;
            od;
        fi;
    od;
    return res;
end);

InstallMethod(OneStepReachablePlaces
             , "for a pregroup place"
             , [IsPregroupPlaceRep],
function(p)
    if not IsBound(p![7]) then
        if Colour(p) = "red" then
            p![7] := OneStepRedCase(p);
        elif Colour(p) = "green" then
            p![7] := OneStepGreenCase(p);
        else
            Error("Invalid colour for place ", p, "\n");
        fi;
    fi;
    return p![7];
end);

InstallMethod(__ID
             , "for a pregroup place"
             , [IsPregroupPlace],
             p -> p![5]);

InstallMethod(ViewString
             , "for a pregroup place"
             , [IsPregroupPlaceRep],
function(p)
    return STRINGIFY("(", ViewString(p![1]),
                     ",", ViewString(p![2]),
                     ",", ViewString(p![3]),
                     ")");
end);

InstallMethod(\=
             , "for two pregroup places"
             , [IsPregroupPlaceRep, IsPregroupPlaceRep],
function(p1, p2)
    return (p1![1] = p2![1])
           and (p1![2] = p2![2])
           and (p1![3] = p2![3]);
end);

