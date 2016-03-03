#
# anatph: A new approach to proving hyperbolicity
#
#
# Pregroups
#
# Declarations
#

DeclareCategory("IsPregroup", IsObject);
BindGlobal("PregroupFamily", NewFamily("PregroupFamily"));

DeclareRepresentation("IsPregroupTableRep", IsPregroup and IsComponentObjectRep, []);
BindGlobal("PregroupByTableType",
           NewType( PregroupFamily, IsPregroupTableRep));

DeclareGlobalFunction("PregroupByTableNC");
DeclareGlobalFunction("PregroupByTable");

DeclareOperation("[]", [IsPregroupTableRep, IsInt]);

DeclareCategory("IsElementOfPregroup", IsMultiplicativeElement);
DeclareRepresentation("IsElementOfPregroupRep", IsElementOfPregroup and IsComponentObjectRep, []);

DeclareOperation("IsDefinedMultiplication", [IsElementOfPregroup, IsElementOfPregroup]);
DeclareOperation("IsIntermultPair", [IsElementOfPregroup, IsElementOfPregroup]);
DeclareAttribute("Sigma", IsElementOfPregroup);


