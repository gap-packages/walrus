#
# walrus: Computational Methods for Finitely Generated Monoids and Groups
#
# Declarations
#

#!
#! @Chapter Overview
#!
#! This package provides the operations <C>IsHyperbolic</C>, ways of testing a
#! finitely presented group for hyperbolicity in the sense of Gromov.
#! <P/>
#!
#! The algorithm is based on ideas by Richard Parker, and the theory is described
#! in the paper "Polynomial time proofs that groups are hyperbolic".
#!
#! @Section Testing Hyperbolicity
#!
#! The main function of this package is the so-called RSym-tester. Given a
#! (pregroup) presentation of a group, this function will try to prove whether
#! the group defined by the presentation is hyperbolic, and will give an answer
#! in polynomial time.
#! Since hyperbolicity is undecidable, the answer can be positive, negative, or
#! inconclusive.
#!
#! As a simple example consider the following. Triangle groups are known to be
#! hyperbolic when the sum <M>\frac{1}{p} + \frac{1}{q} + \frac{1}{r}</M> is less
#! than <M>1</M>. The parameter for <Ref Func="IsHyperbolic" Label="for IsPregroupPresentation"/>
#! gives the algorithm a hint how hard it should try.
#! @BeginExample
#! gap> triangle := TriangleGroup(2,3,7);
#! <pregroup presentation with 3 generators and 1 relators>
#! gap> IsHyperbolic(triangle, 1/6);
#! true
#! gap> triangle := TriangleGroup(3,3,3);
#! <pregroup presentation with 3 generators and 1 relators>
#! gap> IsHyperbolic(triangle, 1/6);
#! [ fail, [ [ 1, 0, 0, 0 ], [ 2, 1, 1, 1/36 ], [ 1, 2, 2, 1/18 ],
#!          [ 2, 3, 3, 1/12 ], [ 1, 4, 4, 1/9 ], [ 2, 5, 5, 5/36 ],
#!          [ 1, 6, 6, 1/6 ] ], [ 2, 5, 5, 5/36 ] ]
#! @EndExample
#!
#! One can also create pregroup presentations by giving a pregroup
#! and relators, that is, words over the pregroup.
#! @BeginExample
#! gap> G1 := CyclicGroup(3);;
#! gap> pg := PregroupOfFreeProduct(G1,G1);
#! <pregroup with 5 elements in table rep>
#! gap> rel := [2,5,3,4,3,4,3,4,3,5,2,4,3,5,2,4,3,5,3,4,2,4,3,5];
#! [ 2, 5, 3, 4, 3, 4, 3, 4, 3, 5, 2, 4, 3, 5, 2, 4, 3, 5, 3, 4, 2, 4, 3, 5 ]
#! gap> pgp := NewPregroupPresentation(pg,[pg_word(pg,rel)]);
#! <pregroup presentation with 4 generators and 1 relators>
#! gap> res := RSymTest(pgp, 0);;
#! gap> res[1];
#! fail
#! @EndExample
#!
#! @Section The MAGMA-compatible interface
#!
#! An implementation of the hyperbolicity testing algorithm and word-problem
#! solver exist in MAGMA as well. For ease of comparison between the results
#! these two systems give, &walrus; contains an interface that aims to be
#! compatible with MAGMA's. Please refer to MAGMA's documentation for further
#! details.
#!
#! @BeginExample
#! gap> F := FreeGroup("x", "y");;
#! gap> AssignGeneratorVariables(F);;
#! gap> rred := [ y^3 ];;
#! gap> rgreen := [ x^4, (x*y)^4 ];;
#! gap> IsHyperbolic(F, rred, rgreen, 1/10);
#! [ fail, [ [ 1, 0, 0, 0 ], [ 2, 1, 1, 13/120 ], [ 1, 2, 2, 13/60 ],
#!           [ 2, 3, 3, 13/40 ], [ 1, 4, 4, 13/30 ] ], [ 2, 3, 3, 13/40 ] ]
#! @EndExample

# Proving hyperblicity using RSym
DeclareGlobalFunction("CheckReducedDiagram");
DeclareGlobalFunction("ComputePlaceTriples");

# Vertex is an overloaded word, so name this WalrusVertex
DeclareGlobalFunction("WalrusVertex");

DeclareGlobalFunction("ShortBlobWords");

# Location blob graph has by convention set of locations first
# in vertex set for quick lookup
DeclareGlobalFunction("VertexFor");

DeclareGlobalFunction("ConsolidatedEdgePlaces");


