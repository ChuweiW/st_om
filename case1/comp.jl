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
