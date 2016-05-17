#
# anatph: A new approach to proving hyperbolicity
#
DeclareObject(
               "IsPregroupPresentation",
               IsObject,
               IsComponentObjectRep,
               ["Pregroup", "Generators",
                "Relators", "RelatorsAndInverses",
                "Locations", "Places", "Bases", "Powers", "Roots",
                "LocationBlobGraph", "LocationBlobGraphDistances",
                "RLetters"
               ],
               []);
DeclareGlobalFunction("NewPregroupPresentation");
#X elements family?

