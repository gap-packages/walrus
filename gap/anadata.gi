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

InstallGlobalFunction( EnterAllSubwords,
function(idx, word, value)
    local i, v, pos, ww;
    pos := [1..Length(word)];
    ww := List(word, x -> __ID(x));
    for i in pos do
        v := idx[ ww{ CyclicSubList(pos, i, 3) } ];
        if value < v then
            idx[ ww{ CyclicSubList(pos, i, 3) } ] := value;
        fi;
    od;
end);



