# Try to create all small pregroups.
# This test makes sure that all pregroup tables
# in the DB pass the axiom checks
gap> for n in [1,2,3,4,5,6,7] do
>         for i in [1..NrSmallPregroups(n)] do
>             p := SmallPregroup(n, i);
>         od;
>    od;
