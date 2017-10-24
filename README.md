# MATLAB Fall 2017 – Research Plan

> * Group Name: The Opinionators
> * Group participants names: Alexander Stein, Niklas Tidbury, Elisa Wall
> * Project Title: Opinion Formation: Impacts of convincing extreme individuals onto a society that typically converges to one opinion

## TO DO
- rethink questions
- concrete goal
- discuss implementation of kappa and p

## General Introduction

For millennia, society has consisted of many opinions and points of view. In some cases, these opinions have been oppressed, other opinions have been forced onto societies, others brainwashed.
Within a democracy, these opinions are given space to spread, to change and to evolve and yet: they still converge into a general opinion. How is this possible in cases of extremism, where extreme opinions are so different compared to the majority? What effect do extreme opinions, such as that of the IS, Charles Manson and co. have on a converging opinion of a society?
We would like to examine how extreme opinions of individuals impacts such a society, and under what circumstances these opinions can have a wide-spread effect.


## The Model

We want to base our work on an agent-based model, the agents being single beings with an opinion of an interval **[0,1]**. In addition, each agent possesses a parameter **µ**, which is the weight the agent gives to foreign opinions. Agents of the society will interact with each other, "exchanging" their opinions and deciding on common ground. This "common ground" both agents share is defined if within the interval **u**: if their opinions are similar enough (within **u**), they will converge and become the same. If not, extreme differences will stay as-is. The final level of abstraction is added with the probability of convincing another individual of their own opinion is defined by **κ**, as some individuals possess higher levels of charisma and are more able to manipulate the crowd than others.
Using this model we should be able to successfully simulate the key points in an abstract way: the weight of foreign opinions, the similarities of two opinions and the probability of convincing others.


## Fundamental Questions

1) What are the outcomes of **n** convincing individuals of extreme opinions in a society that converges to one opinion?
- Do we see fragmentation or polarisation of opinions?

2) What effects do these extreme opinions have in a society of low **u** [narrow communicating interval] and **µ** [weight of foreign opinions]?

3) What happens when we vary the random distribution?


## Expected Results

1) Polarisation of opinions and faster fragmentation due to the higher difference in **u**

2) We expect to see clustering of general opinions before the extreme opinions take any effect (no disturbance).

3) Difference in clustering patterns and speeds


## References

[1] P. Holme and M. E. J. Newman. Nonequilibrium phase transition in the coevolution of networks and opinions.

[2] M. F. Laguna, G. Abramson and D. H. Zanette. Minorities in a Model for Opinion Formation.

[3] github: frussmann/opinion_formation_in_networks


## Research Methods

Based on the papers of Holme and Laguna, we want to create a society of **N** agents, who have random, gaussian-distributed opinions **x** in [0, 1].

As written in the given papers, there will be a common opinion around 0.5 if:
- the opinion interval **u** of agents communicating with each other is big enough
- the weight **µ** of foreign opinions is high enough

As seen in the given papers, we assume the following rule for the change of opinions:
- if abs(x'(t) - x(t)) < u:
  - x(t + 1) = x(t) + µ(x'(t) - x(t))
  - x'(t + 1) = x'(t) + µ(x(t) - x'(t))

The procedure can be interpreted as follows:
At each time step **t** two randomly chosen agents meet. By building a threshold **u** into the structure, the agents only interact with similar-thinking agents, as people generally interact with the like-minded. If the difference in their opinion is within the communicating interval **u**, the agents with the opinions **x** and **x'** adapt their opinion by the weight **µ**, which characterises the convergence of the opinions.
Using this model, close opinions come even closer and opinions further away from other opinions do not change. "Close" and "far-away" are characterised in **u**.
If we take reasonable values for **u** and **µ**, this typically follows to a convergence of a unique opinion around x = 0.5.

Within this situation we add n extreme individuals in the beginning with a non-changing opinion in the outer parts of the Gaussian curve. We assume that the agents are charismatic and have good rhetorics in order to convince **p** other agents by a probability of success of **κ** (Kappa). This can be interpreted as the influence of certain individuals can be higher, such as social media stars or politicians with extreme opinions.


## Other
