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

DeclareOperation("RSymTest", [IsPregroupPresentation, IsObject]);

# IsPregroup -> [IsPregroupRelator] -> IsPregroupPresentation
DeclareGlobalFunction("NewPregroupPresentation");
