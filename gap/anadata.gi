
coordinateF := function(ql, key)
    local i, cc, res;
    cc := 1;
    res := 0;
    for i in [1..Length(ql)] do
        res := res + cc * (key[i] - 1);
        cc := cc * ql[i];
    od;
    return res + 1;
end;

# In reality we only need a list indexed by triples, so we
# will quite probably end up with a tree where the leaves have
# weights as labels.
InstallGlobalFunction(CyclicSubList,
function(l, pos, len)
    local r, i, j, llen;

    llen := Length(l);
    r := [];
    i := pos; j := 1;
    while j <= len do
        r[j] := l[i];
        i := i + 1; j := j + 1;
        if i > llen then
            i := 1;
        fi;
    od;

    return r;
end);

InstallGlobalFunction( IndexMinEnter,
function(idx, key, value)
    local it;

    it := coordinateF(idx[Length(idx)], key);
    idx[it] := Minimum(idx[it], value);
    return;


    it := HTUpdate(idx, key, value);
    if it = fail then
        HTAdd(idx, key, value);
    elif it < value then
        HTUpdate(idx, key, it);
    fi;

    return;

#   it := HTValue(idx, key);
#   if it = fail then
#       HTAdd(idx, k, value);
#   elif value < it then
#       HTUpdate(idx, key, value);
#   fi;
end);

InstallGlobalFunction( EnterAllSubwords,
function(idx, word, value)
    local i, pos, ww;
    pos := [1..Length(word)];
    ww := List(word, x -> __ID(x));
    for i in pos do
        IndexMinEnter(idx, ww{ CyclicSubList(pos, i, 3) }, value);
    od;
end);



