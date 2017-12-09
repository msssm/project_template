# CODE

> * MATLAB

## Open questions:
(1) We put the standard derivation simga to one in our program. Is this sensible? Is it the same as in the paper? \
(2) Is there any difference between the setting (p_a, kappa_a) and (p_b, kappa_b) if p_a x kappa_a = p_b x kappa_b? \
--> I think there is no difference. So either we change the implementation or we have only two parameters more (p x kappa, infop) than the Laguna paper (mu, u) which is also fine for me. \
(3) Do we leave infop as it is? \
--> I think

## Next goal:
(1) Extent the programm \
(2) Reproduce the paper and start writing the report how we did this. \
(3) Answer question 1 by extending the program \

## To-Do:
(2) Implement an iteration of the function from (1), say k times and averge the content of the output-vector. \
--> This will give us the final plots with which we can reproduce the paper (neff0=neff1=0 so that kappa does not matter) \
(3) Using N, T, u, mu as given in the paper. \
3.1 At which values of neff0, kappa0 (which should be euqal to neff1, neff1 for the beginning) can we recognize differences to the expected result without extremists as in the paper? \
3.2 For which values of neff0, kappa0 does all agents end up in opinion 0 and 1? \
### Comment: It is possible to say that the extremists gonna attack only once but with a larger neff and p

## Goals afterwards:
(1) Answer question 1 \
(1) Implement nice visualizations \
(2) Answer question 2 (optional) \
(3) Answer question 3 (optional) \
(4) Eliminate the bugs
