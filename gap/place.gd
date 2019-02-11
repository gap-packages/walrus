#
# walrus: Computational Methods for Finitely Generated Monoids and Groups
#


#! @Chapter Pregroup Presentations
#!
#! @Section Concepts
#!
#! @Subsection Places
#!
#! A <E>place</E> <M>R(L, x, C)</M> on a pregroup relator <M>R</M> is a location
#! (<Ref Subsect="Chapter_Pregroup_Presentations_Section_Concepts_Subsection_Locations"/>) together with a letter from the pregroup and a
#! colour, which is either <E>red</E> or <E>green</E>.

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
