# MATLAB HS12 – Research Plan

> * Group Name: (be creative!)
> * Group participants names: Fabian Russmann, Stefan Rustler
> * Project Title: (can be changed)

## General Introduction

(States your motivation clearly: why is it important / interesting to solve this problem?)
(Add real-world examples, if any)
(Put the problem into a historical context, from what does it originate? Are there already some proposed solutions?)

We want to study the mechanisms of opinion formation in a network of people. In addition, we also allow the network itself to be adaptable to the opinions existing on it, making two interdependent forces of network evolution and opinion formation measurable.

The motivation for this project involves two different angles on very fundamental dynamics of our society. First of all, we would like to understand the ways in which humans become who they are under the influence of their environment. How do people form their opinions, values, and beliefs and how do their friends and acquaintances play a role in this? Secondly, we are interested in the way our networks of friends and social ties form in the first place. How and why do we choose to be friends with certain people and not with others? How do networks of people in a society form? 

From an intuitive point of view (considering that we are all social beings) most people would argue that the two aspects are interdependent or even that they are two extremes of the same process: Our social environment certainly shapes what we believe and which opinions we hold, while in turn our own values and opinions influence whom we choose to connect with and make part of our social network. On the basis of this rather vague but plausible assumption, our project is an attempt to disentangle and study the effects of these two mechanisms by the means of an abstract, quantitative model. 

An example of a system that one would expect to be subject to such behavior and that we would like to put a focus on is religious affiliation within a society. It could be argued that the social surroundings have an effect on (or, as an extreme, completely determine) which religion a person chooses to belong to. Also, one's religion also influences to whom we connect with socially, for example through the community in a church (the opposing extreme would be that a person's social ties are entirely composed of member's of the same religion). 


-history of this. older papers on this? what has already been done in the field? (just briefly)


## The Model

(Define dependent and independent variables you want to study. Say how you want to measure them.) (Why is your model a good abtraction of the problem you want to study?) (Are you capturing all the relevant aspects of the problem?)


## Fundamental Questions

1) Does the social network shape peoples's opinions or do opinions shape the structure of the network?

2) How can we classify opinion and network structures based on these competing tendencies?

2.1) Specific example: How does the distribution of religious affiliation and size of religious groups change in dependence of the "mixture" of these competing forces?

2.1.1) Optional (if data and time available): Do the modeled results fit real distributions of religions in specific countries? Based on this, can we make inferences about the mechanisms of opinion and network formation in different countries?



(At the end of the project you want to find the answer to these questions)
(Formulate a few, clear questions. Articulate them in sub-questions, from the more general to the more specific. )


## Expected Results

For all cases and from a purely abstract, theoretical consideration, the model can clearly be expected to converge to a non-changing state in which all actors are only connected to other actors holding the same opinion.

The proposed model is of course not constructed from scratch, but based on the one described in [1]. In said publication, the authors describe a critical behavior of the group size and group distribution that is analogous to a 2nd order phase transition known from physics: As the probability $\Phi$ (describing a continuous "mixing ratio" of the two processes of network and opinion formation) is varied, the clusters of opinions develop into two distinct types ("phases"). Above a critical value of $\Phi$, the number and size of groups is more or less randomly distributed. Below a critical value, the behavior is radically different and one large group dominates over a few small groups. Several other properties of criticality are shown and analyzed, e.g. the identification of an order parameter, power law behavior at the critical point, scalability in the transition region etc. For our model, we would expect to be able to reproduce this behavior. 

Concerning the comparison with real data on religious affiliation, it is much harder to predict answers to our questions. If we find suitable data at all, it is questionable if this data is meaningful and significant enough to make any comparisons at all. If however, distributions of religious affiliations are similar, this could serve as support for the validity of our model or even allow us to make inferences about possibly dominant processes of religion formation in certain countries. For example if one religion dominates in a country, could this mean that people tend to rather adopt the religion "dictated" by their surroundings instead of reconnecting with other members of a minority religion? 


(What are the answers to the above questions that you expect to find before starting your research?)


## References 

[1] Holme, Petter; Newman, M. E. J. Nonequilibrium phase transition in the coevolution of networks and opinions. Physical Review E, vol. 74, Issue 5, id. 056108, 11/2006

[2] D. H. Zanette and S. C. Manrubia. Vertical transmission of culture and the distribution of family names. Physica A, 295:1–8, 2001

[3] www.adherents.com

(Add the bibliographic references you intend to use)
(Explain possible extension to the above models)
(Code / Projects Reports of the previous year)


## Research Methods

-some gen. comments on our model (graphs, iterative rules etc)…. 


For the optional comparison with empirical data, we would, depending on what the data looks like, intend to use common methods of statistical analysis, e.g. OLS regression, fitting functions on linear and/or logarithmic scales and comparing the values of their coefficients with the fitted distribution functions obtained by our simulations.


(Cellular Automata, Agent-Based Model, Continuous Modeling...) (If you are not sure here: 1. Consult your colleagues, 2. ask the teachers, 3. remember that you can change it afterwards)


## Other

A possible source for data on religion aggregated by country/geographical location could be [3]. However, it will have to be evaluated in the process of the work if this data is extensive and reliable enough to be useful. If there are other data sources on religion, any input is very welcome.

(mention datasets you are going to use)
