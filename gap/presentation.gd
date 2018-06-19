#
# anatph: A new approach to proving hyperbolicity
#
DeclareObject( "IsPregroupPresentation",
               IsObject,
               IsComponentObjectRep and IsAttributeStoringRep,
               ["Pregroup", "Generators",
                "Relators", "RelatorsAndInverses",
                "Locations", "Places", "Bases", "Powers", "Roots",
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

DeclareOperation("RSymTestOp", [IsPregroupPresentation, IsRat]);

DeclareOperation("IsHyperbolic", [IsPregroupPresentation]);
DeclareOperation("IsHyperbolic", [IsPregroupPresentation, IsRat]);
DeclareOperation("IsHyperbolic", [IsFreeGroup, IsObject, IsObject, IsRat]);


DeclareGlobalFunction("RSymTest");

DeclareGlobalFunction("IsRLetter");
DeclareGlobalFunction("NewPregroupPresentation");
DeclareGlobalFunction("PregroupPresentationFromFp");
