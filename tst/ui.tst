gap> F := FreeGroup("x", "y");;
gap> AssignGeneratorVariables(F);;
#I  Assigned the global variables [ x, y ]
gap> rred := [y^3];; rgreen := [x^4, (x*y)^4 ];;
gap> RSymTest(F, rred, rgreen, 1/10);
[ fail, 
  [ [ 1, 0, 0, 0 ], [ 2, 1, 1, 13/120 ], [ 1, 2, 2, 13/60 ], 
      [ 2, 3, 3, 13/40 ], [ 1, 4, 4, 13/30 ] ], [ 2, 3, 3, 13/40 ] ]
gap> F := FreeGroup("x", "y", "t");;
gap> AssignGeneratorVariables(F);;
#I  Global variable `x' is already defined and will be overwritten
#I  Global variable `y' is already defined and will be overwritten
#I  Assigned the global variables [ x, y, t ]
gap> rred := [y^3, x^2*t];; rgreen := [t^2, (x*y)^4];;
gap> RSymTest(F, rred, rgreen, 1/10);
true
gap> IsHyperbolic(F, rred, rgreen, 1/10);
true
gap> pgp := PregroupPresentationFromFp(F, rred, rgreen);
<pregroup presentation with 6 generators and 1 relators>
gap> RSymTest(pgp, 1/10);
true
gap> IsHyperbolic(pgp, 1/10);
true
