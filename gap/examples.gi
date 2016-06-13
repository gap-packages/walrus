# Examples/Tests for ANATPH

# Pregroup for triangle group example
tg_pg := PregroupByTable("1xyY"
                          , a -> a ^ (3,4)
                          , [ [1,2,3,4],
                              [2,1,0,0],
                              [3,0,4,1],
                              [4,0,1,3] ]
                          );
TriangleGroupPregroup := tg_pg;

# Pregroup presentation for triangle group
pg_word := function(pg, l) return List(l, x->pg[x]);
           end;

tg_pgp := NewPregroupPresentation(tg_pg, [pg_word(tg_pg, [2,3,2,3,2,3,2,3]), pg_word(tg_pg,[3,2,3,2,3,2,3,2])]);

TriangleGroupPGP := tg_pgp;

pgtbl := function()
    local e1, e2, sgp, tbl, elts, nelts, a, b,
          pa, pb, s1p, s2p, pr, invs,
          sgpi, s1pi, s2pi, sgpp;


    sgpp := Elements(Group((1,2,3)));
    sgp := List(Elements(Group((1,2,3))), x -> [1,x]);
    s1p := List(Difference(Elements(SymmetricGroup(3)), sgpp), x -> [2,x]);
    s2p := List(Difference(Elements(SymmetricGroup(4)), sgpp), x -> [3,x]);
    elts := Concatenation(sgp,s1p,s2p);
    invs := List(elts, x -> Position(elts, [x[1],x[2]^-1] ));

    nelts := Length(elts);

    tbl := List([1..nelts], x -> [1..nelts] * 0);

    for a in elts do
        for b in elts do
            pa := Position(elts, a);
            pb := Position(elts, b);

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
		            Error("wat.");
	          fi;
            tbl[pa][pb] := pr;
        od;
    od;

    return [elts, SortingPerm(invs), tbl];
end;

# A clumsy approach to making a pregroup
# with a non-trivial intermult pair: its the union
# of SymmetricGroup(3) and SymmetricGroup(4) amalgamating
# Group((1,2,3))
#T To be superseded by PregroupFromFreeProduct
#T as soon as I got amalgamation to work
tbl := pgtbl();
inmp_pg := PregroupByTable("1abcdefghijklmnopqrstuvwxyz", x->x^tbl[2], tbl[3]);

alp := Generators(tg_pgp);
exw := [alp[1], alp[2], alp[3]];
