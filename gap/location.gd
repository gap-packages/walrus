#
# walrus: Computational Methods for Finitely Generated Monoids and Groups
#

DeclareObject( "IsPregroupLocation",
               IsObject,
               IsPositionalObjectRep,
               [ "Relator"
               , "PregroupPresentationOf"
               , "Position"
               , "InLetter", "OutLetter"
               , "Places"
               , "NextLocation"
               , "PrevLocation"
               , "__ID" ],
               []);
# IsPregroupRelator -> 
DeclareGlobalFunction("NewLocation");
