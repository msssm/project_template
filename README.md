# MATLAB Fall 2016 – Research Plan

> * Group Name: (be creative!)
> * Group participants names: Thierry Backes, Sichen Li, Peng Zhou
> * Project Title: Analysing network resilience of interdependent power grids

## General Introduction
(States your motivation clearly: why is it important / interesting to solve this problem?)

With the trend of libralization of energy market, the integration of energy systems become a more and more important topic. Understanding the resilience of interdependent power grids is thus needed for designing the construction. 

We are going to generate and analynize the cascading failure and its solution for abstract interdependent networks, and use the empirical data of historical blackout for implementing our methods. We would also use the SFINA package as reference to simulate the result for real power grids.

(Add real-world examples, if any)(Put the problem into a historical context, from what does it originate? Are there already some proposed solutions?)
In reference [2], the authors study two fully interconnected subnetworks. By shutting down nodes as few as possible, they try to maximize the "autonomous" (i.e., independent on the other subnetwork) nodes to decrease the degree of coupling. The resilience of real coupled power grids in Italy is significantly improved by applying their strategy.

## The Model
(Define dependent and independent variables you want to study. Say how you want to measure them.)
We refer our project to a network-based model which basically abstract the power grid as a scale free network where the nodes are generators, transformers, and substations and the links are power transmission lines. We generate different methods to shut down nodes and thus the connected lines to represent failures of the power grid (i.e., blackout), and study the subsequent cascading failure afterwards.

(Why is your model a good abtraction of the problem you want to study?) 
A scale free network is a network inside which most nodes only have very few connections, but there are several critical nodes which connect to a large number of nodes. The power grid resembles this type of network a lot since there are distinguished energy hubs and rural areas.

(Are you capturing all the relevant aspects of the problem?)
## Fundamental Questions

(At the end of the project you want to find the answer to these questions)
(Formulate a few, clear questions. Articulate them in sub-questions, from the more general to the more specific. )

1. How to understand the robustness of our current infrastructure network.
2. What causes the cascading failure of power grids. 
3. How can we improve the stabilitity and functionality of power grids under partial failure. 


## Expected Results

(What are the answers to the above questions that you expect to find before starting your research?)


## References 

(Add the bibliographic references you intend to use)
(Explain possible extension to the above models)
(Code / Projects Reports of the previous year)

[1] Albert, Réka, Hawoong Jeong, and Albert-László Barabási. "Error and attack tolerance of complex networks." nature 406.6794 (2000): 378-382.

[2] Schneider, Christian M., et al. "Towards designing robust coupled networks." Scientific reports 3 (2013).

[3] Schneider, Christian M., et al. "Mitigation of malicious attacks on networks." Proceedings of the National Academy of Sciences 108.10 (2011): 3838-3841.

[4] Brummitt, Charles D., Raissa M. D’Souza, and E. A. Leicht. "Suppressing cascades of load in interdependent networks." Proceedings of the National Academy of Sciences 109.12 (2012): E680-E689.


## Research Methods

(Cellular Automata, Agent-Based Model, Continuous Modeling...) (If you are not sure here: 1. Consult your colleagues, 2. ask the teachers, 3. remember that you can change it afterwards)


## Other

(mention datasets you are going to use)
