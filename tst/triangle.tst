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

# TriangleGroup(16,20,50) is hyperbolic
# as shown in prop 9.4 there should be no
# instantiable green places
gap> tt := TriangleGroup(16,20,50);;
gap> Length(Places(tt));
64
gap> Length(Filtered(Places(tt), x -> Colour(x) = "green"));
0

# Quotients of triangle groups by extra relator

# As shown in Thm 9.5, this should succeed
gap> ts := TriSH(13,7);;
gap> RSymTest(ts, 1/6);
true

