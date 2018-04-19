#
# anatph: A new approach to proving hyperbolicity
#
# Reading the declaration part of the package.
#
if (not IsBound(__ANATPH_C)) and ("anatph" in SHOW_STAT()) then
  LoadStaticModule("datastructures");
fi;

if (not IsBound(__ANATPH_C)) and
   (Filename(DirectoriesPackagePrograms("anatph"), "anatph.so") <> fail) then
  LoadDynamicModule(Filename(DirectoriesPackagePrograms("anatph"), "anatph.so"));
fi;

# TODO: This should go
ReadPackage("anatph", "gap/type-helpers.gd");

DeclareInfoClass( "InfoANATPH" );

ReadPackage("anatph", "gap/util.gd");
ReadPackage("anatph", "gap/pregroup.gd");
ReadPackage("anatph", "gap/relator.gd");
ReadPackage("anatph", "gap/presentation.gd");
ReadPackage("anatph", "gap/location.gd");
ReadPackage("anatph", "gap/place.gd");
ReadPackage("anatph", "gap/anadata.gd");
ReadPackage("anatph", "gap/anatph.gd");
ReadPackage("anatph", "gap/small_pregroups.gd");
ReadPackage("anatph", "gap/examples.gd");
