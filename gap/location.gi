#
# anatph: A new approach to proving hyperbolicity
#
## Locations
InstallGlobalFunction(NewLocation,
function(R,i,a,b)
    return Objectify(IsPregroupLocationType, [R,i,a,b]);
end);

InstallMethod(Relator, "for a location",
              [ IsPregroupLocationRep ],
              l -> l![1]);

InstallMethod(Position, "for a location",
              [ IsPregroupLocationRep ],
              l -> l![2]);

InstallMethod(InLetter, "for a location",
              [ IsPregroupLocationRep ],
              l -> l![3]);

InstallMethod(OutLetter, "for a location",
              [ IsPregroupLocationRep ],
              l -> l![4]);

# Return list of Places that have this location
InstallMethod(Places, "for a location",
              [ IsPregroupLocationRep ],
function(l)
    local p, places;
    places := [];
    for p in Places(Presentation(l)) do
        if Location(p) = l then
            Add(places, p);
        fi;
    od;
    return places;
end);

# Probably want to make a better comparison
InstallMethod(\=, "for a location and a location",
              [ IsPregroupLocationRep, IsPregroupLocationRep],
function(l,r)
    return ForAll([1..4], i -> l![i] = r![i]);
end);

InstallMethod(Presentation, "for a location",
              [ IsPregroupLocationRep ],
              l -> Presentation(l![1]));

InstallMethod(ViewString, "for a location",
              [ IsPregroupLocationRep ],
function(l)
    return STRINGIFY(ViewString(l![1]), "("
                     , l![2], ","
                     , ViewString(l![3]), ","
                     , ViewString(l![4]), ")"
                    );
end);
