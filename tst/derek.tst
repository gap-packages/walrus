# Examples that Derek sends me

gap> G1 := CyclicGroup(3);;
gap> pg := PregroupOfFreeProduct(G1,G1);
<pregroup with 5 elements in table rep>
gap> rel := [2,5,3,4,3,4,3,4,3,5,2,4,3,5,2,4,3,5,3,4,2,4,3,5];
[ 2, 5, 3, 4, 3, 4, 3, 4, 3, 5, 2, 4, 3, 5, 2, 4, 3, 5, 3, 4, 2, 4, 3, 5 ]
gap> pgp := NewPregroupPresentation(pg,[pg_word(pg,rel)]);
<pregroup presentation with 4 generators and 1 relators>
gap> res := RSymTest(pgp, 0);;
gap> IsList(res) and res[1] = fail;
true
