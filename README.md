# MATLAB Fall 2017 – Research Plan

> * Group Name: LQS Shooting
> * Group participants names: Lefkopoulos Vasileios, Qi Shuaixin, Signer Matteo
> * Project Title: Evacuation in case of a public shooting


## General Introduction

Modelling and simulating the evacuation procedure in a public shooting could help us understand the dynamics of such an event. Through this, it is possible to optimize the design of public event spaces and understand which areas are more dangerous for a shooter to be situated in. Public shootings are not rare occurrences, and modelling and simulations could potentially save lives in future shootings. In the US alone, there were 372 mass shootings in 2015.


## The Model

We are going to use a social force model to capture the crowd dynamics, proposed in [1]. The simulations of this model will be conducted using the work of a previous MSSSM group [2]. Both the model and the simulation code have led to interesting and useful results in past work, and therefore will probably be a sufficient toolset for our analysis. We will extend said model so that we can include the presence and dynamics of an attacker in a crowd that is trying to evacuate.

The independent variables of our model will be:
* Threat level of the attacker
* Starting position of the attacker
* Accuracy of the attacker
By varying these parameters we would like to simulate the evacuation procedure and dynamics of the crowd.

Our model is an abstraction of the problem we would like to tackle, containing many simplifications that will make it easier for us to reach some conclusions. Example of some simplifications/hypothesis of our model are:
* The attacker will not move from his starting position
* There will only be one attacker
* The accuracy of the attacker will decrease with distance


## Fundamental Questions

1. How does the threat level of the attack affect the evacuation?
	1. Does a high level of thread hinder the evacuation procedure?
2. How does the starting position of the attacker affect the evacuation?
	1. What are the worst places for an attacker to be situated?
	2. What happens if an attacker is situated near an exit?
3. How does the accuracy of the attacker affect the evacuation?
	1. What happens when the accuracy is really high? How should the crowd react?
	2. What happens when the accuracy is really high? How should the crowd react?
4. How does the layout of the room affect the evacuation?
	1. Is there a problem if there isn’t more than one exit?
	2. How should the exits be placed?
5. Are there any bottlenecks created because of the presence of the attacker?


## Expected Results

1. A really high threat level will probably disorient the crowd away from the exits.
2. If an attacker is placed near an exit, the mortality may increase and people will also be led away from that exit.
3. A really high accuracy will increase the mortality, and the crowd should probably run away from the attacker first before going to an exit.
4. Only one exit will cause a serious problem with the evacuation procedure. The exits should probably be placed as farther away from each other as possible.
5. Some bottlenecks may be created, especially if the attacker is placed near an exit or his threat level is really high.


## References 

[1] Dirk Helbing, Illes Farkas & Tamas Vicsek (2000): Simulating dynamical features
of escape panic
[2] Hans Hardmeier, Andrin Jenal , Beat Kueng, Felix Thaler (2012): [MultiLevelEvacuation_with_custom_C_code](https://github.com/msssm/MultiLevelEvacuation_with_custom_C_code)


## Research Methods

Our initial model will be an agent-based social force model, based on the work done in [1]. Nevertheless, we cannot yet exclude the possibility that we will work with another model.


## Other
