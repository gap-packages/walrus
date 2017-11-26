gap> PregroupByTable("1xyY", [[1]]);
Error, PregroupByTable: Length of enams does not match number of rows in table
gap> PregroupByTable("1xyY", [[],[],[],[]]);
Error, PregroupByTable: Multiplication table is not square
gap> PregroupByTable("1xyY", [[1,2,3,4],[1,2,3,4],[1,2,3,4],[1,2,3,4]]);
Error, inverses not well-defined
gap> PregroupByTable("1xyY", [[1,2,3,4],[2,2,3,4],[3,2,3,4],[4,2,3,4]]);
Error, PregroupByTable: inverses
gap> p := PregroupByTable("1xyY", [[1,2,3,4],[2,1,0,0],[3,0,4,1],[4,0,1,3]]);
<pregroup with 4 elements in table rep>
gap> p[1] * p[2];
'x'
gap> p[2] * p[3];
fail
gap> pgps := List(ANATPH_small_pregroups[6], tbl -> PregroupByTable([1..6], tbl));;
gap> Length(pgps);
28
gap> STOP_TEST("ANATPH: pregroup tests", 1000);
