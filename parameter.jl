#system model
A = [1 0.5;
    0.0 1
];

B = [0.5;
     1.0   ];

X = Hyperrectangle([50.0, 0.0], [50.0, 5.0]);
U = Hyperrectangle([0.0], [2.5]);
goal=[Hyperrectangle([10.0, 0.0], [10.0, 5.0]),Hyperrectangle([22.5, 0.0], [7.5, 5.0]),Hyperrectangle([45.0, 0.0], [15.0, 5.0]),Hyperrectangle([57.5, 0.0], [2.5, 5.0])]
X_goal12 = Hyperrectangle([65.0,0.0],[35.0,5.0]);
X_goal4r = Hyperrectangle([80.0,0.0],[20.0,5.0]);
tsteps = range(0, 50, length = 51)
begint = [1,1,41];
endt = [21,21,51];

# generate the trace by changing the inputs
z =[];push!(z,40.0);
vz =[];push!(vz,0.0);
u = [-1.2,-2.0,-2.2,-2.4,-1.2,-2.1,-2.3,-1.4,-1.2,0.2,3.0,2.0,0.3,0.1,0.0,0.1,1.2,1.0,1.2,1.0,-1.2,2.2,1.1,0.2,1.6,-1.2,-1.0,1.1,1.0,-1.6,-1.5,-1.0,-0.6,-2.1,1.2,1.2,0.1,1.2,0.1,2.1,1.4,2.1,0.3,0.1,1.2,2.2,-1.0,-2.2,1.0,0.0]
function get_states()
    for i in 1:50
        global temp_vz = vz[i] + B[2,1]*u[i]
        if temp_vz>=5
            temp_vz = 5;
        end
        if temp_vz<=-5
            temp_vz = -5;
        end
        push!(vz,temp_vz);
    end
    
    for i in 1:50
        global temp_z = z[i] +A[1,2]*vz[i]+ B[1,1]*u[i];
        push!(z,temp_z);
    end
end
get_states()
