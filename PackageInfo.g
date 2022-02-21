#
# walrus: Computational Methods for Finitely Generated Monoids and Groups
#
SetPackageInfo( rec(

PackageName := "walrus",
Subtitle := "A new approach to proving hyperbolicity",
Version := "0.9991",
Date := "21/02/2022", # dd/mm/yyyy format
License := "BSD-3-Clause",

Persons := [
  rec(
       IsAuthor := true,
       IsMaintainer := true,
       FirstNames := "Markus",
       LastName := "Pfeiffer",
       WWWHome := "http://www.morphism.de/~markusp/",
       Email := "markus.pfeiffer@st-andrews.ac.uk",
       PostalAddress := Concatenation(
                                       "School of Computer Science\n",
                                       "University of St Andrews\n",
                                       "Jack Cole Building, North Haugh\n",
                                       "St Andrews, Fife, KY16 9SX\n",
                                       "United Kingdom" ),
       Place := "St Andrews",
       Institution := "University of St Andrews",
      ),
],

PackageWWWHome := "https://gap-packages.github.io/walrus/",


SourceRepository := rec(
  Type := "git",
  URL := "https://github.com/gap-packages/walrus"
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
PackageWWWHome  := "https://gap-packages.github.io/walrus",
README_URL      := Concatenation( ~.PackageWWWHome, "/README.md" ),
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "/PackageInfo.g" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/walrus-", ~.Version ),

ArchiveFormats := ".tar.gz",

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages
##    "other"         for all other packages
##
Status := "deposited",

AbstractHTML   :=
"""An implementation of hyperbolicity testing using an ideas
by Derek Holt, Max Neunhöffer, Richard Parker, and Colva Roney-Dougal,
and probably quite a few more""",

PackageDoc := rec(
  BookName  := "walrus",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Computational Methods for Finitely Generated Monoids and Groups",
),

Dependencies := rec(
  GAP := ">= 4.10",
  NeededOtherPackages := [ [ "GAPDoc", ">= 1.5" ],
                           [ "datastructures", "0.2.2" ],
                           [ "digraphs", ">= 0.10" ]],
  SuggestedOtherPackages := [ [ "profiling", " >= 1.3.0"],
                              [ "kbmag", ">= 1.5.4" ]],
  ExternalConditions := [ ],
),

AvailabilityTest := function()
        return true;
    end,

TestFile := "tst/testall.g",

Keywords := [ "Finitely Generated", "group", "monoid", "hyperbolic" ],

));


