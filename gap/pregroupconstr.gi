# Takes two groups, and builds the pregroup underlying the free product of
# these two groups
#
# don't try using this on large groups.
#
InstallMethod(PregroupOfFreeProduct, "for two finite groups",
              [IsGroup and IsFinite, IsGroup and IsFinite],
function(G, H)
    local i, j, size, table, eltn;

    size := Size(G) + Size(H) - 1;
    table := NullMat(size,size);

    table{[2..Size(G)]}{[2..Size(G)]} := MultiplicationTable(G){[2..Size(G)]}{[2..Size(G)]};
    table{[Size(G)+1..size]}{[Size(G)+1..size]} := Size(G) - 1 + MultiplicationTable(H){[2..Size(H)]}{[2..Size(H)]};

    for i in [Size(G) + 1 .. size ] do
        for j in [Size(G) + 1 .. size ] do
            if table[i][j] = Size(G) then
                table[i][j] := 1;
            fi;
        od;
    od;

    for i in [1..size] do
        table[1][i] := i;
        table[i][1] := i;
    od;

    eltn := List([1..size], String);
    return PregroupByTable(eltn, table);
end);

# Pregroup of free product of entered groups
InstallGlobalFunction(PregroupOfFreeProductList,
function(l)
    local r;

    r.groups := l;

    return Objectify(PregroupOfFreeProductType, r);
end);


InstallMethod(PregroupByRedRelators,
              "for a free group, and a list of words of length 3",
              [ IsFreeGroup, IsList, IsList ],
function(F, rred, inv)
    local rkF, n, enams, table, i, j, r, pg, convert, ic;

    rkF := Length(GeneratorsOfGroup(F));

    if ForAny(rred, x -> not ( (x in F) and ( Length(x) = 3 ) ) ) then
        Error("rred has to be a list of words of length 3 over F");
    fi;

    ic := Length(inv);
    n := 1 + 2 * rkF;
    enams := Concatenation(["1"]
                          , Concatenation( List([1..rkF],
                                 x -> [ Concatenation("x", String(x))
                                      , Concatenation("X", String(x)) ] )));
    table := NullMat(n, n);

    # Multiplication by 1
    for i in [1..n] do
        table[1,i] := i;
        table[i,1] := i;
    od;

    # Multiplication of mutual inverse generators in
    # Free group
    for i in [2, 4..2 * rkF] do
        table[i, i+1] := 1;
        table[i+1, i] := 1;
    od;

    for i in inv do
        table[ 2*i, 2*i] := 1;
        table[ 2*i, 2*i + 1] := 0;
        table[ 2*i + 1, 2*i] := 0;
        table[ 2*i+1 , 2*i+1] := 1;

    od;

    convert := function(x)
        if x > 0 then
            return 2 * x;
        else
            # involution
            if -x in inv then
                return 2 * (-x);
            else
                return 2 * (-x) + 1;
            fi;
        fi;
    end;

    # Enter red relators
    # for r = x * y * z we get 
    # - x * y = z^-1
    # - x = z^-1 * y^-1
    # - y * z = x ^ -1
    # - z = y^-1 * x^-1
    # - y = x^-1 * z^-1
    # - y^-1 = z * x
    for r in List(rred, LetterRepAssocWord) do
        table[ convert(r[1]), convert(r[2]) ] := convert(-r[3]);
        table[ convert(-r[3]), convert(-r[2]) ] := convert(r[1]);
        table[ convert(r[2]), convert(r[3]) ] := convert(-r[1]);
        table[ convert(-r[2]), convert(-r[1]) ] := convert(r[3]);
        table[ convert(-r[1]), convert(-r[3]) ] := convert(r[2]);
        table[ convert(r[3]), convert(r[1]) ] := convert(-r[2]);
    od;
    pg := PregroupByTable(enams, table);
    pg!.freegroup := F;
    pg!.convert_word := w -> List(LetterRepAssocWord(w), l -> pg[convert(l)]);
    return pg;
end);


