#
# anatph: A new approach to proving hyperbolicity
#

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
DeclareGlobalFunction("NewPregroupWord");

# A relation is just a word over a pregroup attached to a pregroup
# presentation
DeclareObject(
               "IsPregroupRelator",
               IsPregroupWord,
               IsComponentObjectRep and IsAttributeStoringRep,
               ["Presentation", "Base", "Exponent", "Places", "Locations"],
               []
    );
DeclareGlobalFunction("NewPregroupRelator");

