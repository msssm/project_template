# CODE

> * MATLAB

## Next goal:
(1) Extent the programm \
(2) Reproduce the paper and start writing the report how we did this. \
(3) Answer question 1 by extending the program \

## To-Do:
(1) Write a function with input: [N, T, u, mu,neff0, neff1, kappa0, kappa1] and outputs the a vector that length is the the number of bins and contains the number of agents to the coressesponding bin. \
### Comment: We put the standard derivation simga to one in our program. Please figure out if this is sensible and the same as in the paper. \

(2) Implement an iteration of the function from (1), say k times and averge the content of the output-vector. \
--> This will give us the final plots with which we can reproduce the paper (neff0=neff1=0 so that kappa does not matter) \
(3) Using N, T, u, mu as given in the paper. \
3.1 At which values of neff0, kappa0 (which should be euqal to neff1, neff1 for the beginning) can we recognize differences to the expected result without extremists as in the paper? \
3.2 For which values of neff0, kappa0 does all agents end up in opinion 0 and 1? \
### Comment: It is possible to say that the extremists gonna attack only once but with a larger neff and p
### We have to think about the ranging of p again. Are the 0 extremists only allowed to attack agents with opinion between [0;0.4] or general [0,1]? This parameter can be included into the input of the function in (1)

## Goals afterwards:
(1) Answer question 1 \
(1) Implement nice visualizations \
(2) Answer question 2 (optional) \
(3) Answer question 3 (optional) \
(4) Eliminate the bugs
