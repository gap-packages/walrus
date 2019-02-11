#
# walrus: Computational Methods for Finitely Generated Monoids and Groups
#
#
#! @Chapter Pregroups
#! Pregroups are the fundamental building block of pregroup presentations used
#! in the hyperbolicity tester.

#! @Section Creating Pregroups
#!
#! This section describes functions to create pregroups from multiplication
#! tables, free groups, and free products of finite groups.

#! @BeginGroup PregroupByTableGrp
#! @Arguments enams, table
#! @Returns A pregroup
#! @Description
#! If <A>enams</A> is a list of element names, which can be arbitrary GAP objects,
#! with the convention that <C>enams[1]</C> is the name of the identity element, and
#! <A>table</A> is a square table of non-negative integers that is the multiplication
#! table of a pregroup, then <Ref Func="PregroupByTable"/> and
#! <Ref Func="PregroupByTableNC"/> return a pregroup in multiplication
#! table representation.
#! <P/>
#! By convention the elements of the pregroup are numbered <C>[1..n]</C> with
#! <C>0</C> denoting an undefined product in the table.
#! <P/>
#! The axioms for a pregroup are checked by <Ref Func="PregroupByTable"/> and
#! not checked by <Ref Func="PregroupByTableNC"/>.
#! @BeginExample
#! gap> pregroup := PregroupByTable( "1xyY",
#! >                [ [1,2,3,4]
#! >                , [2,1,0,0]
#! >                , [3,4,0,1]
#! >                , [4,0,1,3] ] );
#! <pregroup with 4 elements in table rep>
#! @EndExample
DeclareGlobalFunction("PregroupByTable");
DeclareGlobalFunction("PregroupByTableNC");
#! @EndGroup

#! @Arguments F, rrel, inv
#! @Description
#! Construct a pregroup from the list <A>rrel</A> of red relators and the list
#! <A>inv</A> of involutions over the free group <A>F</A>.
#! The argument <A>rred</A> has to be a list of elements of length 3 in the
#! free group <A>F</A>, and <A>inv</A> has to be a list of generators of <A>F</A>.
#! @Returns A pregroup in table representation
DeclareOperation("PregroupByRedRelators", [ IsFreeGroup, IsList, IsList ]);

# Make a pregroup from two groups.
#T This should actually take an embedding of an almalgamating
#T subgroup in the end to get intermult pairs and interleaving
#T and all that
#! @Arguments G, H
#! @Description
#! Construct the pregroup of the free product of <A>G</A> and <A>H</A>.
#! If <A>G</A> and <A>H</A> are finite groups, then
#! <Ref Oper="PregroupOfFreeProduct" Label="for IsGroup, IsGroup"/> returns the pregroup consisting of the
#! non-identity elements of <A>G</A> and <A>H</A> and an identity element.
#! A product between two non-trivial elements is defined if and only if they are
#! in the same group.
#!
#! @BeginExample
#! gap> pregroup := PregroupOfFreeProduct(SmallGroup(12,2), SmallGroup(24,4));
#! <pregroup with 35 elements in table rep>
#! @EndExample
DeclareOperation("PregroupOfFreeProduct", [IsGroup, IsGroup]);

# TODO: Implement this, or rather implement something with arbitrary arity
DeclareOperation("PregroupOfFreeProduct", [IsGroupHomomorphism, IsGroupHomomorphism]);

# FIXME: The above operations should work with this
DeclareGlobalFunction("PregroupOfFreeProductList");

#! @Arguments F
#! @Description
#! Return the pregroup of the free group <A>F</A>
DeclareGlobalFunction("PregroupOfFreeGroup");


#!
#! @Section Filters and Representations
#!
#! This section gives an overview over the filters, categories
#! and representations defined by &walrus;
#!
DeclareCategory("IsPregroup", IsObject and IsCollection);
BindGlobal("PregroupFamily", NewFamily("PregroupFamily"));

#! @Description
#! A pregroup represented by its multiplication table, which is a
#! square table of integers between 0 and the size of the pregroup,
#! where 0 represents an undefined multiplication.
DeclareRepresentation( "IsPregroupTableRep",
                       IsPregroup and
                       IsComponentObjectRep and
                       IsAttributeStoringRep
                     , []);
BindGlobal("PregroupByTableType",
           NewType( PregroupFamily, IsPregroupTableRep));

