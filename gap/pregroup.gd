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

DeclareRepresentation( "IsPregroupTableRep"
                     , IsPregroup and
                       IsComponentObjectRep and
                       IsAttributeStoringRep
                     , []);
BindGlobal("PregroupByTableType",
           NewType( PregroupFamily, IsPregroupTableRep));

DeclareRepresentation( "IsPregroupOfFreeGroupRep"
                     , IsPregroup and
                       IsComponentObjectRep and
                       IsAttributeStoringRep
                     , []);
BindGlobal("PregroupOfFreeGroupType",
           NewType( PregroupFamily, IsPregroupOfFreeGroupRep));

DeclareRepresentation( "IsPregroupOfFreeProductRep"
                     , IsPregroup and
                       IsComponentObjectRep and
                       IsAttributeStoringRep
                     , []);
BindGlobal("PregroupOfFreeProductType",
           NewType( PregroupFamily, IsPregroupOfFreeProductRep));

DeclareGlobalFunction("PregroupByTableNC");
DeclareGlobalFunction("PregroupByTable");
DeclareGlobalFunction("PregroupInversesFromTable");

DeclareOperation("[]", [IsPregroup, IsInt]);
DeclareAttribute("Size", IsPregroup);
DeclareAttribute("IntermultPairs", IsPregroup);
DeclareAttribute("IntermultPairsIDs", IsPregroup);
DeclareAttribute("IntermultMap", IsPregroup);
DeclareAttribute("IntermultMapIDs", IsPregroup);
DeclareAttribute("IntermultTable", IsPregroup);
DeclareAttribute("One", IsPregroup);

DeclareAttribute("MultiplicationTable", IsPregroup);
DeclareAttribute("MultiplicationTableIDs", IsPregroup);


DeclareOperation("SetPregroupElementNames", [IsPregroup, IsList]);
DeclareOperation("PregroupElementNames", [IsPregroup]);


# Elements of Pregroups

DeclareCategory("IsElementOfPregroup", IsMultiplicativeElement);
DeclareRepresentation("IsElementOfPregroupRep", IsElementOfPregroup and IsComponentObjectRep, []);
DeclareRepresentation("IsElementOfPregroupOfFreeGroupRep", IsElementOfPregroup and IsComponentObjectRep, []);

DeclareAttribute("PregroupOf", IsElementOfPregroup);

DeclareOperation("IsDefinedMultiplication", [IsElementOfPregroup, IsElementOfPregroup]);
DeclareOperation("IsIntermultPair", [IsElementOfPregroup, IsElementOfPregroup]);

DeclareAttribute("IntermultMap", IsElementOfPregroup);
DeclareAttribute("PregroupInverse", IsElementOfPregroup);
DeclareAttribute("PregroupElementId", IsElementOfPregroup);
DeclareAttribute("__ID", IsElementOfPregroup);

# Constructing Pregroups

# Construct a pregroup given a list of red relators over a free group
DeclareOperation("PregroupByRedRelators", [ IsFreeGroup, IsList ]);

# Make a pregroup from two groups.
#T This should actually take an embedding of an almalgamating
#T subgroup in the end to get intermult pairs and interleaving
#T and all that
DeclareOperation("PregroupOfFreeProduct", [IsGroup, IsGroup]);
DeclareOperation("PregroupOfFreeProduct", [IsGroupHomomorphism, IsGroupHomomorphism]);


# FIXME: The above operations should work with this
DeclareGlobalFunction("PregroupOfFreeProductList");

DeclareGlobalFunction("PregroupOfFreeGroup");

