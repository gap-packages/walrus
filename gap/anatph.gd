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

DeclareAttribute("Pregroup", IsPregroupPresentation);
DeclareAttribute("Relations", IsPregroupPresentation);
DeclareAttribute("GeneratorsOfPregroupPresentation", IsPregroupPresentation);

# Proving hyperblicity using RSym

DeclareGlobalFunction("Locations");
DeclareGlobalFunction("Places");
DeclareGlobalFunction("CheckReducedDiagram");

