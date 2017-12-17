# CODE

> * MATLAB

## Reproducing the paper: (using the function without)
1) Show that mu defines the speed of convergence: Plot the histogram for different times (for example T = 10,100,1000,10000). Repeat this once with a small value for mu (for example mu = 0.1) and once with a big value for mu (for exmaple mu = 0.5) and compare the results. \
Figure 3 in the paper can give an orientation (for example N = 1089, u = 0.4)
2) Show that the threshold u influences cluster building (paper theory: when u > 0.3 there should be more than one major cluster, a major cluster is a cluster with more than 10%, a cluster is a part of the society with similar opinion.): Plot the histogram for different values of u (for example u=0.01,0.1,0.2,0.3,0.4,0.5) and fixed mu \
Figure 4 of the paper can give an orientation (for example: N = 10 000, T = 500, mu = 0.2)

## Research:
(1) Mu becomes a new role: Before (in a world without extremists) it was a measure for the speed of convergence. So if we choose small mu and big T we came to the same result of convergence. (see Chapter 4.1) 
When trying different values of mu and T in the world with extremists one finds that it has an influence of convergence!
This can be explained as followed: If the natural convergence is slow (which corresponds to small mu) we need more time steps for a stationary state. But the extremists influence is independent of mu. So if the natural influence.
Plot with small mu (resp big T) and big mu (resp small T) to show that effect. The extremists should be strong (means infop for example around 0.4 and big value for n_eff*kappa)


(2) Vary the first parameter of the extremists infop:
Vary the infop interval size from 0 to 0.5 symmetrically
Plot The histogram for with and wihtout for T→ infinity
Questions:  For which T do we have a stable state? When do we lose the convergence around 0.5? - I think the convergence is highly dependent on the infop factor! (similar to u since infop is kind of u for the extremists...)

(3) Vary the second parameter of the extremists (n_eff*kappa)
Measuring the percentage on the corner: 
Fix mu = 0.1 and u = 0.32 → Without extremists we would see a typical convergence to 0.5.
Looking for clusters on the corners
Fix n = 1, kappa = 0.2 and vary p from 0 to P such that for P 100% are in the corners (a resonable value should be given by the research question before, for example [0.4 and 0.6] or even closer to 0.5, but if possible it should be smaller than 0.5, otherwise every stable state ends in 100% extremists what is not really interesting.)
Plots
→ Time plots of the percentage on the corners
→ Plot the final (stable) percentage over p
Questions: At which time step do we see stable state? When do we see 100% extremists? What is the dependence of the corner percentage to n_eff*kappa?

(4) Stability of the average opinion: Without extremists the opinion is always around 0.5 with a small deviation. Inserting the extremists this fact changes: We see a way bigger deviation.
Plot: For T→infinity (means a stable state) and iteration over with and without calculate for each iteration the average and plot all of them in a “average_with” and a “average_without” histogram.
Question: For T→infinity and iteration of with and without: What are the averages of the opinion with and without the extremists?



## Presentation:
(1) Create some histogram videos \
(2) DOes the heat graphs make sense hear? 
