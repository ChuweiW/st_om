include("parameter.jl")
include("comp.jl")

# predicted belief state
function Fhat(as::augmented_state,t::Int)
    temp_as=[];
    if (as.I1 == 1)|| (as.I2==1)
        if as.I1==1 && as.I2==1
            if intersection(as.mathx,convert(HPolytope,intersection(goal[1],goal[2])))!= LazySets.∅(2)
                push!(temp_as,augmented_state(intersection(as.mathx,convert(HPolytope,intersection(goal[1],goal[2]))),0,0,1));
            end
            if intersection(as.mathx,goal[1]\goal[2])!= LazySets.∅(2)
                push!(temp_as,augmented_state(intersection(as.mathx,goal[1]\goal[2]),0,1,1));
            end
            if intersection(as.mathx,goal[2]\goal[1])!= LazySets.∅(2)
                push!(temp_as,augmented_state(intersection(as.mathx,goal[2]\goal[1]),1,0,1));
            end
            if intersection(as.mathx,X_goal12)!= LazySets.∅(2)
                push!(temp_as,augmented_state(intersection(as.mathx,X_goal12),1,1,1));
            end
        elseif as.I1== 0 && as.I2==1
            if intersection(as.mathx,goal[2])!= LazySets.∅(2)
                push!(temp_as,augmented_state(intersection(as.mathx,goal[2]),0,0,1));
            end
            if intersection(as.mathx,X\goal[2])!= LazySets.∅(2)
                push!(temp_as,augmented_state(intersection(as.mathx,X\goal[2]),0,1,1));
            end
        elseif as.I1== 1 && as.I2==0
            if intersection(as.mathx,goal[1])!= LazySets.∅(2)
                push!(temp_as,augmented_state(intersection(as.mathx,goal[1]),0,0,1));
            end
            if intersection(as.mathx,X\goal[1])!= LazySets.∅(2)
                push!(temp_as,augmented_state(intersection(as.mathx,X\goal[1]),1,0,1));
            end
        end
    end
    if (t<begint[3])&& (as.I1+as.I2==0)
        push!(temp_as,as);
    end
    if t>=begint[3]
        if (as.I3 == 1)
            if intersection(as.mathx,goal[4])!= LazySets.∅(2)
                push!(temp_as,augmented_state(intersection(as.mathx,goal[4]),0,0,0));
            end
            if intersection(as.mathx,goal[3]\goal[4])!= LazySets.∅(2)
                push!(temp_as,augmented_state(intersection(as.mathx,goal[3]\goal[4]),0,0,1));
            end
        else
            push!(temp_as,as);
        end
    end
    return temp_as;
end

# Trigger-time
function determine_k(t,I1,I2,I3)
    step = 1; k = 1; unsafeflag = false;
    Forward_set = forwardset1(z[t],vz[t]);
    fs = feasible_set(t+1,I1,I2,I3)
    Augset = []; 
    for i in 1:length(Fhat(augmented_state(Forward_set,I1,I2,I3),t+1))
        push!(Augset,Fhat(augmented_state(Forward_set,I1,I2,I3),t+1)[i]); # t+1
    end
    if issubset(Forward_set,fs)==false
        return 1,I1,I2,I3;
    end
    while(step<10)
        if length(get_Ia(Augset))==0
            k = step;
            I1 = Augset[1].I1;
            I2 = Augset[1].I2;
            I3 = Augset[1].I3;
        end
        Augset_temp = [];
        while(length(Augset)>0)
            Augstate = pop!(Augset)
            if (forwardset(Augstate.mathx) ⊆ feasible_set(t+step+1,Augstate.I1,Augstate.I2,Augstate.I3))==false
                unsafeflag = true;
                break;
            end
            for i in 1:length(Fhat(augmented_state(forwardset(Augstate.mathx),Augstate.I1,Augstate.I2,Augstate.I3),t+step+1))
                push!(Augset_temp,Fhat(augmented_state(forwardset(Augstate.mathx),Augstate.I1,Augstate.I2,Augstate.I3),t+step+1)[i]);
            end
        end
        if unsafeflag == true
            break;
        end
        Augset = Augset_temp;
        step += 1;
    end
    return k+1,I1,I2,I3;
end
