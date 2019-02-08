#
# walrus: Computational Methods for Finitely Generated Monoids and Groups
#

# Words over pregroups can be inverted
# will we automatically multiply things together if multiplication is defined?

DeclareCategory("IsPregroupWord", IsMultiplicativeElementWithInverse and IsList);
DeclareRepresentation("IsPregroupWordListRep", IsPregroupWord and IsPositionalObjectRep, [] );

# DeclareAttribute("Pregroup", IsPregroupWord);
# DeclareAttribute("Base", IsPregroupWord);
# DeclareAttribute("Exponent", IsPregroupWord);
# DeclareAttribute("Length", IsPregroupWord);

DeclareGlobalFunction("NewPregroupWord");

# A relation is just a word over a pregroup attached to a pregroup
# presentation
# FIXME: Clean up the mess I made with the type-helpers that don't
#        really help
DeclareCategory("IsPregroupRelator", IsPregroupWord);
DeclareRepresentation("IsPregroupRelatorRep",
                      IsPregroupRelator and
                      IsComponentObjectRep and
                      IsAttributeStoringRep,
                      []);
BindGlobal("IsPregroupRelatorFamily", NewFamily("IsPregroupRelatorFamily"));
BindGlobal("IsPregroupRelatorType", NewType(IsPregroupRelatorFamily, IsPregroupRelatorRep));

DeclareAttribute("PregroupPresentationOf", IsPregroupRelator);
DeclareAttribute("Base", IsPregroupRelator);
DeclareAttribute("Exponent", IsPregroupRelator);
DeclareAttribute("Places", IsPregroupRelator);
DeclareAttribute("Locations", IsPregroupRelator);
DeclareAttribute("__ID", IsPregroupRelator);


DeclareGlobalFunction("NewPregroupRelator");

DeclareGlobalFunction("ReduceUPregroupWord");
