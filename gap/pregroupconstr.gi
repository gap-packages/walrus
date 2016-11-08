# Takes two groups, and builds the pregroup underlying the free product of
# these two groups amalgamating the third one.
#
# don't try using this on large groups.
#
#T provide embedding alm -> G1,G2 for amalgamation?
#T at the moment we do not almagamate at all
InstallGlobalFunction(PregroupFromFreeProduct,
function(G1, G2, alm)
    local e1, e2, sgp, tbl, elts, nelts, a, b,
          pa, pb, s1p, s2p, pr, sgpi, s1pi,
          s2pi, sgpp, eltn       # Names for elements
    ;

    # Subgroup of G1 and G2 that we amalgamate
    sgpp := [()];
    sgp := [[1,()]];
    #List(Elements(alm), x -> [1,x]);
    s1p := List(Difference(Elements(G1), sgpp), x -> [2,x]);
    s2p := List(Difference(Elements(G2), sgpp), x -> [3,x]);
    elts := Concatenation(sgp,s1p,s2p);
    eltn := List(elts, x -> ViewString(x));

    nelts := Length(elts);

    tbl := List([1..nelts], x -> [1..nelts] * 0);

    for pa in [1..nelts] do
        for pb in [1..nelts] do
            a := elts[pa];
            b := elts[pb];

            if a[1] = b[1] then
                pr := Position(elts, [a[1], a[2] * b[2]]);
		            if pr = fail then
			              pr := Position(elts, [1, a[2] * b[2]]);
		            fi;
            elif (a[1] = 1 and b[1] = 2) or
                 (a[1] = 2 and b[1] = 1) then
                pr := Position(elts, [2, a[2] * b[2]]);
                if pr = fail then
                    pr := Position(elts, [1, a[2] * b[2]]);
                fi;
            elif (a[1] = 1 and b[1] = 3) or
                 (a[1] = 3 and b[1] = 1) then
                pr := Position(elts, [3, a[2] * b[2]]);
                if pr = fail then
                    pr := Position(elts, [1, a[2] * b[2]]);
                fi;
            else
                pr := 0;
            fi;
	          if pr = fail then
		            Error("Could not determine product of ", a, " and ", b, ".\n");
	          fi;
            tbl[pa][pb] := pr;
        od;
    od;
    return PregroupByTable(eltn, tbl);
end);

