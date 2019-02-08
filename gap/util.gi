#
# walrus: Computational Methods for Finitely Generated Monoids and Groups
#
#### Utility functions

# Pregroup presentation for triangle group
InstallGlobalFunction(pg_word,
                      {pg, l} -> List(l, x->pg[x]) );

InstallGlobalFunction(Repeat,
                      {n, l} -> ShallowCopy(Flat(ListWithIdenticalEntries(n,l))));

# MaxPowerK: Input a word (relator) v over X, output w such that w^k = v, k
# maximal with this property InstallGlobalFunction(MaxPowerK,
InstallGlobalFunction(MaxPowerK,
function(rel)
    local len, d, divs, isrep,
          checkrep;

    len := Length(rel);
    divs := ShallowCopy(DivisorsInt(len));
    Remove(divs, 1);

    checkrep := function(d)
        local j,k;
        for j in [1..d] do
            for k in [1..(len / d) - 1] do
                if rel[j] <> rel[j + k*d] then
                    return false;
                fi;
            od;
        od;
        return true;
    end;

    for d in divs do
        if checkrep(d) then
            return [ rel{[1..d]}, len / d ];
        fi;
    od;

    return [ rel, 1 ];
end);

InstallGlobalFunction(WalrusTestStandard,
function()
    List(DirectoriesPackageLibrary("walrus", "tst/standard"), TestDirectory);
end);

