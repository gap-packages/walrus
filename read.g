#
# walrus: Computational Methods for Finitely Generated Monoids and Groups
#
# Reading the implementation part of the package.
#

# In principle this is naughty. This has been fixed in -master
# and will appear in 4.9 though
if ViewString(true) = "<object>" then
    InstallMethod(ViewString, "for a boolean", true, [ IsBool ], 5, String);
fi;

ReadPackage("walrus", "gap/util.gi");
ReadPackage("walrus", "gap/pregroup.gi");
ReadPackage("walrus", "gap/pregroupoffreegroup.gi");
ReadPackage("walrus", "gap/pregroupconstr.gi");
ReadPackage("walrus", "gap/relator.gi");
ReadPackage("walrus", "gap/presentation.gi");
ReadPackage("walrus", "gap/location.gi");
ReadPackage("walrus", "gap/place.gi");
ReadPackage("walrus", "gap/anadata.gi");
ReadPackage("walrus", "gap/anatph.gi");
ReadPackage("walrus", "gap/small_pregroups.gi");
ReadPackage("walrus", "gap/examples.gi");
