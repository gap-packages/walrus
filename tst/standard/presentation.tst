gap> START_TEST("ANATPH: presentation tests");
gap> T := TriangleGroup(2,3,7);
<pregroup presentation with 3 generators and 1 relators>
gap> Pregroup(T);
<pregroup with 4 elements in table rep>
gap> Relators(T);
[ <pregroup relator ([ "2", "3" ])^7> ]
gap> RelatorsAndInverses(T);
[ <pregroup relator ([ "2", "3" ])^7>, <pregroup relator ([ "4", "2" ])^7> ]
gap> Locations(T);
[ <pregroup relator ([ "2", "3" ])^7>(1,3,2), 
  <pregroup relator ([ "2", "3" ])^7>(2,2,3), 
  <pregroup relator ([ "4", "2" ])^7>(1,2,4), 
  <pregroup relator ([ "4", "2" ])^7>(2,4,2) ]
gap> Length(Places(T));
4
gap> STOP_TEST("ANATPH: presentation tests", 1000);
