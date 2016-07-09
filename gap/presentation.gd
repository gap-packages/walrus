#
# anatph: A new approach to proving hyperbolicity
#
DeclareObject(
               "IsPregroupPresentation",
               IsObject,
               IsComponentObjectRep and IsAttributeStoringRep,
               ["Pregroup", "Generators",
                "Relators", "RelatorsAndInverses",
                "Locations", "Places", "Bases", "Powers", "Roots",
                "LocationBlobGraph", "LocationBlobGraphDistances",
                "RLetters", "PlaceTriples"
#                , "ShortRedBlobs"
                , "ShortRedBlobIndex"
                , "OneStepReachablePlaces"
                , "LengthLongestRelator"
               ],
               []);

DeclareOperation("RSymTest", [IsPregroupPresentation, IsObject]);

# DeclareOperation( "Blob", [IsPregroupPresentation, IsPregroupElement, IsPregroupElement, IsPregroupElement ])

DeclareGlobalFunction("NewPregroupPresentation");
#X elements family?

