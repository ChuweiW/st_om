# Self-triggered Online Monitoring
We propose a self-triggered online monitoring mechanism for signal temporal logic(STL) tasks. The paper titled "Sleep When Everything Looks Fine:
Self-Triggered Monitoring for Signal Temporal Logic Tasks" can be found in [paper link](https://arxiv.org/abs/2311.15531).

We provide two case studies to demonstrate the efficiency of our proposed algorithm: Drone altitude control and Spacecraft Rendezvous
All simulations were performed on a computer with an Intel Core i9-13900H CPU and 32 GB of RAM

## case1
### offline computation results
We first use the model information to pre-compute all possible I-remaining feasible sets that may incur for each time instant. The detailed computation method can be found in [link](https://github.com/Xinyi-Yu/MPM4STL). The backward feasible set results are contained in ```offline_set.jl```.

### real-time monitoring
You can generate your own trace by selecting different inputs in ```parameter.jl```. Then feed the trace to our self-triggered monitor in ```main.jl``` then you will get an observation history. You can check ```2trace.png``` to see our demonstration.

### Dependencies
In this project, we use the following package
```
IntervalArithmetic v0.20.9
LazySets v2.11.0
Polyhedra v0.7.6
Plots v1.39.0
LaTeXStrings v1.3.0
JLD v0.13.3
HDF5 v0.16.16
ReachabilityAnalysis v0.22.1
Symbolics v5.5.1
CDDLib v0.9.2
```


