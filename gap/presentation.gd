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

# @Section Filters, Attributes, and Properties
# TODO: Untangle this
DeclareObject( "IsPregroupPresentation",
                   IsObject,
                   IsComponentObjectRep and IsAttributeStoringRep,
                   ["Pregroup", "Generators",
                    "Relators", "RelatorsAndInverses",
                    "Locations", "Places", "Bases", "Powers",
                    # , "Roots",
                    "VertexGraph", "VertexGraphDistances", "VertexTriples",
                    "RLetters", "PlaceTriples"
                    #                , "ShortRedBlobs"
                    , "ShortRedBlobIndex"
                    , "OneStepReachablePlaces"
                    , "LengthLongestRelator"
                    , "LocationIndex"
                   ],
                   []);
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



