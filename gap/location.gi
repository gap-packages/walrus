#
# walrus: Computational Methods for Finitely Generated Monoids and Groups
#
## Locations

# NewLocation : IsPregroupRelator -> Int -> IsPregroupLocation
InstallGlobalFunction(NewLocation,
function(R,i)
    return Objectify(PregroupLocationType, [R, i, [], R[i-1], R[i]]);
end);

InstallMethod(Relator, "for a location",
              [ IsPregroupLocationRep ],
              l -> l![1]);

InstallMethod(Position, "for a location",
              [ IsPregroupLocationRep ],
              l -> l![2]);

InstallMethod(InLetter, "for a location",
              [ IsPregroupLocationRep ],
              l -> l![4] );

InstallMethod(OutLetter, "for a location",
              [ IsPregroupLocationRep ],
              l -> l![5] );

#X Get rid of this
InstallMethod(__ID, "for a location",
              [ IsPregroupLocationRep ],
              l -> l![6]);

# Return list of Places that have this location
InstallMethod(Places, "for a location",
              [ IsPregroupLocationRep ],
function(l)
    return l![3];
end);

InstallMethod(NextLocation, "for a location",
              [ IsPregroupLocationRep ],
function(l)
    local loc;

    # All locations on the relator that l is on
    loc := Locations(l![1]);
    if l![2] < Length(loc) then
        return loc[l![2] + 1];
    else
        return loc[1];
    fi;
end);

InstallMethod(PrevLocation, "for a location",
              [ IsPregroupLocationRep ],
function(l)
    local loc;

    # All locations on the relator that l is on
    loc := Locations(l![1]);
    if l![2] > 1 then
        return loc[l![2] - 1];
    else
        return loc[Length(loc)];
    fi;
end);

# Two locations are the same if they are on the same
# relator at the same index
InstallMethod(\=, "for a location and a location",
              [ IsPregroupLocationRep, IsPregroupLocationRep],
function(l,r)
    return (l![1] = r![1])
           and (l![2] = r![2]);
end);

InstallMethod(PregroupPresentationOf, "for a location",
              [ IsPregroupLocationRep ],
              l -> PregroupPresentationOf(l![1]));

InstallMethod(ViewString, "for a location",
              [ IsPregroupLocationRep ],
function(l)
    return STRINGIFY(ViewString(l![1]), "("
                     , l![2], ","
                     , ViewString(InLetter(l)), ","
                     , ViewString(OutLetter(l)), ")"
                    );
end);
