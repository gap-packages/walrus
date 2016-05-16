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


# Words over pregroups can be inverted
# will we automatically multiply things together if multiplication is defined?
DeclareCategory("IsWordOverPregroup", IsMultiplicativeElementWithInverse and IsList);
DeclareRepresentation("IsWordOverPregroupListRep", IsWordOverPregroup and IsPositionalObjectRep, [] );

DeclareObject(
    "IsPregroupWord",
    IsMultiplicativeElementWithInverse and IsList,
    IsPositionalObjectRep,
    ["Pregroup", "Base", "Exponent", "Length"],
    []);
DeclareGlobalFunction("PregroupWord");

# A relation is just a word over a pregroup attached to a pregroup
# presentation
DeclareObject(
    "IsPregroupRelator",
    IsPregroupWord,
    IsComponentObjectRep and IsAttributeStoringRep,
    ["Presentation", "Base", "Exponent"],
    []
    );
DeclareGlobalFunction("PregroupRelator");

DeclareObject(
    "IsPregroupLocation",
    IsObject,
    IsPositionalObjectRep,
    ["Relator", "Presentation", "Position", "InLetter", "OutLetter"],
    []);
DeclareGlobalFunction("Location");

DeclareObject(
    "IsPregroupPlace",
    IsObject,
    IsPositionalObjectRep,
    ["Relator", "Presentation", "LocationAt", "InLetter", "OutLetter"],
    []);
DeclareGlobalFunction("Place");

DeclareObject(
    "IsPregroupPresentation",
    IsObject,
    IsComponentObjectRep,
    ["Pregroup", "Generators", "Relators", "Locations", "Places", "Bases", "Powers", "Roots"],
    []);
DeclareGlobalFunction("PregroupPresentation");
#X elements family?


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