#! @Description
#! Pregroup of a free group of rank <M>k</M>. The
#! only defined products are <M>1\cdot x = x \cdot 1 = x</M>
#! and <M>xx^{-1} = x^{-1}x = 1</M>, for all generators <M>x</M>.
DeclareRepresentation( "IsPregroupOfFreeGroupRep",
                       IsPregroup and
                       IsComponentObjectRep and
                       IsAttributeStoringRep
                     , []);
BindGlobal("PregroupOfFreeGroupType",
           NewType( PregroupFamily, IsPregroupOfFreeGroupRep));

#! @Description
#! Pregroup of the free product of a list of groups where
#! products between non-trivial elements <M>g</M>, <M>h</M>
#! are defined if <M>g,h</M> are contained in the same
#! group.
DeclareRepresentation( "IsPregroupOfFreeProductRep",
                       IsPregroup and
                       IsComponentObjectRep and
                       IsAttributeStoringRep
                     , []);
BindGlobal("PregroupOfFreeProductType",
           NewType( PregroupFamily, IsPregroupOfFreeProductRep));


# TODO: Products amalgamating subgroups.

#! @Section Attributes, Properties, and Operations
#!
#! This section gives an overview over the attributes, properties,
#! and operatins defined for pregroups.
#!
#! @Arguments pregroup,i
#! @Description
#! Get the <A>i</A>th element of <A>pregroup</A>. By convention
#! the <M>1</M>st element is the identity element.
DeclareOperation("[]", [IsPregroup, IsInt]);

#! @Arguments pregroup
#! @Description Returns the set of intermult pairs of the pregroup
DeclareAttribute("IntermultPairs", IsPregroup);

# Internal functions
DeclareAttribute("IntermultPairsIDs", IsPregroup);
DeclareAttribute("IntermultMap", IsPregroup);
DeclareAttribute("IntermultMapIDs", IsPregroup);
DeclareAttribute("IntermultTable", IsPregroup);

#! @Arguments pregroup
#! @Description The identity element of <A>pregroup</A>.
DeclareAttribute("One", IsPregroup);

#! @Arguments pregroup
#! The multiplication table of <A>pregroup</A>
DeclareAttribute("MultiplicationTable", IsPregroup);

# Internal function
DeclareAttribute("MultiplicationTableIDs", IsPregroup);

#! @Arguments pregroup, names
#! @Description
#! Can be used to set more user-friendly display names for
#! the elements of <A>pregroup</A>. The list <A>names</A>
#! has to be of length <C>Size(<A>pregroup</A>)</C>.
DeclareOperation("SetPregroupElementNames", [IsPregroup, IsList]);

#! @Arguments pregroup
#! @Description
#! Return the list of names of elements of <A>pregroup</A>
DeclareOperation("PregroupElementNames", [IsPregroup]);

DeclareGlobalFunction("PregroupInversesFromTable");


# Elements of Pregroups

#! @Section Elements of Pregroups
#!
DeclareCategory("IsElementOfPregroup", IsMultiplicativeElementWithInverse);
DeclareRepresentation("IsElementOfPregroupRep", IsElementOfPregroup and IsComponentObjectRep, []);
DeclareRepresentation("IsElementOfPregroupOfFreeGroupRep", IsElementOfPregroup and IsComponentObjectRep, []);

#! @Arguments p
#! @Description
#! The pregroup that the element <A>p</A> is contained in.
DeclareAttribute("PregroupOf", IsElementOfPregroup);

#! @Arguments p, q
#! @Description
#! Tests whether the multiplication of <A>p</A> and <A>q</A> is
#! defined in the pregroup containing <A>p</A> and <A>q</A>.
DeclareOperation("IsDefinedMultiplication", [IsElementOfPregroup, IsElementOfPregroup]);

#! @Arguments p, q
#! @Description
#! Tests whether <M>(<A>p</A>, <A>q</A>)</M> is an intermult pair.
#! defined.
DeclareOperation("IsIntermultPair", [IsElementOfPregroup, IsElementOfPregroup]);

#! @Arguments p
#! @Description
#! Return the inverse of <A>p</A>.
DeclareAttribute("PregroupInverse", IsElementOfPregroup);


DeclareAttribute("IntermultMap", IsElementOfPregroup);
DeclareAttribute("PregroupElementId", IsElementOfPregroup);
DeclareAttribute("__ID", IsElementOfPregroup);

