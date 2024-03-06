struct augmented_state
    mathx
    I1
    I3
end

function forwardset1(z1,z2,input)
    z1_= A[1,1]*z1 + A[1,2]*z2 + B[1,1]*input
    z2_= A[2,2]*z2 + B[2,1]*input 
    z_now = [z1_,z2_]
    # first forward reach set
    radius_hyperrectangle(W)
    Z = Hyperrectangle(z_now,[radius_hyperrectangle(WW)[1],radius_hyperrectangle(WW)[1]])
    Z = intersection(Z,X)
    Z = convert(HPolytope,Z)
    return Z
end
function forwardset(Z,input)
    uvec = [B[1,1]*input, B[2,1]*input]
    Z2 = Translation(A*Z, uvec)
    Z2 = minkowski_sum(Z2,W)
    Z2 = intersection(Z2,convert(HPolytope,X))
    return Z2
end


function generate_newbelief(Augset,input,t)
    Augset_temp = [];
    unsafeflag = false;
    while(length(Augset)>0)
        Augstate = pop!(Augset)
        if forwardset(Augstate.mathx, input) ⊆ feasible_set(t, Augstate.I1, Augstate.I3)==false
            unsafeflag = true;
            break;
        end
        for i in 1:length(Fhat(augmented_state(forwardset(Augstate.mathx,input),Augstate.I1, Augstate.I3),t))
            push!(Augset_temp,Fhat(augmented_state(forwardset(Augstate.mathx,input),Augstate.I1, Augstate.I3),t)[i]);
        end
    end
    if unsafeflag == true
        return false
    else 
        return Augset_temp
    end
    
end
