# MATLAB Spring 2014 – Research Plan

> * Group Name: Les Trois Mousquetaires
> * Group participants names: Ledieu Elise, Munich Emmanuel, Wirz François
> * Project Title: Social contagion of obesity

## General Introduction

Obesity is a major health concern in the US causing annual mortality around 300'000 deaths per year (1). According to World Health Organization, diet and physical exercise are possible remedies to this social health problem. We would like to find out to which extent obesity spreads through social networks. An answer to this question could help to design adequate public health policies and decide if obesity has to be tackled as a clinical issue (i.e. on an individual basis) or as a public health intervention which could better exploit the network phenomena to spread positive behaviour to fight obesity.

## The Model

We will use a Susceptible-Infected-Susceptible model, as we expect a co-existence of both obese and non obese person in the steady state. In addition,  we will resort to the Susceptible-Infected-Susceptible automatic (SISa) model developed by Hill et al. (2). Hill et al. introduced this model to study the spread of obesity to allow for "automatic (or 'spontaneous') non-social infection". Hill et al. applied their models to the Framingham Heart Study database which among other factors follow individual Body Mass Index across time as well as the adjacency matrix of friendships between the study subjects. 

We will apply the same approach to a similar longitudinal dataset provided by the MIT Human Dynamics Lab (3) which references the BMI, physical activity frequency of a number of participants over a certain period of time as well the friendship network of these persons.
The SISa model has the advantage to capture individual potential genetic predispositions through the 'automatic' parameter and can help us to study the social contagion effect of obesity.	

## Fundamental Questions

1)	We would like to investigate if there is a tipping point where all the population might become and remain obese?

2)	Does the social component of obesity outweigh the genetic component?

3)	To what extent does the social perception of obesity influence the speed and breadth of obesity diffusion?

4)	Do we find predictions which come close to the existing ones as Hill et al. found for instance a long term obesity prevalence of 42% (2) based on data of the Framingham Heart Study.

## Expected Results

We expect the system to reach a steady state at infinity, considering constant parameters. This final state is likely to reveal the co-existence between obese and non-obese individuals, with a minority of over-weighted individuals. The obesity dynamics into a given network will also be observed. 
The SISa model will allow us to compare the social network and other predispositions factors influence on obesity. We expect the latter to be less significant than the social environment. Thus, we expect clusters of people with similar body stature to emerge.

## References 

(1) American Journal of Health - Public Estimating Deaths Attributable to Obesity in the United States, 2004
(2) Hill and al. - Infectious Disease Modeling of Social Contagion in Networks, 2010
(4) Christakis and Fowler - The Spread of Obesity in a Large Social Network over 32 Years, 2007

## Research Methods

We will use a "Susceptible-Infected-Susceptible" SIS model, the SISa, an extension model developed by Hill and al. We will also perform cross-sectional regression.

## Other

(3)  http://realitycommons.media.mit.edu - MIT Human Dynamics Lab
Sensing the 'Health State' of a Community - A. Madan, M. Cebrian, S. Moturu, K. Farrahi, A. Pentland, Pervasive Computing, Vol. 11, No. 4, pp. 36-45 Oct 2012

