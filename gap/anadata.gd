# Dictionaries/Hashmaps/Lookuptables for anatph

DeclareCategory("IsANAMap", IsObject and IsCollection);
BindGlobal("ANAMapFamily", NewFamily("ANAMapFamily"));

DeclareRepresentation("IsANAMapListRep", IsANAMap and IsPositionalObjectRep, []);

BindGlobal("ANAMapListType", NewType( ANAMapFamily, IsANAMapListRep));

DeclareGlobalFunction("NewANAMap");
DeclareOperation("AddOrUpdate", [IsANAMap, IsObject, IsObject, IsObject]);
DeclareOperation("Merge", [IsANAMap, IsANAMap]);
DeclareOperation("Keys", [IsANAMap]);
DeclareOperation("Merge", [IsANAMap, IsANAMap] );

