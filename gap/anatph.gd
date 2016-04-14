#
# anatph: A new approach to proving hyperbolicity
#
# Declarations
#

# Random utility functions
DeclareGlobalFunction("IsRLetter");
DeclareGlobalFunction("RepeedList");
DeclareGlobalFunction("MaxPowerK");
DeclareGlobalFunction("MaxPowerK2");


DeclareCategory("IsPregroupPresentation", IsObject);
BindGlobal("PregroupPresentationFamily", NewFamily("PregroupPresentationFamily"));

DeclareRepresentation("IsPregroupPresentationRep", IsPregroupPresentation and IsComponentObjectRep, []);
BindGlobal("PregroupPresentationType", NewType(PregroupPresentationFamily, IsPregroupPresentationRep));

DeclareGlobalFunction("PregroupPresentation");

# Words over pregroups can be inverted
# will we automatically multiply things together if multiplication is defined?
DeclareCategory("IsWordOverPregroup", IsMultiplicativeElementWithInverse and IsList);
DeclareRepresentation("IsWordOverPregroupListRep", IsWordOverPregroup and IsPositionalObjectRep, [] );
# Words over different pregroups have to be in different families...

DeclareAttribute("Pregroup", IsPregroupPresentation);
DeclareAttribute("Generators", IsPregroupPresentation);
DeclareAttribute("Relations", IsPregroupPresentation);
DeclareAttribute("Locations", IsPregroupPresentation);
DeclareAttribute("Places", IsPregroupPresentation);

DeclareAttribute("GeneratorsOfPregroupPresentation", IsPregroupPresentation);

# Proving hyperblicity using RSym
# DeclareGlobalFunction("Locations");
# DeclareGlobalFunction("Places");
DeclareGlobalFunction("CheckReducedDiagram");
DeclareGlobalFunction("LocationBlobGraph");
DeclareGlobalFunction("ComputePlaceTriples");

# Not a good choice of name
DeclareGlobalFunction("Vertex");


DeclareGlobalFunction("ShortBlobWords");
DeclareGlobalFunction("Blob");
DeclareGlobalFunction("RSymTester");


