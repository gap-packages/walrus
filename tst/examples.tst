gap> J := JackButtonGroup();
<pregroup presentation with 6 generators and 2 relators>
gap> Relators(J);
[ <pregroup relator TatBA>, <pregroup relator TbtAB> ]
gap> R := RandomTriangleQuotient(2,3,7,10);
<pregroup presentation with 3 generators and 2 relators>
gap> List(Relators(R), Length);
[ 14, 10 ]
gap> Length(RandomPregroupWord(SmallPregroup(4,1), 10));
10
gap> tmp := TmpDirectory();;
gap> CreateRandomExample(tmp, SmallPregroup(4, 2), 4, 10);
gap> RandomPregroupFromSmallGroups();;
