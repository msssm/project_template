# MATLAB Fall 2015 – Research Plan 

> * Group Name: destructive
> * Group participants names: Deichmann Marion; Kaiser Laurenz; Schäfer Timo
> * Project Title: Modelling Contagion in a Core-Periphery Financial Network

## General Introduction

\noindent Especially after the collapse of Lehman in 2008 researchers and policy
makers have shifted their focus towards the interconnectedness of
financial intermediaries regarding interbank lending. It has been shown that the default of a bank
can trigger other banks' failure via the network structure [source!]. Since then global discussions regarding
capital requirements and banking regulations have emerged, i.e. Basel III, Volcker Rule, Liikanen
report, UK Whitebook. All these measures aim to decrease the
probability of default of banks and hence, to reduce contagion
w.r.t. financial distress.


## Fundamental Questions
In our seminar paper, we aim to determine how regulatory policies
on banks can lower contagion risks. First, we examine the impact of
increased capital buffers. Second, we simulate whether bail-out
strategies can impede contagion, i.e. randomly choosing which bank to
save or more specifically, target the most central bank. Furthermore,
it would be interesting to conduct a counterfactual analysis comparing
saving or not saving banks.
(At the end of the project you want to find the answer to these questions)
(Formulate a few, clear questions. Articulate them in sub-questions, from the more general to the more specific. )


## Model and Research Methods

Our analysis is based on a random graph exhibiting stylized facts of the
actual European financial network. For this purpose, we will use a
\cite{Erdos1959} random graph model with core-periphery
structure. \cite{Georg2014} finds that the joint European interbank market
can best described as a network of connected core-periphery networks
since the latter can be found on a national bank level. 

Let us assume that the total assets of each bank $i$ consist of
interbank assets, $A_i^{IB}$, and illiquid external assets
(i.e. mortgages), $A_i^M$. Further, the total interbank assets are
equally distributed across all incoming links. Bank $i$'s total
liabilities consist of interbank liabilities, $L_i^{IB}$, that are
endogenously determined and of exogenous customer deposits,
$D_i$. Using these notations, one can define the necessary condition
for bank $i$ to be solvent \citep{Gai2010}:
\begin{equation}
(1-\alpha)A_i^{IB}+qA_i^M-L_i^{IB}-D_i>0
\end{equation} 
with $\alpha$ being the fraction of bank $i$'s counterparties with
obligations to $i$ that have defaulted assuming a recovery rate of
zero, and $q$ is the resale price of the illiquid asset that is <1 in
the case of 'fire sales'. By defining
$K_i=A_i^{IB}+A_i^M-L_i^{IB}-D_i$ as bank's $i$ capital buffer, we can
examine effects of particular levels of capital buffers on the spread
of contagion.
First, we build random graph model as described above. Second, we run
a Monte Carlo simulation on the random variables $A_i^{IB}$ and
$A_i^{M}$ respectively to get the numerical results. By construction, the means for the random
variables for core and periphery banks differ significantly. Third,
using this methodology we hope to be able to infer policy implications.


## Expected Results
We expect that for increased capital buffers the frequency of
contagion is more significantly reduced for core banks relative to
periphery banks. Similarly, we expect that saving a core bank reduces the extent of contagion more effectively than saving a periphery bank.  


## References

