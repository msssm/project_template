# MATLAB Fall 2015 – Research Plan

> * Group Name: mGrid
> * Group participants names: Xingliang Fang, Seoho Jung, Huiting Zhang
> * Project Title: Microgrid with Electric Vehicles



## General Introduction

A microgrid is a modern, localized, small-scale network, as opposed to the traditional, centralized grid (macrogrid). Although connected to the centralized grid for the most part, a microgrid can operate autonomously by disconnecting its coupling with the macrogrid. Until recently, the macrogrid system has been designed to accommodate the full peak demand because it lacks cost-effetive storage that can store energy during off-peak hours and use the saved energy during peak hours. The costs of meeting the peak demand have led to high cost inefficieny; generators and transmission lines have been largely underutilized during off-peak hours.[1][2]

Microgrids have been expected to alleviate such inefficiency because they allow more flexible demand consumption.[3] One research forecasts that the microgrid capacity in the United States will exceed 1.8 GW by 2018.[4] Due to their high-capacity battery packs, electric vehicles (EVs) can be very useful in microgrids. Studies in the past have examined how EVs can benefit their owners by providing saved energy during peak hours and selling energy back to the macrogrid in vehicle-to-grid (V2G) services. However, in these models, each EV owner's use of off-peak power was limited by the capacity of his or her own EV battery pack. Our model analyzes a microgrid formed by EV owners in the vicinity, in which participants share their saved off-peak energy and thus can use more than what their own battery packs can store.



## The Model

Our model introduces the concept of EV agent, a hypothetical controlling unit that manages the microgrid. This concept has already been introduced in [3]. The EV agent determines when each of the participating EVs charges and discharges, how much energy it buys from or sells back to the macrogrid, and how much energy it shares with the other members. It follows certain restrictions, some of which include the following:

	- It takes power from EVs that are more than 50% charged.
	- An EV does not charge and discharge at the same time.
	- EVs are fully charged by designated driving hours of their owners (e.g. 9 AM).
	- More guidelines will be adopted from [3] or added by our team later.

The EV agent works in a way that maximizes the sum of net revenues of all EVs in the network; net revenue is defined as follows:

	(Net Revenue) = (Profit of Using Stored Off-Peak Energy) - (Cost of Grid Electricity Used to Charge an EV) - (EV-agent Installation Cost) - (Battery Degradation Cost)

Our model will be a simplified, yet realistic abstraction of real-life microgrids. It will include actual data--for example, historical hourly electricity prices, driving profiles, and electricity consumption rates of a city of our interest--to provide realistic results.



## Fundamental Questions

(1) Would joining the microgrid be a rational decision to a new participant?

Our model will indicate the total economic benefit that a new participant would obtain by joining the microgrid, determining if joining the network would be a rational decision to the new participant. If the microgrid currently has n members, our funcion will provide the analysis for the (n+1)th member, who need to deEEcide whether to join the network or not.

Our MATLAB function will have a form similar to the following:

	(t_breakeven, p_annual, p_total) = function(cap_EV, h_driving)
	
	t_breakeven: time required to reach the break-even point
	p_annual: annual profit for the (n+1)th driver
	p_total: total profit before the replacement of a battery pack
	cap_EV: capacity of the (n+1)th EV's battery pack
	h_driving: driving pattern of the (n+1)th driver

(2) What other social factors would affect the formation of the EV microgrid?

After this basic model is completed, social influences will be taken into account; we will analyze how "non-rational" factors affect individual decisions.



## Expected Results

We expect that the EV owners in the microgrid will obtain substantial economic profits.



## References

[1] EPRI, EPRI-DOE Handbook of Energy Storage for Transmission and Distribution Applications, 2003.

[2] Peterson et al., The economics of using plug-in hybrid electric vehicle battery packs for grid storage, Journal of Power Sources, 2010.

[3] M. A. López et al., Optimal Microgrid Operation with Electric Vehicles, 2011 2nd IEEE PES International Conference and Exhibition on Innovative Smart Grid Technologies (ISGT Europe), 2011.

[4] GTM Research, North American Microgrids 2014: The Evolution of Localized Energy Optimization, 2014.

As explained above, our model extends these studies by considering the sharing of electricity among microgrid participants.



## Research Methods

We will adopt the agent-based model, in which each new--(n+1)th--participant is the agent of analysis



## Other

Later, we will select one city for our analysis and use the following data of the city:

	- Historical hourly electricity prices
	- Driving profiles
	- Energy consumption rates