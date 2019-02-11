
#! @Chapter Pregroups

#! @Section Small Pregroups
#! This package contains a small database of pregroups of sizes <M>1</M> to
#! <M>7</M>. The database was computed by Chris Jefferson using the Minion constraint solver.
#! <P/>
#! These small pregroups currently used for testing. Accessing the small
#! pregroups database works as follows.

# The global variable holding the small pregroups.
BindGlobal("ANATPH_small_pregroups", []);

#! @Arguments n
#! @Description
#! Returns the number of pregroups of size <A>n</A> available in the database.
#! @Returns an integer.
DeclareGlobalFunction("NrSmallPregroups");

#! @Arguments n, i
#! @Description
#! Returns the <A>i</A>th pregroup of size <A>n</A> from the database of small pregroups.
#! @Returns a pregroup.
DeclareGlobalFunction("SmallPregroup");
