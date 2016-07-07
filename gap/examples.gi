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

