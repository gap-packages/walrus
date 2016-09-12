# Dictionaries/Hashmaps/Lookuptables for anatph

DeclareCategory("IsANAMap", IsObject and IsCollection);
BindGlobal("ANAMapFamily", NewFamily("ANAMapFamily"));

DeclareRepresentation("IsANAMapListRep", IsANAMap and IsPositionalObjectRep, []);

BindGLobal("ANAMapListType", NewType( ANAMapFamily, IsANAMapListRep));

DeclareGlobalFunction("NewANAMap");
DeclareOperation("AddOrUpdate", [AnaMAP, IsObject, IsObject]);
