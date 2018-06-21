#
# walrus: Computational Methods for Finitely Generated Monoids and Groups
#
# This file runs package tests. It is also referenced in the package
# metadata in PackageInfo.g.
#
SetInfoLevel(InfoPackageLoading, 4);

LoadPackage( "walrus" );

TestDirectory( DirectoriesPackageLibrary("walrus", "tst"),
            rec(exitGAP := true, testOptions := rec(compareFunction := "uptowhitespace") ) );

# Should never get here
FORCE_QUIT_GAP(1);
