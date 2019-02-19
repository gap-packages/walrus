#
# walrus: Computational Methods for Finitely Generated Monoids and Groups
#
# Reading the declaration part of the package.
#
DeclareInfoClass( "InfoWalrus" );

if IsPackageLoaded("kbmag") then
   BindConstant("WALRUS_kbmag_available", true);
else
   BindConstant("WALRUS_kbmag_available", false);
fi;

ReadPackage("walrus", "gap/util.gd");
ReadPackage("walrus", "gap/pregroup.gd");
ReadPackage("walrus", "gap/relator.gd");
ReadPackage("walrus", "gap/presentation.gd");
ReadPackage("walrus", "gap/location.gd");
ReadPackage("walrus", "gap/place.gd");
ReadPackage("walrus", "gap/anadata.gd");
ReadPackage("walrus", "gap/walrus.gd");
ReadPackage("walrus", "gap/small_pregroups.gd");
ReadPackage("walrus", "gap/examples.gd");
