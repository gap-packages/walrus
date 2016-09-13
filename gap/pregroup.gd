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

DeclareRepresentation("IsPregroupTableRep", IsPregroup and IsComponentObjectRep and IsAttributeStoringRep, []);
BindGlobal("PregroupByTableType",
           NewType( PregroupFamily, IsPregroupTableRep));

DeclareGlobalFunction("PregroupByTableNC");
DeclareGlobalFunction("PregroupByTable");

DeclareOperation("[]", [IsPregroupTableRep, IsInt]);
 DeclareAttribute("Size", IsPregroup);
DeclareAttribute("IntermultPairs", IsPregroup);
DeclareAttribute("IntermultPairsIds", IsPregroup);
DeclareAttribute("IntermultMap", IsPregroup);
DeclareAttribute("IntermultTable", IsPregroup);
DeclareAttribute("One", IsPregroup);


# Elements of Pregroups

DeclareCategory("IsElementOfPregroup", IsMultiplicativeElement);
DeclareRepresentation("IsElementOfPregroupRep", IsElementOfPregroup and IsComponentObjectRep, []);

DeclareAttribute("PregroupOf", IsElementOfPregroup);

DeclareOperation("IsDefinedMultiplication", [IsElementOfPregroup, IsElementOfPregroup]);
DeclareOperation("IsIntermultPair", [IsElementOfPregroup, IsElementOfPregroup]);

DeclareAttribute("PregroupInverse", IsElementOfPregroup);
DeclareAttribute("PregroupElementId", IsElementOfPregroup);
DeclareAttribute("__ID", IsElementOfPregroup);

# TBD: Words over Pregroups

# Constructing Pregroups

# Make a pregroup from two groups.
#T This should actually take an embedding of an almalgamating
#T subgroup in the end to get intermult pairs and interleaving
#T and all that
DeclareGlobalFunction("PregroupFromFreeProduct");
DeclareGlobalFunction("PregroupOfFreeGroup");

