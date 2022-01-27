#
# walrus: Computational Methods for Finitely Generated Monoids and Groups
#
# This file is a script which compiles the package manual.
#
if fail = LoadPackage("AutoDoc", ">= 2019.04.10") then
    Error("AutoDoc 2019.04.10 or newer is required");
fi;

AutoDoc( rec( scaffold := true # scaffold := rec( includes :=
              #                 [ "overview.xml"
              #                 , "magmainterface.xml" ] )
            , autodoc := rec( files := [ "doc/Intros.autodoc" ] ) ) );

QUIT;
