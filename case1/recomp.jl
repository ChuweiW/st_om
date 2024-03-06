include("parameter.jl")
include("forward.jl")

# predicted belief state
function Fhat(as::augmented_state,t::Int)
    temp_as=[];
    if t<=endt[1]
        if (as.I1 == 1)
            if intersection(as.mathx,goal[1])!= LazySets.∅(2)
                push!(temp_as,augmented_state(intersection(as.mathx,goal[1]),0,1));
            end
            if intersection(as.mathx,goal2l1)!= LazySets.∅(2)
                push!(temp_as,augmented_state(intersection(as.mathx,goal2l1),1,1));
            end
            if intersection(as.mathx,goal2r1)!= LazySets.∅(2)
                push!(temp_as,augmented_state(intersection(as.mathx,goal2r1),1,1));
            end
        else
            push!(temp_as,as);
        end
    end
    if (t<begint[2])&& (t>endt[1])
        push!(temp_as,as);
    end
    if t>=begint[2]
        if (as.I3 == 1)
            if intersection(as.mathx,goal[4])!= LazySets.∅(2)
                push!(temp_as,augmented_state(intersection(as.mathx,goal[4]),0,0));
            end
            if intersection(as.mathx,goal[3]\goal[4])!= LazySets.∅(2)
                push!(temp_as,augmented_state(intersection(as.mathx,goal[3]\goal[4]),0,1));
            end
        else
            push!(temp_as,as);
        end
    end
    return temp_as;
end

function safecheck(Augset, fs)
    for i in 1:length(Augset)
        if issubset(Augset[i].mathx,fs)==false
            return false
        else 
            return true
        end
    end
end

function determinecheck(augset)
    for i in 1:length(augset)-1
        for j in i+1:length(augset)
            intersect= intersection(augset[i].mathx, augset[j].mathx)
            if intersect != LazySets.∅(2) 
                if issubset(intersect,Border[1]) || issubset(intersect,Border[2])
                    continue
                end
                if (augset[i].I1 != augset[j].I1) || (augset[i].I3 != augset[j].I3)
                    return false
                end
            end
        end
    end
    return true
end
