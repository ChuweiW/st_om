struct augmented_state
    mathx
    I1
    I2
    I3
end

function forwardset1(z1,z2)
    z1_= A[1,1]*z1+ A[1,2]*z2
    z2_= A[2,2]*z2
    z_now = [z1_,z2_]
    # first forward reach set
    radius_hyperrectangle(U)
    Z = Hyperrectangle(z_now,[B[1,1]*radius_hyperrectangle(U)[1],B[2,1]*radius_hyperrectangle(U)[1]])
    Z = intersection(Z,X)
    Z = convert(HPolytope,Z)
    plot!(Z,color=:blue2)
    return Z
end
function forwardset(Z)
    Z2 = minkowski_sum(A*Z,convert(HPolytope,B*U))
    Z2 = intersection(Z2,convert(HPolytope,X))
    plot!(Z2)
    return Z2
end


function get_Ia(augset)
    Ia =[];
    i1 = false;i2 = false;
    i3 = false;i4 = false;
    i5 = false;
    for i in 1:length(augset)
        numI = augset[i].I1*100 +augset[i].I2*10+augset[i].I3
        if numI == 111
            i1 = true;
        elseif numI == 101
            i2 = true;
        elseif numI == 11
            i3 = true;
        elseif numI == 1
            i4 = true;
        else 
            i5 = true;
        end
    end
    if ((i1||i2)==true) && ((i3||i4) == true)
        push!(Ia,1)
    end
    if ((i1||i3)==true) && ((i2||i4) == true)
        push!(Ia,2)
    end
    if (i4&&i5)
        push!(Ia,3)
    end

    return Ia
end
