# Examples/Tests for ANATPH

# Pregroup presentation for triangle group
pg_word := function(pg, l) return List(l, x->pg[x]);
           end;

Repeat := function(n, l);
    return ShallowCopy(Flat(ListWithIdenticalEntries(n,l)));
end;

# Triangle Groups
# ---------------
# As demonstrated in Proposition 9.4 of anatph, for l > 2 (and hence n > 3 if the
# group is supposed to be hyperbolic) there are no instantiable green places, and if
# l = 2 then there are exactly two instantiable green places.
InstallGlobalFunction("TriangleGroup",
function(l,m,n)
    local pg;
    pg := PregroupFromFreeProduct( CyclicGroup( IsPermGroup, l)
                                 , CyclicGroup( IsPermGroup, m)
                                 , () );
    # This is a bit icky, we can't tell which element of pg is the one of the
    # second cyclic group
    return NewPregroupPresentation(pg, [ pg_word( pg, Repeat(n, [2, l + 1]))]);
end);

# Example from Theorem 9.5, triangle-like: quotient of 2-3-m triangle group
# our choice of pregroup is the free product of cyclic groups of order 2 and 3
#T see what happens if we present this group as
#T <x,y,z | x^2, y^3, z^m, (zxY)^n > ?
#T we push a parameter into the pregroup
InstallGlobalFunction(TriSH,
function(m,n)
    local pg;
    pg := PregroupFromFreeProduct( CyclicGroup( IsPermGroup, 2)
                                 , CyclicGroup( IsPermGroup, 3)
                                 , () );
    # Do this to have slightly nicer display. Maybe we need to give the user
    # a way to label generators
    pg!.enams := "1xyY";
    return NewPregroupPresentation(pg,
                                   [ pg_word(pg, Repeat(m, [2,3])),
                                     pg_word(pg, Repeat(n, [2,3,2,4]))
                                   ]);
end);

trish_3_3  := TriSH(3,3);
trish_13_7 := TriSH(13,7);
trish_4_10 := TriSH(4,10);
trish_8_19 := TriSH(8,19);

# Given a pregroup make a random presentation with nrel relators
# of length lrel
InstallGlobalFunction(RandomPregroupPresentation,
function(pg, nrel, lrel)
    local pp, rel, rels, i, j, lett;
    
    rels := [];
    for i in [1..nrel] do
        rel := [];
        Add(rels,rel);
        lett := Random([2..Size(pg)]);
        Add(rel, lett);
        for j in [2..lrel-1] do
            lett := Random(Difference([2..Size(pg)],[lett]));
            Add(rel, lett);
        od;
        # this is bound to go wrong if we only have 2 generators,
        # but then our group is a quotient of free of rank 1...
        lett := Random(Difference([2..Size(pg)],[lett,rel[1]]));
        Add(rel, lett);
    od;
    return NewPregroupPresentation(pg, List(rels, r -> pg_word(pg, r)));
end);

BindGlobal("BenchmarkRandomPresentation",
function(eps, nrel, lrel, nexs)
    local i, pg, pgp, start, stop, estart, estop, n, nfail, res, runt;
    
    pg := PregroupFromFreeProduct( CyclicGroup( IsPermGroup, 2)
                                 , CyclicGroup( IsPermGroup, 3)
                                 , () );
    pg!.enams := "1xyY";
    n := 0;
    nfail := 0;
    runt := [];

    start := NanosecondsSinceEpoch();
    for i in [1..nexs] do
        Print("creating example nr ", i, ", \c");
        n := n+1;
        pgp := RandomPregroupPresentation(pg, nrel, lrel);
        Print("starting RSymTest, \c");
        estart := NanosecondsSinceEpoch();
        res := RSymTest(pgp, eps);
        estop := NanosecondsSinceEpoch();
        if res = true then
            Print("succeeded after \c");
        else
            Print("failed \c");
            nfail := nfail + 1;
        fi;
        Print(Float((estop - estart) / 1000000000), " seconds\n");
        Add(runt, [pgp, res, estop - estart]);
    od;
    stop := NanosecondsSinceEpoch();
    return [(stop - start) / 1000000000, runt];
end);

BindGlobal("BenchmarkRandomPresentationSeries",
function(rellengths)

end);
