#
# anatph: A new approach to proving hyperbolicity
#
SetPackageInfo( rec(

PackageName := "anatph",
Subtitle := "A new approach to proving hyperbolicity",
Version := "0.3",
Date := "26/11/2017", # dd/mm/yyyy format

Persons := [
  rec(
       IsAuthor := true,
       IsMaintainer := true,
       FirstNames := "Colva",
       LastName := "Roney-Dougal",
       WWWHome := "",
       Email := "colva.roney-dougal@st-andrews.ac.uk",
       PostalAddress := Concatenation(
                                       "School of Mathematics\n",
                                       "University of St Andrews\n",
                                       "St Andrews, Fife, KY16 9SS\n",
                                       "United Kingdom" ),
       Place := "St Andrews",
       Institution := "University of St Andrews",
      ),
  rec(
       IsAuthor := true,
       IsMaintainer := true,
       FirstNames := "Derek",
       LastName := "Holt",
       WWWHome := "",
       Email := "",
       PostalAddress := Concatenation(
                                       "School of Mathematics\n",
                                       "University of Warwick\n",
                                       "\n",
                                       "United Kingdom" ),
       Place := "Warwick",
       Institution := "University of Warwick",
      ),
  rec(
       IsAuthor := true,
       IsMaintainer := true,
       FirstNames := "Richard",
       LastName := "Parker",
       WWWHome := "",
       Email := "",
       PostalAddress := "United Kingdom",
       Place := "Cambridge",
       Institution := "",
      ),
  rec(
       IsAuthor := true,
       IsMaintainer := true,
       FirstNames := "Stephen",
       LastName := "Linton",
       WWWHome := "",
       Email := "sal4@st-andrews.ac.uk",
       PostalAddress := Concatenation(
                                       "School of Computer Science\n",
                                       "University of St Andrews\n",
                                       "Jack Cole Building, North Haugh\n",
                                       "St Andrews, Fife, KY16 9SX\n",
                                       "United Kingdom" ),
       Place := "St Andrews",
       Institution := "University of St Andrews",
      ),
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

PackageWWWHome := "https://gap-packages.github.io/anatph/",

ArchiveURL     := Concatenation( ~.PackageWWWHome, "anatph-", ~.Version ),
README_URL     := Concatenation( ~.PackageWWWHome, "README" ),
PackageInfoURL := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),

ArchiveFormats := ".tar.gz",

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages
##    "other"         for all other packages
##
Status := "dev",

AbstractHTML   :=  "",

PackageDoc := rec(
  BookName  := "anatph",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "A new approach to proving hyperbolicity",
),

Dependencies := rec(
  GAP := ">= 4.8",
  NeededOtherPackages := [ [ "GAPDoc", ">= 1.5" ],
                           [ "datastructures", "0.0.0" ],
                           [ "digraphs", ">= 0.10" ],
                           [ "kbmag", ">= 1.5.4" ]],
  SuggestedOtherPackages := [ [ "profiling", " >= 1.3.0"] ],
  ExternalConditions := [ ],
),

AvailabilityTest := function()
        return true;
    end,

TestFile := "tst/testall.g",

#Keywords := [ "TODO" ],

));


