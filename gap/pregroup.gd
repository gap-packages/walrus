#
# anatph: A new approach to proving hyperbolicity
#
#
# Pregroups
#
# Declarations
#

DeclareCategory("IsPregroup", IsObject and IsCollection);
BindGlobal("PregroupFamily", NewFamily("PregroupFamily"));

DeclareRepresentation("IsPregroupTableRep", IsPregroup and IsComponentObjectRep, []);
BindGlobal("PregroupByTableType",
           NewType( PregroupFamily, IsPregroupTableRep));

DeclareGlobalFunction("PregroupByTableNC");
DeclareGlobalFunction("PregroupByTable");

DeclareOperation("[]", [IsPregroupTableRep, IsInt]);
# DeclareAttribute("Size", IsPregroup);
DeclareAttribute("IntermultPairs", IsPregroup);

# Elements of Pregroups

DeclareCategory("IsElementOfPregroup", IsMultiplicativeElement);
DeclareRepresentation("IsElementOfPregroupRep", IsElementOfPregroup and IsComponentObjectRep, []);

DeclareAttribute("PregroupOf", IsElementOfPregroup);

DeclareOperation("IsDefinedMultiplication", [IsElementOfPregroup, IsElementOfPregroup]);
DeclareOperation("IsIntermultPair", [IsElementOfPregroup, IsElementOfPregroup]);

DeclareAttribute("PregroupInverse", IsElementOfPregroup);

# TBD: Words over Pregroups
