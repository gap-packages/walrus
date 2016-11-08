# Dictionaries/Hashmaps/Lookuptables for anatph

# Use type-helpers

DeclareCategory("IsANAMap", IsObject and IsCollection);
BindGlobal("ANAMapFamily", NewFamily("ANAMapFamily"));

DeclareRepresentation("IsANAMapListRep", IsANAMap and IsPositionalObjectRep, []);

BindGlobal("ANAMapListType", NewType( ANAMapFamily, IsANAMapListRep));

DeclareGlobalFunction("NewANAMap");
DeclareOperation("AddOrUpdate", [IsANAMap, IsObject, IsObject, IsObject]);
DeclareOperation("Keys", [IsANAMap]);
DeclareOperation("Values", [IsANAMap]);
DeclareOperation("Lookup", [IsANAMap, IsObject, IsObject]);

#X Make this into a proper datastructure
DeclareGlobalFunction("CyclicSubList");
DeclareGlobalFunction("IndexMinEnter");
DeclareGlobalFunction("EnterAllSubwords");


