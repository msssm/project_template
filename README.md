# MATLAB Spring 2014 – Research Plan

> * Group Name: Les Trois Mousquetaires
> * Group participants names: Ledieu Elise, Munich Emmanuel, Wirz François
> * Project Title: Social contagion of smoking

## General Introduction

Obesity is a major health concern in the US causing annual mortality around 300'000 death per year (1). According to World Health Organization, diet and physical exercise are possible remedies to this social health problem. We would like to find out to which extent obesity spreads through social networks. An answer to this question could help to design adequate public health policies and decide if obesity has to be tackled as a clinical issue (i.e. on an individual basis) or as a public health intervention which could better exploit the network phenomena to spread positive behaviour to fight obesity.

## The Model

We will use a Susceptible-Infected-Susceptible model, as we expect a co-existence of both obese and non obese person in the steady state. In addition,  we will employ the Susceptible-Infected-Susceptible automatic (SISa) model developed by Hill et al. (2). Hill et al. introduced this model to study the spread of obesity to allow for "automatic (or 'spontaneous') non-social infection". Hill et al. applied their models to the Framingham Heart Study database which among other factors follow individual BMI across time as well as the adjacency matrix of the study subjects. 
We will apply the same approach to another similar longitudinal dataset provided by the MIT Human Dynamics Lab (3) which reference the BMI, physical activity frequency of a number participants over a certain period of time as well the friendship network of these persons.
The SISa model takes into account the individual potential genetic predispositions through the 'automatic' parameter and can help us to study the potential social contagion of obesity.	

## Fundamental Questions

1)	We would to investigate if there is a tipping point where all the population might become and remain obese?

2)	Does the social component of obesity outweigh the genetic component?

3)	Is there a quantifiable secondary attribute of obesity that favors the selective formation of ties among obese persons?

4)	To what extent does the social perception of obesity influence the speed and breadth of obesity diffusion?

5)	Do we find predictions which come close to the existing ones as Hill et al. found for instance a long term obesity prevalence of 42% [reference] based on data of the Framingham Heart Stud

## Expected Results

We expect the system to reach a steady state at infinity, considering constant parameters. This final state is likely to reveal the co-existence between obese and non-obese individuals, with a minority of largely over-weighted individuals. The obesity dynamics into a given network will also be observed. 
The SISa model will allow us to compare the social network influence to the weight of the predestination factors on obesity. We expect the latter to be less significant than the social environment. Thus, we expect clusters of people of the same body stature to be pop up.

## References 

(1) American Journal of Health - Public  Estimating Deaths Attributable to Obesity in the United States, 2004
(2) Hill and al. - Infectious Disease Modeling of Social Contagion in Networks, 2010


## Research Methods

We will employ a "Susceptible-Infected-Susceptible" SIS model, the SISa, an extension model developed by Hill and al. We will also perform cross-sectional regression.


## Other

(3)  http://realitycommons.media.mit.edu - MIT Human Dynamics Lab
Sensing the 'Health State' of a Community - A. Madan, M. Cebrian, S. Moturu, K. Farrahi, A. Pentland, Pervasive Computing, Vol. 11, No. 4, pp. 36-45 Oct 2012

