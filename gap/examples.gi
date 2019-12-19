# Examples/Tests for ANATPH

# Jack Button's Group
# -------------------
#
# With presentation <a,b,t | a^t = ab, b^t = ba>
#
# Alan Logan says this is hyperbolic, but noone wants to publish
# this result alone.
#
# Tester now proves this to be hyperbolic, after corrected
# relation. Bug reported by email by Chris Chalk <chalk235@gmail.com>
#
InstallGlobalFunction("JackButtonGroup",
function()
    local pg;

    pg := PregroupOfFreeGroup(3);
    SetPregroupElementNames(pg, "1aAbBtT");
    return NewPregroupPresentation(pg, [ pg_word( pg, [7,2,6,5,3])
                                       , pg_word( pg, [7,4,6,3,5]) ]);
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
InstallGlobalFunction(TriangleCommutatorQuotient,
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

InstallGlobalFunction(RandomTriangleQuotient,
function(p,q,r,len)
    local pg;
    pg := PregroupOfFreeProduct( CyclicGroup(IsPermGroup, p)
                               , CyclicGroup(IsPermGroup, q) );
    # Do this to have slightly nicer display. Maybe we need to give the user
    # a way to label generators
    pg!.enams := "1xyY";
    return NewPregroupPresentation(pg,
                                   [ pg_word(pg, Repeat(r, [2,3])),
                                     RandomPregroupWord(pg, len)
                                   ]);
end);

InstallGlobalFunction(RandomPregroupWord,
function(pg, len)
    local i, lett, rel;

    rel := [];

    rel[1] := Random([2..Size(pg)]);
    for i in [2..len-1] do
        rel[i] := Random(Difference( [2..Size(pg)]
                                   , [__ID(PregroupInverse(pg[rel[i-1]]))]));
    od;
    rel[len] := Random(Difference([2..Size(pg)]
                                 , [ __ID(PregroupInverse(pg[rel[len - 1]]))
                                   , __ID(PregroupInverse(pg[rel[1]]))
                                   ] ));
    return pg_word(pg, rel);
end);

# Given a pregroup make a random presentation with nrel relators
# of length lrel
InstallGlobalFunction(RandomPregroupPresentation,
function(pg, nrel, lrel)
    local rels;

    rels := List([1..nrel], i -> RandomPregroupWord(pg, lrel));
    return NewPregroupPresentation(pg, rels);
end);


BindGlobal("CreateRandomExample",
function(path, pg, nrel, lrel)
    local pgp;

    if not IsDirectoryPath(path) then
        Error("path does not exist or is not a directory");
        return;
    fi;
    pgp := RandomPregroupPresentation(pg, nrel, lrel);

    # Write the pregroup presentation to file
    PregroupPresentationToFile(Concatenation(path, "/presentation-gap"), pgp);
    PregroupPresentationToSimpleFile(Concatenation(path, "/presentation-simple"), pgp);

    if WALRUS_kbmag_available then
    # Also create a KBMAG input file, if RSymTest succeeds on this presentation,
    # we can try computing an automatic structure and run gpgeowa on the result
    # to check whether the group is hyperbolic.
    WriteRWS(KBMAGRewritingSystem(PregroupPresentationToFpGroup(pgp)),
             Concatenation(path, "/presentation-kbmag"));
    fi;
end);

# Create a series of examples
BindGlobal("CreateRandomSeries",
function(pg, nrels, lrels, nexs, prf, basepath)
    local path, path2, i, pgp, lrel, nrel;

    if not IsDirectoryPath(basepath) then
        Error("path does not exist or is not a directory");
        return;
    fi;
    path := basepath;

    for lrel in lrels do
        CreateDir(Concatenation(path, "/", String(lrel)));
        for nrel in nrels do
            CreateDir(Concatenation(path, "/", String(lrel), "/", String(nrel)));
            for i in [1..nexs] do
                path2 := Concatenation(path, "/", String(lrel), "/", String(nrel), "/", String(i));
                prf("creating example nr ", i, " in ", path2, " \c");

                CreateDir(path2);
                CreateRandomExample(path2, pg, nrel, lrel);
                prf("\n");
            od;
        od;
    od;
end);

BindGlobal("CreateRandomSeriesOverSmallPregroups",
function(basepath)
    local i, n, sizes, path;

    if not IsDirectoryPath(basepath) then
        Error("path does not exist or is not a directory");
        return;
    fi;

    # at the moment we only have pregroups
    # of size 6
    sizes := [6];
    for n in sizes do
        CreateDir(Concatenation(basepath, "/", String(n)));
        for i in [1..NrSmallPregroups(n)] do
            path := Concatenation(basepath, "/", String(n), "/", String(i));
            CreateDir(path);
            CreateRandomSeries( SmallPregroup(n, i)
                              , [1,2,4,8,10]
                              , [5,10,15,20,25,30,35,40,45,50]
                              , 20
                              , Print
                              , path);
        od;
    od;
end);

BindGlobal("CreateRandomSeriesOverFreeGroup",
function(basepath)
    local i, n, sizes, path;

    if not IsDirectoryPath(basepath) then
        Error("path does not exist or is not a directory");
        return;
    fi;

    # ranks of free group
    sizes := [2,4,8,16,32,64];
    for n in sizes do
        path := Concatenation(basepath, "/", String(n));
        CreateDir(path);
        CreateRandomSeries( PregroupOfFreeGroup(n)
                          , [1,2,4,8,10]
                          , [5,10,15,20,25,30,35,40,45,50]
                          , 20
                          , Print
                          , path);
    od;
end);

BindGlobal("CreateRandomSeriesOverTrianglePregroup",
function(eps, p, q, nrel, lrel, nexs, prf, path)
    local pg;
    pg := PregroupOfFreeProduct( CyclicGroup( IsPermGroup, p)
                                , CyclicGroup( IsPermGroup, q) );
    pg!.enams := "1xyY";
    CreateRandomSeries( pg
                      , [1]
                      , [5,10,15,20,25,30,35,40,45,50]
                      , 20
                      , Print
                      , path );
end);

BindGlobal("CreateRandomSeriesOverTriangleGroup",
          function(eps, p, q, nrel, lrel, nexs, prf, path)
              local pg;
              pg := PregroupOfFreeProduct( CyclicGroup( IsPermGroup, p)
                                         , CyclicGroup( IsPermGroup, q) );
              pg!.enams := "1xyY";
              CreateRandomSeries( pg
                                , [1]
                                , [5,10,15,20,25,30,35,40,45,50]
                                , 20
                                , Print
                                , path );
          end);



BindGlobal("BenchmarkRandomPresentation",
function(pg, eps, nrel, lrel, nexs, prf, path)
    local i, pgp, start, stop, estart, estop, n, nfail, res, runt, fid, stream;

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
#        LogPregroupPresentation(path, pgp, res);
        prf(Float((estop - estart) / 1000000000), " seconds\n");
        Add(runt, [pgp, res, estop - estart]);
    od;
    stop := NanosecondsSinceEpoch();
    return rec( runtime := (stop - start) / 1000000000,
                samples := runt );
end);

BindGlobal("RandomPregroupFromSmallGroups",
function()
    local n, i, g1, g2;

    n := Random([1..64]);
    i := Random([1..NrSmallGroups(n)]);
    g1 := SmallGroup(n,i);

    n := Random([1..64]);
    i := Random([1..NrSmallGroups(n)]);
    g2 := SmallGroup(n,i);

    return PregroupOfFreeProduct(g1, g2);
end);

BindGlobal("BenchmarkRandom_TriPregroup",
function(eps, nrel, lrel, nexs, prf, path)
    local pg;
    pg := PregroupOfFreeProduct( CyclicGroup( IsPermGroup, 2)
                               , CyclicGroup( IsPermGroup, 3) );
    pg!.enams := "1xyY";
    return BenchmarkRandomPresentation(pg, eps, nrel, lrel, nexs, prf, path);
end);

BindGlobal("BenchmarkRandom_FreeGroupPregroup",
function(eps, ngen, nrel, lrel, nexs, prf, path)
    local pg;
    pg := PregroupOfFreeGroup(ngen);
    return BenchmarkRandomPresentation(pg, eps, nrel, lrel, nexs, prf, path);
end);

BindGlobal("BenchmarkRandom_OverSmallPregroup",
function(eps, nrel, lrel, nexs, prf, path)
    local pg, res;

    res := [];
    # FIXME: We only have pregroups of size 6 at the moment
    for pg in ANATPH_small_pregroups[6] do
        pg := PregroupByTable([1,'a','b','c','d', 'e'], pg);
        Add(res, BenchmarkRandomPresentation(pg, eps, nrel, lrel, nexs, prf, path));
    od;
    return res;
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
    local d, ngens, rlen, nrels, r, path;

    path := DirectoryTemporary();    
    prn("running standard benchmarks for anatph, ", nsamples, " each\n");

    prn("= = = = = = =\n");
    prn(" Quotients of free group pregroup\n");
    prn("= = = = = = =\n");
    for ngens in [2,4,8,16] do
        for nrels in [1,2,3,4] do
            for rlen in [10,20,30,40,50] do
                prn("running "
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
                                                  , path
                     );
                prn(StringBenchResult(AnalyseBenchmarkResult(r)));
            od;
        od;
    od;

    prn("= = = = = = =\n");
    prn(" Quotients of 2-3-triangle group pregroup\n");
    prn("= = = = = = =\n");
    for nrels in [1,2,3,4] do
        for rlen in [10,20,30,40,50] do
            prn("running ", nrels, "relators of length ", rlen, "\n");
            r := BenchmarkRandom_TriPregroup(
                                              1/12
                                            , nrels
                                            , rlen
                                            , nsamples
                                            , prn
                                            , path
                     );
            prn(StringBenchResult(AnalyseBenchmarkResult(r)));
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





