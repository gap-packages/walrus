# Examples/Tests for ANATPH

# Pregroup for triangle group example
tg_pg := PregroupByTable("1xyY"
                          , a -> a ^ (3,4)
                          , [ [1,2,3,4],
                              [2,1,0,0],
                              [3,0,4,1],
                              [4,0,1,3] ]
                          );

# Pregroup presentation for triangle group
tg_pgp := PregroupPresentation(tg_pg, []);

inm_pg := PregroupByTable("1aAbBcCxX"
                           , a -> a^(2,3)(4,5)(6,7)(8,9)
                           #     1,a,A,b,B,c,C,x,X
                           , [ [ 1,2,3,4,5,6,7,8,9 ]
                             , [ 2,0,1,0,0,0,0,6,0 ]
                             , [ 3,1,0,0,0,8,0,0,0 ]
                             , [ 4,0,0,0,1,0,0,0,0 ]
                             , [ 5,0,0,1,0,0,0,6,0 ]
                             , [ 6,0,0,0,0,0,1,0,2 ]
                             , [ 7,9,0,0,0,1,0,0,0 ]
                             , [ 8,0,0,0,0,0,3,0,1 ]
                             , [ 9,0,7,7,0,0,0,1,0 ] ]
                           );

