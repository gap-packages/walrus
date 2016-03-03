#
# anatph: A new approach to proving hyperbolicity
#
# Reading the declaration part of the package.
#
_PATH_SO:=Filename(DirectoriesPackagePrograms("anatph"), "anatph.so");
if _PATH_SO <> fail then
    LoadDynamicModule(_PATH_SO);
fi;
Unbind(_PATH_SO);

ReadPackage( "anatph", "gap/pregroup.gd");
ReadPackage( "anatph", "gap/anatph.gd");
