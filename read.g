#
# anatph: A new approach to proving hyperbolicity
#
# Reading the implementation part of the package.
#

# In principle this is naughty. This has been fixed in -master
# and will appear in 4.9 though
if ViewString(true) = "<object>" then
    InstallMethod(ViewString, "for a boolean", true, [ IsBool ], 5, String);
fi;

ReadPackage("anatph", "gap/util.gi");
ReadPackage("anatph", "gap/pregroup.gi");
ReadPackage("anatph", "gap/pregroupoffreegroup.gi");
ReadPackage("anatph", "gap/relator.gi");
ReadPackage("anatph", "gap/presentation.gi");
ReadPackage("anatph", "gap/location.gi");
ReadPackage("anatph", "gap/place.gi");
ReadPackage("anatph", "gap/anadata.gi");
ReadPackage("anatph", "gap/anatph.gi");
ReadPackage("anatph", "gap/examples.gi");

