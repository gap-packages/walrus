#
# walrus: Computational Methods for Finitely Generated Monoids and Groups
#

DeclareCategory("IsPregroupPlace", IsObject);

DeclareRepresentation( "IsPregroupPlaceRep"
                     , IsPregroupPlace and IsPositionalObjectRep
                     , [] );

BindGlobal("PregroupPlaceType", NewType( NewFamily("PregroupPlaceFam")
                                       , IsPregroupPlaceRep ) );

DeclareAttribute("Relator", IsPregroupPlace);
DeclareAttribute("PregroupPresentationOf", IsPregroupPlace);
DeclareAttribute("Location", IsPregroupPlace);
DeclareAttribute("Letter", IsPregroupPlace);
DeclareAttribute("Colour", IsPregroupPlace);
DeclareAttribute("NextPlaces", IsPregroupPlace);
DeclareAttribute("OneStepReachablePlaces", IsPregroupPlace);
DeclareAttribute("__ID", IsPregroupPlace);

DeclareGlobalFunction("OneStepRedCase");
DeclareGlobalFunction("OneStepGreenCase");

DeclareGlobalFunction("NewPlace");
