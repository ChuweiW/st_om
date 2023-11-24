include("parameter.jl")
include("comp.jl")
function onestepset1(X, U, X_next)
    temp=[];
    X_next_tmp = X_next
    X_previous = convert(HPolytope, inv(A)*intersection(X, minkowski_sum(X_next_tmp, convert(Zonotope,B*U))));
    if X_previous.constraints != []
        push!(temp, intersection(X, X_previous));
    end
    results = UnionSetArray([temp[i] for i in 1: length(temp)]);
    return results
end

function onestepset(X, U, X_next::EmptySet)
    return LazySets.∅(2)
end

function onestepset(X, U, X_next)
    temp=[];
    for i = 1:length(X_next)
            X_next_tmp = convert(HPolytope, X_next[i])
            X_previous = convert(HPolytope, inv(A)*intersection(X, minkowski_sum(X_next_tmp, convert(Zonotope,B*U))));
            if X_previous.constraints != []
                push!(temp, intersection(X, X_previous));
            end
      end
    results = UnionSetArray([temp[i] for i in 1: length(temp)]);
    return results
end

#40-50
x = [];
tempset = [];
push!(x,UnionSetArray([convert(HPolytope,goal[4])]))
tempset = onestepset1(convert(HPolytope,goal[3]),U,convert(HPolytope,goal[4]))
tempset = UnionSetArray([convert(HPolytope,convex_hull(tempset[1],goal[4]))])
pushfirst!(x,tempset)
for i in 1:10
    global tempset=onestepset(convert(HPolytope,goal[3]),U,tempset)
    global tempset = UnionSetArray([convert(HPolytope,convex_hull(tempset[1],goal[4]))])
    pushfirst!(x,tempset)
end

#0-40
for i in 1:40
    global tempset=onestepset(convert(HPolytope,X),U,tempset)
    pushfirst!(x,tempset)
end

#0-10
x1=[];
push!(x1,UnionSetArray([convert(HPolytope,goal[1])]));
tempset1 = onestepset1(convert(HPolytope,X),U,convert(HPolytope,goal[1]));
tempset1 = UnionSetArray([convert(HPolytope,convex_hull(tempset1[1],goal[1]))]);
pushfirst!(x1,tempset1)
for i in 1:20
    global tempset1 = onestepset(convert(HPolytope,X),U,tempset1);
    global tempset1 = UnionSetArray([convert(HPolytope,convex_hull(tempset[1],goal[1]))]);
    pushfirst!(x1,tempset1);
end

x2=[];
push!(x2,UnionSetArray([convert(HPolytope,goal[2])]))
tempset2 = onestepset1(convert(HPolytope,X),U,convert(HPolytope,goal[2]))
tempset2 = UnionSetArray([convert(HPolytope,convex_hull(tempset2[1],goal[2]))])
pushfirst!(x2,tempset2)
for i in 1:20
    global tempset2 = onestepset(convert(HPolytope,X),U,tempset2)
    global tempset2 = UnionSetArray([convert(HPolytope,convex_hull(tempset2[1],goal[2]))])
    pushfirst!(x2,tempset2)
end


function feasible_set(t,i1,i2,i3)
    # t = 1~51
    X_fs = convert(HPolytope,X)
    if t <=endt[1]
        if i1 == 1
            X_fs = intersection(X_fs,x1[t][1])
        end
    end
    if t <=endt[2]
        if i2 == 1
            X_fs = intersection(X_fs,x2[t][1])
        end
    end
    if t <=endt[3]
        if i3 == 1
            X_fs = intersection(X_fs,x[t][1])
        end
    end
    return X_fs
end
