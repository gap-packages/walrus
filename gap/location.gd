#
# walrus: Computational Methods for Finitely Generated Monoids and Groups
#

#! @Chapter Pregroup Presentations
#!
#! @Section Concepts
#!
#! @Subsection Locations
#!
#! A <E>location</E> on a pregroup relator <M> w = a_1a_2\ldots a_n</M> is an
#! index <M>i</M> between <M>1</M> and <M>n</M> and denotes the location between
#! <M>a_i</M> (the <Ref Attr="InLetter" Label="for IsPregroupLocation" />) and
#! <M>a_{i+1}</M> (the <Ref Attr="OutLetter" Label="for IsPregroupLocation" />), where
#! the relator is considered cyclically, that is, when <M>i=n</M> then the outletter
#! is <M>a_1</M>.
#!

#!
#! @Section Attributes
#!
DeclareCategory("IsPregroupLocation", IsObject);

DeclareRepresentation( "IsPregroupLocationRep"
                     , IsPregroupLocation and IsPositionalObjectRep
                     , [] );

BindGlobal( "PregroupLocationType"
          , NewType(NewFamily("PregroupLocationFam"), IsPregroupLocationRep));

DeclareAttribute("Relator", IsPregroupLocation);
DeclareAttribute("PregroupPresentationOf", IsPregroupLocation);
DeclareAttribute("Position", IsPregroupLocation);
#!
#! @Description
DeclareAttribute("InLetter", IsPregroupLocation);

#! @Description
DeclareAttribute("OutLetter", IsPregroupLocation);

#! @Description
DeclareAttribute("Places", IsPregroupLocation);
DeclareAttribute("NextLocation", IsPregroupLocation);
DeclareAttribute("PrevLocation", IsPregroupLocation);
DeclareAttribute("__ID", IsPregroupLocation);

DeclareGlobalFunction("NewLocation");
