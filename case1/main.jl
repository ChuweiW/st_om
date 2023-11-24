using IntervalArithmetic
using LazySets
using Plots
using Polyhedra, CDDLib
using LaTeXStrings
using JLD, HDF5
include("parameter.jl")
include("forward.jl")
include("draw.jl")
include("offline_set.jl")
include("recomp.jl")

I1 = 1;
I2 = 1;
I3 = 1;
t = 1;
observe_p = [];
push!(observe_p,0)
while t<endt[3]
    x_state = [z[t],vz[t]];
    fs = feasible_set(t,I1,I2,I3);
    if (x_state ∈ fs) == false
        println("violated");
        break;
    end
    #update Ix
    if x_state ∈ goal[1]
        global I1 = 0;
    end
    if x_state ∈ goal[2]
        global I2 = 0;
    end
    if (x_state ∈ intersection(goal[3],goal[4]))&& t>=begint[3]
        global I3 = 0;
    end
    k,I1,I2,I3 =  determine_k(t,I1,I2,I3);
    if (I1+I1+I3)==0
        println("solved");
        k = 0;
        break;
    end
    push!(observe_p,t+k-1);
    global t = t+k;
end
