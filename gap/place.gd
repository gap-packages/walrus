#
# anatph: A new approach to proving hyperbolicity
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
