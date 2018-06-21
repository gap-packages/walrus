#
# walrus: Computational Methods for Finitely Generated Monoids and Groups
#
DeclareObject("IsPregroupPlace",
               IsObject,
               IsPositionalObjectRep,
               # and IsAttributeStoringRep, # 
               [ "Relator"
               , "Presentation"
               , "Location"
               , "Letter"
               , "Colour"
               , "NextPlaces"
               , "OneStepReachablePlaces",
               "__ID"],
               []);

DeclareGlobalFunction("OneStepRedCase");
DeclareGlobalFunction("OneStepGreenCase");


DeclareGlobalFunction("NewPlace");
