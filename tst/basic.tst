gap> START_TEST("ANATPH: basic tests");

# TriangleGroup(3,3,3) is not hyperbolic so this should fail
# (and it currently doesn't)
gap> RSymTest(TriangleGroup(3,3,3), 1/3);
[ fail, [] ]


# TriangleGroup(2,3,7) is hyperbolic
gap> RSymTest(TriangleGroup(2,3,7), 1/6);
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
# TriSH() 

# As shown in Thm 9.5, this should succeed
gap> ts := TriSH(13,7);;
gap> RSymTest(ts, 1/6);
true

gap> STOP_TEST("ANATPH: basic tests", 1000);
