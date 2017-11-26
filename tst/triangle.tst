# (3,3,3) triangle group is not hyperbolic (its "flat")
gap> tri := TriangleGroup(3,3,3);;
gap> res := RSymTest(tri, 1/6);;
gap> IsList(res) and res[1] = fail;
true

# (2,3,7) triangle group is hyperbolic
gap> tri := TriangleGroup(2,3,7);;
gap> res := RSymTest(tri, 1/6);;
gap> IsBool(res) and res = true;
true

# (2,2,7) triangle group is finite (and a dihedral group)
gap> tri := TriangleGroup(2,2,7);;
gap> res := RSymTest(tri, 1/6);;
gap> IsBool(res) and res = true;
true
