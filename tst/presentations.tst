gap> T := TriangleGroup(2,3,7);;
gap> fp := PregroupPresentationToFpGroup(T);
<fp group on the generators [ f1, f2, f3 ]>
gap> Size(Image(MaximalAbelianQuotient(fp)));
1
gap> s := "";; str := OutputTextString(s, true);;
gap> PregroupPresentationToStream(str, T);
gap> s;
"rec(\n  rels := [ [ 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3 ] ],\n  table :=\
 [ [ 1, 2, 3, 4 ], [ 2, 1, 0, 0 ], [ 3, 0, 4, 1 ], [ 4, 0, 1, 3 ] ] \n );\n"
