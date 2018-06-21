#
# walrus: Computational Methods for Finitely Generated Monoids and Groups
#
# Reading the declaration part of the package.
#
if (not IsBound(__ANATPH_C)) and ("walrus" in SHOW_STAT()) then
  LoadStaticModule("datastructures");
fi;

if (not IsBound(__ANATPH_C)) and
   (Filename(DirectoriesPackagePrograms("walrus"), "walrus.so") <> fail) then
  LoadDynamicModule(Filename(DirectoriesPackagePrograms("walrus"), "walrus.so"));
fi;

# TODO: This should go
ReadPackage("walrus", "gap/type-helpers.gd");

DeclareInfoClass( "InfoANATPH" );

ReadPackage("walrus", "gap/util.gd");
ReadPackage("walrus", "gap/pregroup.gd");
ReadPackage("walrus", "gap/relator.gd");
ReadPackage("walrus", "gap/presentation.gd");
ReadPackage("walrus", "gap/location.gd");
ReadPackage("walrus", "gap/place.gd");
ReadPackage("walrus", "gap/anadata.gd");
ReadPackage("walrus", "gap/anatph.gd");
ReadPackage("walrus", "gap/small_pregroups.gd");
ReadPackage("walrus", "gap/examples.gd");
