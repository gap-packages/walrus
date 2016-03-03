#
# anatph: A new approach to proving hyperbolicity
#
# Implementations
#

####################################
#
#
# Assumptions
#  I(Rels) only contains cyclic conjugates of R in Rels


# we have a bijection between \underline{\abs{P}} and P, i.e. number
# the elements of P.
# we also have an involution sigma : P -> P which inverts elements
# notational convention -i = sigma(i)
#
# We also have names for elements of P for better readability
# 
# relations are (compressed?) strings over P, i.e. lists of pairs
# [i,e] 

#
# Rels rep'd as a list of ints, for instance x^2y^-2 -> [[1,2],[2, -2]]
# unfortunately of course [x,-2] = [-x,2]
#


# MaxPowerK: Input a word v over X, output w such that w^k = v, k maximal with this property
#
# in the following w is the output of MaxPowerK
#
# location (i,a,b) where i in [1..Length(w)] a = w[i-1] and b = w[i] (so a
# location on R can be represented by just  the, well, location on w (?))
# R(i,a,b) if the relator is R, and so this involved MaxPowerK(R) as well!

# Place (R(i,a,b), c, C, B) R(i,a,b) is a place c is a generator C in [G,B], B
# in [true,false]


# If input is Rels then?

# A pregroup presentation will be a structure that has
# Generators(pres) (elements of pregroup except 1)
# Pregroup(pres)   (the pregroup structure)
# Relations(pres)  (the set \mathcal{R})

# Determine whether the product of a and b is defined
# in their pregroup
ProductDefined := function(a,b)

end;

# Test whether the Pregroup elements a and b intermult, i.e.
# - a^(-1) <> b
# - either ProductDefined(a,b)
#   or there is x s.t. ProductDefined(a,x) and ProductDefined(x^(-1),b)
#
DoesIntermult := function(a,b)
    local x;

    if a = Sigma(b) then
        return false;
    elif a * b <> fail then
        return true;
    else
        for x in Pregroup(a) do
            if (a * x <> fail) and (x^(-1) * b <> fail) then
                return true;
            fi;
        od;
        return false;
    fi;
    # Should not be reached
    return fail;
end;

IsRLetter := function(pres, x)
    # determine whether x occurs in I(R)
end;


RepeatedList := function(list, n)
    local len, res, i;

    len := Length(list);
    res := EmptyPlist(len * int);

    for i in [1..n] do
        res{[(i-1) * len..(i*len)]} := list;
    od;

    return res;
end;

# MaxPowerK: Input a word (relator) v over X, output w such that w^k = v, k maximal with this property
# There might be a better way of doing this? Colva mentioned that it's in one
# of Derek's books?
MaxPowerK := function(rel)
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
end;

MaxPowerK2 := function(rel)
    local len, divs;

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
end;

Locations := function(rel)
    local res, r, w, k, i;

    res := [];

    r := MaxPowerK(rel);
    w := r[1];

    res := List([2..Length(w)], i -> [i, w[i-1], w[i]]);
    Add(res, [1, w[Length(w)], w[1]]);

    return res;
end;


# for the moment a location is triple [i,a,b]. This is of course redundant, since
# we know a and b from i and R.

# Given a pregroup presentation as the input, find all places
# at the moment make a simple presentation for pregroup
FindPlaces := function(pres)
    local loc, c, C, B,
          places, a, b,
          gens;

    gens := Generators(pres);

    places := [];

    for loc in Locations(rel) do
        a := loc[2];
        b := loc[3];
        for c in gens do
            #C = 'B'
            if DoesIntermult(b^(-1), c) then
                if IsRLetter(pres, c) then
                    Add(places, [loc,c,'B',false]);
                fi;
                Add(places, [loc, c, 'B', true] );
            fi;
            #C = 'G'
            # find location
            for rel2 in Relations(pres) do
                for loc2 in Locations(rel2) do
                    if loc2[2] = b^(-1) and loc2[3] = c then
                        if CheckReducedDiagram(rel, rel2) then
                            Add(places, [loc, c, 'G', q])
                        fi;
                    fi;
                od;
            od;
        od;
    od;

    return places;
end;

