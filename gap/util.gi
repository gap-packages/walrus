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
    List(DirectoriesPackageLibrary("walrus", "tst/standard"), TestDirectory);
end);

#T Put pregroup relations in (if pregroup is not the pregroup of the free group)
#T Choose sensible generator names and print them (maybe just use x1,x2,... or a,b,c))
InstallGlobalFunction(PregroupPresentationToKBMAG,
    pres -> KBMAGRewritingSystem(PregroupPresentationToFpGroup(pres)));


InstallGlobalFunction(PregroupPresentationToFpGroup,
function(pres)
    local d, F, rels, gens, pg, p, i, j;

    # By Definition 2.2 of the paper
    d := Size(Pregroup(pres)) - 1;
    F := FreeGroup(d);
    pg := Pregroup(pres);

    rels := [];
    # rels := List([1..d], x -> [ F.(x) * F.(pg!.inv(x+1)-1), One(F) ]);
    for i in [2..d+1] do
        for j in [2..d+1] do
            p := pg[i] * pg[j];
            if p <> fail then
                if p = One(pg) then
                    Add(rels, [F.(i-1) * F.(j-1), One(F)]);
                else
                    Add(rels, [F.(i-1) * F.(j-1) * F.(__ID(PregroupInverse(p))-1), One(F)]);
                fi;
            fi;
        od;
    od;
    Append(rels, List(Relators(pres), x -> [Product(List(List(x), y -> F.(__ID(y)-1))), One(F)]));

    return F / rels;
end);


# Writes out pregroup as a multiplication table
# and then the relators, intended as a simple exchange
# format
InstallGlobalFunction(PregroupPresentationToSimpleStream,
function(stream, pres)
    local row, col, table, n, i, rel;

    table := MultiplicationTableIDs(Pregroup(pres));
    n := Length(table);
    AppendTo(stream, "pregroup:\n" );

    for row in [1..n] do
        AppendTo(stream, "  ");
        for col in [1..n-1] do
            AppendTo(stream, String(table[row][col]));
            AppendTo(stream, " ");
        od;
        AppendTo(stream, String(table[row][n]));
        AppendTo(stream, "\n");
    od;

    AppendTo(stream, "relators:\n");
    for rel in Relators(pres) do
        AppendTo(stream, "  ");
        for i in [1..Length(rel)-1] do
            AppendTo(stream, String(__ID(rel[i])));
            AppendTo(stream, " ");
        od;
        AppendTo(stream, String(__ID(rel[Length(rel)])));
        AppendTo(stream, "\n");
    od;
end);

# Serialises a pregroup presentation as a GAP record
# that GAP can read back easily
InstallGlobalFunction(PregroupPresentationToStream,
function(stream, pres)
    local res, rel, rels;

    res := rec( table := MultiplicationTableIDs(Pregroup(pres)),
                rels := List(Relators(pres), r -> List(r, x -> __ID(x))));

    PrintTo(stream, res, ";\n");
end);

InstallGlobalFunction(PregroupPresentationFromStream,
function(stream)
    local res, r, pg, rels;
    res := READ_ALL_COMMANDS(stream, false);

    if Length(res) = 1
       and res[1][1] = true
       and IsBound(res[1][2])
       and IsRecord(res[1][2]) then
        # FIXME: Store element names, at least don't put arbitarary
        #        restriction o nnumber of pregroup elts here
        r := res[1][2];
        pg := PregroupByTable("1abcdefghijklmnopqrstuvwxyz"{[1..Length(r.table)]}, r.table);
        return NewPregroupPresentation(pg, List(r.rels, x -> pg_word(pg, x)));
    else
        Error("Could not read pregroup presentation from stream");
    fi;
end);

InstallGlobalFunction(PregroupPresentationToFile,
function(filename, pres)
    local outs;

    outs := OutputTextFile(filename, false);
    SetPrintFormattingStatus(outs, false);
    PregroupPresentationToStream(outs, pres);
    CloseStream(outs);
end);

InstallGlobalFunction(PregroupPresentationToSimpleFile,
function(filename, pres)
    local outs;

    outs := OutputTextFile(filename, false);
    SetPrintFormattingStatus(outs, false);
    PregroupPresentationToSimpleStream(outs, pres);
    CloseStream(outs);
end);

