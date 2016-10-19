# MATLAB Fall 2016 – Research Plan

> * Group Name: töfftöff
> * Group participants names: Colin Berner, Luzian Hug
> * Project Title: Smart Driving Strategies

## General Introduction
Traffic jams are a growing problem in everyday life. Increasing road surface is not a sustainable solution to the problem as we are already reaching our limits in this respect. Also, building broader and broader roads is not compatible with environmental efforts. Therefore, we must try to increase the throughput using the existing infrastructure.

There are solutions proposed involving autonomous cars or external traffic management. We believe that the capacity can also be substatially increased by changing the individual behaviour of drivers without artificial help.

## The Model
We want to model a section of a congested road using the "Intelligent Driver Model". This model takes into account the velocity of an individual car, the velocity of the car in front as well as the distance between both cars.

We then want to commit changes to this model in order to implement different driving strategies, such as observing both the car in front and behind the observed vehicle or also taking into account the braking of the leading cars.

## Fundamental Questions
* Which strategies that are both humanly possible and practically realizable can be used by the individual driver in order to increase traffic flow on a congested road?
* How much of a difference does such a strategy make compared to typical driving behaviour? What happens if only a portion of drivers follow a strategy?

## Expected Results
We expect that it is in fact possible to improve traffic flow and prevent traffic jams originating from smaller disruptions. It is likely that in order to achieve noticable improvement, the majority of drivers must follow such a strategy.

## References 
[1] M. Treiber, A. Kesting, D. Helbing, Delays, inaccuracies and anticipation in
microscopic traffic models (2005)

[2]  M. Treiber, A. Hennecke, D. Helbing, Congested traffic states in empirical observations and
microscopic simulations (2000)

## Research Methods
Continuous Modeling by using a dynamical state space model to abstract the individual driver's behaviour.
