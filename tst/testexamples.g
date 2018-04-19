ConvertWordFreeGroup := function(w)
    local i, j, g, k, res;

    res := [];

    for i in [1,3..Length(w)-1] do
        if w[i+1] > 0 then
            g := 2 * w[i];
            k := w[i+1];
        else
            g := 2 * w[i] + 1;
            k := -w[i+1];
        fi;

        for j in [1..k] do
            Add(res, g );
        od;
    od;
    return res;
end;

ConvertWordPSL := function(w)
    local i, j, g, k, res;

    res := [];

    for i in [1,3..Length(w)-1] do
        if w{[i, i+1]} in [ [1,1], [1,-1] ] then
            g := 2;
            k := 1;
        elif w{[i, i+1]} in [ [2,1] ] then
            g := 3;
            k := 1;
        elif w{[i, i+1]} in [ [2,-1] ] then
            g := 4;
            k := 1;
        else
            Error("this shouldn't happen");
        fi;

        for j in [1..k] do
            Add(res, g );
        od;
    od;
    return res;
end;

ConvertWordS3S3 := function(w)
    local i, j, g, k, res;

    res := [];

    for i in [1,3..Length(w)-1] do
        if w{[i, i+1]} in [ [1,1], [1,-1] ] then
            g := 2;
            k := 1;
        elif w{[i, i+1]} in [ [2,1], [2,-1] ] then
            g := 3;
            k := 1;
        elif w{[i, i+1]} in [ [3,1], [3,-1] ] then
            g := 4;
            k := 1;
        elif w{[i, i+1]} in [ [5,1], [5,-1] ] then
            g := 7;
            k := 1;
        elif w{[i, i+1]} in [ [6,1], [6,-1] ] then
            g := 8;
            k := 1;
        elif w{[i, i+1]} in [ [7,1], [7,-1] ] then
            g := 9;
            k := 1;
        elif w{[i, i+1]} in [ [4,1] ] then
            g := 5;
            k := 1;
        elif w{[i, i+1]} in [ [4,-1] ] then
            g := 6;
            k := 1;
        elif w{[i, i+1]} in [ [8,1] ] then
            g := 10;
            k := 1;
        elif w{[i, i+1]} in [ [8,-1] ] then
            g := 11;
            k := 1;
        else
            Error("this shouldn't happen");
        fi;

        for j in [1..k] do
            Add(res, g );
        od;
    od;
    return res;
end;

MakeExample := function(pg, converter, rels)
    return NewPregroupPresentation(pg, List(rels, r -> pg_word(pg, converter(ExtRepOfObj(r)))));
end;

TestExampleList := function(pg, converter, relss, ress, eps, timing)
    local g, pres, rsym, res, rels, setup, vg, vgd, run;

    res := [];

    for rels in [1..Length(relss)] do
        Print("testing: ", rels, "\c");

        setup := NanosecondsSinceEpoch();
        pres := MakeExample(pg, converter, relss[rels]);
        setup := NanosecondsSinceEpoch() - setup;

        vg := NanosecondsSinceEpoch();
        VertexGraph(pres);
        vg := NanosecondsSinceEpoch() - vg;

       	vgd := NanosecondsSinceEpoch();
        VertexGraphDistances(pres);
        vgd := NanosecondsSinceEpoch() - vgd;  

        run := NanosecondsSinceEpoch();
        rsym := RSymTest(pres, eps);
        run := NanosecondsSinceEpoch() - run;
        Print("...done: ");
        if timing then
            Print("\n");
            Print("(setup: ", setup / 1000000., "ms\n",
                   "vg:    ", vg / 1000000., "ms\n",
                   "vgd:   ", vgd / 1000000., "ms\n",
                   "rsym:  ", run / 1000000., "ms)\n");
        fi;
        if IsList(rsym) then
            Print("false");
            if ress[rels] = true then
                Print(" fail, expect true, but got false");
            fi;
            Add(res, false);
        else
            if ress[rels] = false then
                Print(" fail, expect false, but got true");
            fi;
            Print("true");
            Add(res, true);
        fi;
        Print("\n");
    od;

    return res;
end;

