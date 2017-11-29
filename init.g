#
# anatph: A new approach to proving hyperbolicity
#
# Reading the declaration part of the package.
#
ReadPackage("anatph", "gap/type-helpers.gd");

if not IsBound(NanosecondsSinceEpoch) then
  Print("No NanosecondsSinceEpoch, emulating with io\n");
  NanosecondsSinceEpoch := function()
    local r;
    r := IO_gettimeofday();
    return (r.tv_sec * 1000000 + r.tv_usec) * 1000;
  end;
fi;

if ApplicableMethod(Rat, [ 1/2 ]) = fail then
  Print("No applicable method for Rat with filter IsRat, invoking InstallMethod(Rat, [ IsRat ], IdFunc );");
  InstallMethod(Rat, [ IsRat ], IdFunc );
fi;

DeclareInfoClass( "InfoANATPH" );

ReadPackage("anatph", "gap/util.gd");
ReadPackage("anatph", "gap/pregroup.gd");
ReadPackage("anatph", "gap/relator.gd");
ReadPackage("anatph", "gap/presentation.gd");
ReadPackage("anatph", "gap/location.gd");
ReadPackage("anatph", "gap/place.gd");
ReadPackage("anatph", "gap/anadata.gd");
ReadPackage("anatph", "gap/anatph.gd");
ReadPackage("anatph", "gap/examples.gd");
