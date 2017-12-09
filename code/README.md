# CODE

> * MATLAB

## Open questions for the implementation
(1) We put the standard derivation simga to one in our program. Is this sensible? Is it the same as in the paper? \
(2) Is there any difference between the setting (p_a, kappa_a) and (p_b, kappa_b) if p_a x kappa_a = p_b x kappa_b? \
--> I think there is no difference. So either we change the implementation or we have only two parameters more (p x kappa, infop) than the Laguna paper (mu, u) which is also fine for me. \
(3) Do we leave infop as it is? \
--> We can do that and look at the position of the new major cluster

## Reproducing the paper: (using the function without)
1) Show that mu defines the speed of convergence: Plot the histogram for different times (for example T = 10,100,1000,10000). Repeat this once with a small value for mu (for example mu = 0.1) and once with a big value for mu (for exmaple mu = 0.5) and compare the results. \
Figure 3 in the paper can give an orientation (for example N = 1089, u = 0.4)
2) Show that the threshold u influences cluster building (paper theory: when u > 0.3 there should be more than one major cluster, a major cluster is a cluster with more than 10%, a cluster is a part of the society with similar opinion.): Plot the histogram for different values of u (for example u=0.01,0.1,0.2,0.3,0.4,0.5) and fixed mu \
Figure 4 of the paper can give an orientation (for example: N = 10 000, T = 500, mu = 0.2)

## Inserting the extremists:
Fix u and mu such that we should see convergence (for example u = 0.35 and mu = 0.3) and plot the histogram for different for different values of (p x kappa) and infop. \
Question: Which values for (p x kappa) and infop are needed that we will have only extreme opinions (for T--> infinity)? \
Question: Does it influence the stability of the total averge of opinion? \
Question: How does the histogram or heat graph look like? What can we see? \
Question: What effects can we see if we change N? --> I am thinking about a bridge effect (biger N should build a bridge for convergence) \

If we are bored we can do this again for a lower threshold again (for example u = 0.45) and then vary other parameters and then other parameters etc.


## Presentation:
(1) Create some videos that describe the effects mentioned above \
(2) Create the heat garphs \
(3) Think about it
