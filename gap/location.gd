#
# walrus: Computational Methods for Finitely Generated Monoids and Groups
#

DeclareCategory("IsPregroupLocation", IsObject);

DeclareRepresentation( "IsPregroupLocationRep"
                     , IsPregroupLocation and IsPositionalObjectRep
                     , [] );

BindGlobal( "PregroupLocationType"
          , NewType(NewFamily("PregroupLocationFam"), IsPregroupLocationRep));

DeclareAttribute("Relator", IsPregroupLocation);
DeclareAttribute("PregroupPresentationOf", IsPregroupLocation);
DeclareAttribute("Position", IsPregroupLocation);
DeclareAttribute("InLetter", IsPregroupLocation);
DeclareAttribute("OutLetter", IsPregroupLocation);
DeclareAttribute("Places", IsPregroupLocation);
DeclareAttribute("NextLocation", IsPregroupLocation);
DeclareAttribute("PrevLocation", IsPregroupLocation);
DeclareAttribute("__ID", IsPregroupLocation);

DeclareGlobalFunction("NewLocation");
