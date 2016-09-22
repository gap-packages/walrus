#
# anatph: A new approach to proving hyperbolicity
#
#### Utility functions
# MaxPowerK: Input a word (relator) v over X, output w such that w^k = v, k maximal with this property
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

InstallGlobalFunction(MaxPowerK2,
function(rel)
    local len, divs, checkrep, w, k, d, r;

    len := Length(rel);
    divs := Reversed(DivisorsInt(len));
    Remove(divs,1);

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

    w := rel;
    k := divs[1];

    for d in divs do
        if not checkrep(d) then
            return [w,k];
        else
            r := MaxPowerK(w{[1..d]});
            k := k * r[2];
            w := r[1];
        fi;
    od;
end);

InstallGlobalFunction(AnatphTestStandard,
function()
    List(DirectoriesPackageLibrary("anatph", "tst/standard"), TestDirectory);
end);

