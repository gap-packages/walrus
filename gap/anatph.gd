#
# anatph: A new approach to proving hyperbolicity
#
# Declarations
#

#T Elements of PreGroups?

DeclareCategory("IsPreGroup", IsObject);
BindGlobal("PreGroupFamily", NewFamily("PreGroupFamily"));

DeclareRepresentation("IsPreGroupTableRep", IsPreGroup and IsComponentObjectRep, []);
BindGlobal("PreGroupByTableType",
           NewType( PreGroupFamily, IsPreGroupTableRep));

DeclareGlobalFunction("PreGroupByTableNC");
DeclareGlobalFunction("PreGroupByTable");

DeclareOperation("[]", [IsPreGroupTableRep, IsInt]);

DeclareCategory("IsElementOfPreGroup", IsMultiplicativeElement);
DeclareRepresentation("IsElementOfPreGroupRep", IsElementOfPreGroup and IsComponentObjectRep, []);



