# MATLAB HS12 – Research Plan

> * Group Name: Social State Physicists
> * Group participants names: Fabian Russmann, Stefan Rustler
> * Project Title: Dynamics of Religious Views in Networks

## General Introduction


We want to study the mechanisms of opinion formation in a network of people. In addition, we also allow the network itself to be adaptable to the opinions existing on it, making two interdependent forces of network evolution and opinion formation measurable.

The motivation for this project involves two different angles on very fundamental dynamics of our society. First of all, we would like to understand the ways in which humans become who they are under the influence of their environment. How do people form their opinions, values, and beliefs and how do their friends and acquaintances play a role in this? Secondly, we are interested in the way our networks of friends and social ties form in the first place. How and why do we choose to be friends with certain people and not with others? How do networks of people in a society form? 

From an intuitive point of view (considering that we are all social beings) most people would argue that the two aspects are interdependent or even that they are two extremes of the same process: Our social environment certainly shapes what we believe and which opinions we hold, while in turn our own values and opinions influence whom we choose to connect with and make part of our social network. On the basis of this rather vague but plausible assumption, our project is an attempt to disentangle and study the effects of these two mechanisms by the means of an abstract, quantitative model. 

An example of a system that one would expect to be subject to such behavior and that we would like to put a focus on is religious affiliation within a society. It could be argued that the social surroundings have an effect on (or, as an extreme, completely determine) which religion a person chooses to belong to. Also, one's religion also influences to whom we connect with socially, for example through the community in a church (the opposing extreme would be that a person's social ties are entirely composed of member's of the same religion). 



## The Model


In this work the social network of people will be modeled by means of a graph with vertices and edges (see section "Research Methods"). In two basic update steps, we will enable each vertex, i.e. person, to follow one of the two mechanisms, re-connecting to like-minded individuals or adapting his/her opinion to the neighborhood. A tunable probability F of choosing either one of them will be included in the model. After a finite number of time-steps a convergent or equilibrium state is aspired, in which we can check for several dependent variables, like cluster formation or convergence speed. In this work we will be mainly concerned with how this convergent state looks like in terms of opinion size distribution. Intuitively, one can picture two extreme scenarios: one in which there is one prominent opinion, and one in which there is no such opinion but several much less prominent ones. Our model reduces opinion dynamics to two basic mechanisms mentioned above. Nevertheless, it should be well possible to elucidate how these microscopic tendencies will result in different macroscopic phenomena.

As an optional task one can compare the results, i.e. the opinion size distribution, with actual data on opinions of a certain aspect, e.g. religious view. One could then think about by what factors our F is influenced in reality.


## Fundamental Questions

1) Does the social network shape people's opinions or do opinions shape the structure of the network?

2) How can we classify opinion and network structures based on these competing tendencies?

2.1) Specific example: How does the distribution of religious affiliation and size of religious groups change in dependence of the "mixture" of these competing forces?

2.1.1) Optional (if data and time available): Do the modeled results fit real distributions of religions in specific countries? Based on this, can we make inferences about the mechanisms of opinion and network formation in different countries?



## Expected Results

For all cases and from a purely abstract, theoretical consideration, the model can clearly be expected to converge to a non-changing state (consensus state) in which all actors are only connected to other actors holding the same opinion.

The proposed model is of course not constructed from scratch, but based on the one described in [1]. In said publication, the authors describe a critical behavior of the group size and group distribution that is analogous to a 2nd order phase transition known from physics: As the probability F (describing a continuous "mixing ratio" of the two processes of network and opinion formation) is varied, the clusters of opinions develop into two distinct types ("phases"). Above a critical value of F, the number and size of groups is more or less randomly distributed. Below a critical value, the behavior is radically different and one large group dominates over a few small groups. Several other properties of criticality are shown and analyzed, e.g. the identification of an order parameter, power law behavior at the critical point, scalability in the transition region etc. For our model, we would expect to be able to reproduce this behavior. 

Concerning the comparison with real data on religious affiliation, it is much harder to make predictions regarding our questions. If we find suitable data at all, it is questionable if this data is meaningful and significant enough to make any comparisons at all. If however, distributions of religious affiliations are similar to modeled ones, this could serve as support for the validity of our model or even allow us to make inferences about possibly dominant processes of religion formation in certain countries. If for example one religion dominates in a country, could this mean that people tend to rather adopt the religion "dictated" by their surroundings instead of reconnecting with other members of a minority religion? 




## References 

[1] Holme, Petter; Newman, M. E. J. Nonequilibrium phase transition in the coevolution of networks and opinions. Physical Review E, vol. 74, Issue 5, id. 056108, 11/2006

[2] D. H. Zanette and S. C. Manrubia. Vertical transmission of culture and the distribution of family names. Physica A, 295:1–8, 2001

[3] www.adherents.com



## Research Methods

The model will represent the network of people by a graph with N vertices and M edges connecting vertices. Thus "graph" in this context is a collection of edges and vertices and not to be confused with graphs of functions. Each vertex represents a single person indexed by i, to whom a certain opinion g_i, e.g. a religious view, is assigned. The number of all possible opinions G is only limited by the number of people existing in the network, i.e. N, to a certain factor gamma = N/G, where gamma > 1. In this sense, it is not possible for every single individual to hold a unique opinion. The edges represent a social connection between two individuals, the number of edges leaving the vertex the degree k_i.
The initial structure of the network will be random and uniform under the external constraints, N, M and gamma, whereby self-edges and multi-edges will be allowed. The dynamics of the network are then simulated by applying the following at each time step:

1. Pick a random vertex i with opinion g_i. 
2. If k_i=0, do nothing. 
3. Otherwise, with probability F randomly select one of the edges of i and connect it to another vertex randomly chosen, having the same opinion g_j.
4. Otherwise, with probability 1-F randomly select one of the neighboring vertices j and change g_i to g_j

Here the third step corresponds to the mechanism in the network of an individual reconnecting to like-minded individuals, whereas the fourth step to that of an individual adapting his/her opinion to his/her neighborhood. 

This is iteratively done until a convergent state is achieved, which is then used for further investigation of the quantities mentioned in the section "The  Model."

For the optional comparison with empirical data, we would, depending on what the data looks like, intend to use common methods of statistical analysis, e.g. OLS regression, fitting functions on linear and/or logarithmic scales and comparing the values of their coefficients with the fitted distribution functions obtained by our simulations.




## Other

A possible source for data on religion aggregated by country/geographical location could be [3]. However, it will have to be evaluated in the process of the work if this data is extensive and reliable enough to be useful. If there are other data sources on religion, any input is very welcome.

