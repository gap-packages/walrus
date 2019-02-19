#
# walrus: Computational Methods for Finitely Generated Monoids and Groups
#

#! @Chapter Pregroup Presentations
#!
#! @Section Creating Pregroup Presentations
#!
#! @Arguments pregroup, relators
#! @Returns a pregroup presentation
#! @Description
#! Creates a pregroup presentation over the <A>pregroup</A> with
#! relators <A>relators</A>.
DeclareGlobalFunction("NewPregroupPresentation");

#! @Arguments F, rred, rgreen
#! @Returns a pregroup presentation
#! @Description
#! Creates a pregroup presentation over the pregroup defined by
#! <A>F</A> and <A>rred</A> with relators <A>rgreen</A>.
DeclareGlobalFunction("PregroupPresentationFromFp");

#! @Arguments presentation
#! @Returns a finitely presented group
#! @Description
#! Converts the pregroup presentation <A>presentation</A> into
#! a finitely presented group.
DeclareGlobalFunction("PregroupPresentationToFpGroup");


#!
#! @Section Filters, Attributes, and Properties
#!
DeclareCategory("IsPregroupPresentation", IsObject);
DeclareRepresentation( "IsPregroupPresentationRep"
                     , IsPregroupPresentation and IsComponentObjectRep and IsAttributeStoringRep
                     , [] );

BindGlobal( "PregroupPresentationType"
          , NewType( NewFamily( "PregroupPresentationFam")
                   , IsPregroupPresentationRep ) );


DeclareAttribute("Pregroup", IsPregroupPresentation );
DeclareAttribute("Generators", IsPregroupPresentation );
DeclareAttribute("Relators", IsPregroupPresentation );
DeclareAttribute("RelatorsAndInverses", IsPregroupPresentation );
DeclareAttribute("Locations", IsPregroupPresentation );
DeclareAttribute("Places", IsPregroupPresentation );
DeclareAttribute("Bases", IsPregroupPresentation );
DeclareAttribute("Powers", IsPregroupPresentation );
DeclareAttribute("VertexGraph", IsPregroupPresentation );
DeclareAttribute("VertexGraphDistances", IsPregroupPresentation );
DeclareAttribute("VertexTriples", IsPregroupPresentation );
DeclareAttribute("RLetters", IsPregroupPresentation );
DeclareAttribute("PlaceTriples", IsPregroupPresentation );
DeclareAttribute("ShortRedBlobIndex", IsPregroupPresentation );
DeclareAttribute("OneStepReachablePlaces", IsPregroupPresentation );
DeclareAttribute("LengthLongestRelator", IsPregroupPresentation );
DeclareAttribute("LocationIndex", IsPregroupPresentation );

DeclareOperation("Blob",
                 [IsPregroupPresentation,
                  IsElementOfPregroup, IsElementOfPregroup, IsElementOfPregroup]);

DeclareAttribute("VertexTripleCache", IsPregroupPresentation, "mutable" );
DeclareGlobalFunction("IsRLetter");

#! @Section Hyperbolicity testing for pregroup presentations
#!
#! @Arguments presentation, epsilon
#! @Description
#! Test the group presented by <A>presentation</A> for hyperbolicity using
#! the RSym tester with parameter <A>epsilon</A>.
DeclareOperation("RSymTestOp", [IsPregroupPresentation, IsRat]);
#! @Arguments args...
#!
#! @Description
#! This is a wrapper for <Ref Oper="RSymTestOp" Label="for
#! IsPregroupPresentation, IsRat" />. If the first argument given is a free
#! group, the second and third lists of words over the free group, and the
#! fourth a rational, then this function creates a pregroup presentation from
#! the input data and invokes <Ref Oper="RSymTestOp" Label="for
#! IsPregroupPresentation, IsRat" /> on it. If the first
#! argument is a pregroup presentation and the second argument is rational
#! number, then it invokes <Ref Oper="RSymTestOp" Label="for
#! IsPregroupPresentation, IsRat" /> on that input.
DeclareGlobalFunction("RSymTest");

#! @BeginGroup
#! @Description Tests a given presentation for hyperbolicity using the RSym test procedure.
#! @Arguments presentation
DeclareOperation("IsHyperbolic", [IsPregroupPresentation]);
#! @Arguments presentation, epsilon
DeclareOperation("IsHyperbolic", [IsPregroupPresentation, IsRat]);
#! @Arguments F, rred, rgreen, epsilon
DeclareOperation("IsHyperbolic", [IsFreeGroup, IsObject, IsObject, IsRat]);
#! @EndGroup



#! @Section Input and Output of Pregroup Presentations

#! @Arguments presentation
#! @Returns A KBMAG rewriting system
#! @Description
#! Turns the pregroup presentation <A>presentation</A> into
#! valid input for Knuth-Bendix rewriting using KBMAG. Only
#! available if the kbmag package is available.
DeclareGlobalFunction("PregroupPresentationToKBMAG");

#! @Arguments stream, presentation
#! @Description
#! Writes the pregroup presentation <A>presentation</A> to
#! <A>stream</A>.
#! @BeginExample
#! gap> T := TriangleGroup(2,3,7);;
#! gap> str := "";; stream := OutputTextString(str, true);;
#! gap> PregroupPresentationToStream(stream, T);
#! gap> Print(str);
#! rec(
#!   rels := [ [ 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3 ] ],
#!   table := [ [ 1, 2, 3, 4 ], [ 2, 1, 0, 0 ], [ 3, 0, 4, 1 ], [ 4, 0, 1, 3 ] ] );
#! @EndExample
DeclareGlobalFunction("PregroupPresentationToStream");

#! @Arguments stream
#! @Returns A pregroup presentation
#! @Description
#! Reads a pregroup presentation from an input stream in the same format
#! that <Ref Func="PregroupPresentationToStream" /> uses.
#! @BeginExample
#! gap> stream := InputTextString(str);
#! InputTextString(0,146)
#! gap> PregroupPresentationFromStream(stream);
#! <pregroup presentation with 3 generators and 1 relators>
#! @EndExample
DeclareGlobalFunction("PregroupPresentationFromStream");

#! @Arguments stream, presentation
#! @Description
#! Writes the pregroup presentation <A>presentation</A> to
#! <A>stream</A>. Uses a simpler format than
#! <Ref Func="PregroupPresentationToStream" />
DeclareGlobalFunction("PregroupPresentationToSimpleStream");

#! @Arguments filename, presentation
#! @Description
#! Writes the pregroup presentation <A>presentation</A> to
#! file with name <A>filename</A>.
DeclareGlobalFunction("PregroupPresentationToFile");

#! @Arguments filename
#! @Description
#! Reads a pregroup presentation from file with <A>filename</A>.
DeclareGlobalFunction("PregroupPresentationFromFile");

#! @Arguments stream, presentation
#! @Description
#! Writes the pregroup presentation <A>presentation</A> to
#! file with name <A>filename</A> in a simple format.
DeclareGlobalFunction("PregroupPresentationToSimpleFile");



DeclareGlobalFunction("LogPregroupPresentation");
