# Examples/Tests for ANATPH

# Pregroup presentation for triangle group
pg_word := function(pg, l) return List(l, x->pg[x]);
           end;

Repeat := function(n, l);
    return ShallowCopy(Flat(ListWithIdenticalEntries(n,l)));
end;

# Jack Button's Group
# -------------------
#
# With presentation <a,b,t | a^t = ab, b^t = ba>
#
# Alan Logan says this is hyperbolic, but noone wants to publish
# this result alone. At the moment the tester fails though.
#
InstallGlobalFunction("JackButtonGroup",
function()
    local pg;

    pg := PregroupOfFreeGroup(3);
    SetPregroupElementNames(pg, "1aAbBtT");
    return NewPregroupPresentation(pg, [ pg_word( pg, [7,2,6,5,3])
                                       , pg_word( pg, [7,2,6,3,5]) ]);
end);

# Triangle Groups
# ---------------
# As demonstrated in Proposition 9.4 of anatph, for l > 2 (and hence n > 3 if the
# group is supposed to be hyperbolic) there are no instantiable green places, and if
# l = 2 then there are exactly two instantiable green places.
InstallGlobalFunction("TriangleGroup",
function(l,m,n)
    local pg;
    pg := PregroupOfFreeProduct( CyclicGroup( IsPermGroup, l)
                               , CyclicGroup( IsPermGroup, m) );

    # This is a bit icky, we can't tell which element of pg is the one of the
    # second cyclic group
    return NewPregroupPresentation(pg, [ pg_word( pg, Repeat(n, [2, l + 1]))]);
end);

# Example from Theorem 9.5, triangle-like: quotient of 2-3-m triangle group
# our choice of pregroup is the free product of cyclic groups of order 2 and 3
#T see what happens if we present this group as
#T <x,y,z | x^2, y^3, z^m, (zxY)^n > ?
#T we push a parameter into the pregroup
InstallGlobalFunction(TriSH,
function(m,n)
    local pg;
    pg := PregroupOfFreeProduct( CyclicGroup(IsPermGroup, 2)
                               , CyclicGroup(IsPermGroup, 3) );
    # Do this to have slightly nicer display. Maybe we need to give the user
    # a way to label generators
    pg!.enams := "1xyY";
    return NewPregroupPresentation(pg,
                                   [ pg_word(pg, Repeat(m, [2,3])),
                                     pg_word(pg, Repeat(n, [2,3,2,4]))
                                   ]);
end);

# Given a pregroup make a random presentation with nrel relators
# of length lrel
InstallGlobalFunction(RandomPregroupPresentation,
function(pg, nrel, lrel)
    local pp, rel, rels, i, j, lett;
    
    rels := [];
    for i in [1..nrel] do
        rel := [];
        Add(rels,rel);
        lett := Random([2..Size(pg)]);
        Add(rel, lett);
        for j in [2..lrel-1] do
            lett := Random(Difference( [2..Size(pg)]
                                     , [__ID(PregroupInverse(pg[lett]))]));
            Add(rel, lett);
        od;
        # this is bound to go wrong if we only have 2 generators,
        # but then our group is a quotient of free of rank 1...
        lett := Random(Difference([2..Size(pg)]
                                 , [ __ID(PregroupInverse(pg[lett]))
                                   , __ID(PregroupInverse(pg[rel[1]]))
                                   ] ));
        Add(rel, lett);
    od;
    return NewPregroupPresentation(pg, List(rels, r -> pg_word(pg, r)));
end);


BindGlobal("BenchmarkRandomPresentation",
function(pg, eps, nrel, lrel, nexs, prf)
    local i, pgp, start, stop, estart, estop, n, nfail, res, runt;

    n := 0;
    runt := [];

    start := NanosecondsSinceEpoch();
    for i in [1..nexs] do
        prf("creating example nr ", i, ", \c");
        pgp := RandomPregroupPresentation(pg, nrel, lrel);
        prf("starting RSymTest, \c");
        estart := NanosecondsSinceEpoch();
        res := RSymTest(pgp, eps);
        estop := NanosecondsSinceEpoch();
        if res = true then
            prf("succeeded after \c");
        else
            prf("failed \c");
        fi;
        prf(Float((estop - estart) / 1000000000), " seconds\n");
        Add(runt, [pgp, res, estop - estart]);
    od;
    stop := NanosecondsSinceEpoch();
    return rec( runtime := (stop - start) / 1000000000,
                samples := runt );
end);

BindGlobal("BenchmarkRandom_TriPregroup",
function(eps, nrel, lrel, nexs, prf)
    local pg;
    pg := PregroupOfFreeProduct( CyclicGroup( IsPermGroup, 2)
                               , CyclicGroup( IsPermGroup, 3) );
    pg!.enams := "1xyY";
    return BenchmarkRandomPresentation(pg, eps, nrel, lrel, nexs, prf);
end);

BindGlobal("BenchmarkRandom_FreeGroupPregroup",
function(eps, ngen, nrel, lrel, nexs, prf)
    local pg;
    pg := PregroupOfFreeGroup(ngen);
    return BenchmarkRandomPresentation(pg, eps, nrel, lrel, nexs, prf);
end);

