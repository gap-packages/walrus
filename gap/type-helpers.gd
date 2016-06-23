# 
#X Type construction helpers
#X These will be introduced in GAP 4.9, but since we want to run on stable-4.8 as well
#X we need to import them here.
#


if not IsBound(DeclareObject) then
    
DeclareGlobalFunction("DeclareObject");

InstallGlobalFunction( DeclareObject,
function(name, super, repfilter, attributes, properties)
    local cat
        , familyname, fam
        , repname, rep
        , typename, type
        , att, prop;

    #X Check whether name exists,
    #X check whether name is empty
    cat := NewCategory(name, super);
    BindGlobal(name, cat);

    familyname := Concatenation(name, "Family");
    fam := NewFamily(familyname);
    BindGlobal(familyname, fam);

    repname := Concatenation(name, "Rep");
    rep := NewRepresentation(repname, cat and repfilter, []);
    BindGlobal(repname, rep);

    for att in attributes do
        DeclareAttribute(att, cat);
    od;

    for prop in properties do
        DeclareProperty(prop, cat);
    od;

    typename := Concatenation(name, "Type");
    type := NewType(fam, rep);
    BindGlobal(typename, type);
end);

fi;