BindGlobal("_VARIANCE",
function(v)
    local q, avg;
    if Length(v) = 1 then
        q := 1;
    else
        q := Length(v) - 1;
    fi;
    avg := Average(v);
    return Sum(List(v, x -> (x - avg)^2)) / (q);
end);

BindGlobal("AnalyseBenchmarkResult",
function(res)
    local r, succed, failed;

    r := rec();

    r.n := Length(res.samples);
    r.rt_avg := Average(List(res.samples, x->x[3]));
    r.rt_std := Sqrt(Float(_VARIANCE(List(res.samples, x->x[3]))));

    succed := Filtered(res.samples, x -> not IsList(x[2]));
    r.succed_n := Length(succed);
    if r.succed_n > 0 then
        r.succed_rt_avg := Average(List(succed, x->x[3]));
        r.succed_rt_std := Sqrt(Float(_VARIANCE(List(succed, x->x[3]))));
    fi;

    failed := Filtered(res.samples, x -> IsList(x[2]));
    r.failed_n := Length(failed);
    if r.failed_n > 0 then
        r.failed_rt_avg := Average(List(failed, x->x[3]));
        r.failed_rt_std := Sqrt(Float(_VARIANCE(List(failed, x->x[3]))));
    fi;

    return r;
end);

BindGlobal("StringBenchResult",
function(r)
    local res;
    
    res := STRINGIFY("n: ", r.n, ", s: ", r.succed_n, " f: ", r.failed_n, " (", Float(r.succed_n) / r.n, ")\n",
                     " (", Float(r.rt_avg), ",", r.rt_std, ")\n");
    Append(res, STRINGIFY(" success: ", r.succed_n));
    if r.succed_n > 0 then
        Append(res, STRINGIFY(" ", Float(r.succed_rt_avg), ",", r.succed_rt_std, "\n"));
    fi;
    Append(res, STRINGIFY(" failure: ", r.failed_n));
    if r.failed_n > 0 then
        Append(res, STRINGIFY(" ", Float(r.failed_rt_avg), ",", r.failed_rt_std, "\n"));
    fi;
    if res[Length(res)] <> '\n' then
        Add(res, '\n');
    fi;
    return res;
end);
    
BindGlobal("StandardBenchmarks",
function(nsamples, prn)
    local d, ngens, rlen, nrels, r;
    
    Print("running standard benchmarks for anatph, ", nsamples, " each\n");

    Print("= = = = = = =\n");
    Print(" Quotients of free group pregroup\n");
    Print("= = = = = = =\n");
    for ngens in [2,4,8,16,32] do
        for nrels in [1,2,3,4,5] do
            for rlen in [10,20,30,40,50,60] do
                Print("running "
                     , ngens, " generators, "
                     , nrels, " relators "
                     , "of length ", rlen, "\n");
                r := BenchmarkRandom_FreeGroupPregroup(
                                                    1/12
                                                  , ngens
                                                  , nrels
                                                  , rlen
                                                  , nsamples
                                                  , prn
                     );
                Print(StringBenchResult(AnalyseBenchmarkResult(r)));
            od;
        od;
    od;

    Print("= = = = = = =\n");
    Print(" Quotients of 2-3-triangle group pregroup\n");
    Print("= = = = = = =\n");
    for nrels in [1,2,3,4,5] do
        for rlen in [10,20,30,40,50,60] do
            Print("running ", nrels, "relators of length ", rlen, "\n");
            r := BenchmarkRandom_TriPregroup(
                                              1/12
                                            , nrels
                                            , rlen
                                            , nsamples
                                            , prn
                     );
            Print(StringBenchResult(AnalyseBenchmarkResult(r)));
        od;
    od;

end);

BenchmarkSinglePres := function(eps, pg, nrel, len)
    local r,t,res;
    r := RandomPregroupPresentation(pg, nrel, len);
    t := NanosecondsSinceEpoch();
    res := RSymTest(r, eps);
    t := NanosecondsSinceEpoch() - t;
    return [r, res, t / 1000000000.];
end;

if IsBound(OutputAnnotatedCodeCoverageFiles) then
    ProfileSinglePresentation := function(eps, pg, nrel, len)
    local t, dir, fn;

    dir := DirectoryTemporary();
    fn := Filename(dir, "anatph.gz");

    Print("Profiling presentation to ", fn, "\n");
    ProfileLineByLine(fn);
    t := BenchmarkSinglePres(eps, pg, nrel, len);
    UnprofileLineByLine();

    Print("Writing annotated code coverage to ", Filename(dir, ""), "\n");
    OutputAnnotatedCodeCoverageFiles(fn, Filename(dir, ""));

    return t;
end;

else
    Print("profiling package is not available, disabling ProfileSinglePresentation\n");
fi;

# Benchmark the RSym tester with a presentation given <A>density</A>
# and <A>length</A>
BenchmarkGromovDensity := function(eps, ngens, length, density)
    local pg, nrels;

    pg := PregroupOfFreeGroup(ngens);
    nrels := Int( (2 * ngens - 1)^Float(density * length ) );
    Print("number of relators: ", nrels, "\n");
    return BenchmarkSinglePres(eps
                              , pg
                              , nrels
                              , length );
end;





