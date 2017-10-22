# MATLAB Fall 2017 – Research Plan
> * Group Name: Miners
> * Group participants names: Daniel Dorigatti, Clemens Giuliani, Xiaoyu Sun, Qie Wu
> * Project Title: Simulating the Cryptocurrency Ecosystem using an Agent-Based Model

## General Introduction
<!--
(States your motivation clearly: why is it important / interesting to solve this problem?)
(Add real-world examples, if any)
(Put the problem into a historical context, from what does it originate? Are there already some proposed solutions?)
-->


Cryptocurrencies such as Bitcoin have seen a strong increase in popiularity over the last couple of years. They are becoming more and more accepted as a payment method not only online, but also in retail locations. One can, for example buy Bitcoin at SBB ticket machines and a Swiss municipality (Chiasso) has recently announced that it will accept Bitcoin as an experimental payment method for fees up to the equivalent of 250 Swiss Francs starting from January 2018.
<!-- source: http://www.cdt.ch/ticino/mendrisiotto/182329/a-chiasso-una-parte-delle-imposte-si-pagherà-in-bitcoin -->
Historically most widespread cryptocurrencies have had very strong price fluctuations. In the case of Bitcoin some of these fluctuations are probably caused external events like the shutdown of the MTGOX exchange site and reports regarding a ban in China[2]. 
Just like in the traditional financial world there is mining of cryptocurrencies (comparable to gold mining) and there exist several exchanges where it is possible to trade cryptocurrencies with other fiat (conventional) currencies. However, cryptocurrencies are not consumed in any way (unlike gold which is used in industrial applications). An other novel phenomenon are lost cryptocurrency wallets (e.g. caused by loosing or corrupting the drive they were stored on). In this case the cryptocurrency cannot be restored, contrary to conventional bank accounts.

## The Model
<!--

(Define dependent and independent variables you want to study. Say how you want to measure them.) (Why is your model a good abtraction of the problem you want to study?) (Are you capturing all the relevant aspects of the problem?)
-->
The model we want to study is an agent based model largely based on the one proposed by [2,1]. 
It consists of three different kinds of agents: Miners, Random traders and Chartists. There are buy and sell orders organized in a central order book and new agents entering the market over time. Miners belong to mining pools (i.e. they are modelled to mine at a continous rate). Some of the relevant variables are volatility, market activity and the number of transactions in a given timeframe.
Our aim is to extend this model by incorporating additional parameters (such as a wallet loss probability) and adding additional competing cryptocurrencies similar to [3].


## Fundamental Questions
<!--
(At the end of the project you want to find the answer to these questions)
(Formulate a few, clear questions. Articulate them in sub-questions, from the more general to the more specific. )
-->
- Is it possible to reproduce the cryptocurrency market behaviour using a relatively simple agent based model ?
-  Under which conditions can crashes arise ?
    -  What happens after a crash ?
-  Which factors are responsible for the marketshare of competing cryptocurrencies ?
-  What happens when all Bitcoins are mined ?

## References 

1. _Using an artificial financial market for studying a cryptocurrency market_;  Luisanna Cocco, Michele Marchesi; 2014 (DOI:10.1371/journal.pone.0164603)
1. _Modeling and Simulation of the Economics of Mining in the Bitcoin Market_; Luisanna Cocco, Giulio Concas, Michele Marchesi; 2016 (DOI 10.1007/s11403-015-0168-2)
1. _Do Bitcoins make the world go round? On the dynamics of competing crypto-currencies_; S. Bornholdt and K. Sneppen; 2014 (arXiv:1403.6378 [physics.soc-ph])
1. _Agent-based simulation of a financial market_; Marco Rabertoa, Silvano Cincottia, Sergio M. Focardib, Michele Marchesi; 2001
1. _Price Variations in a Stock Market with Many Agents_; P. Bak, M. Paczuski, and M. Shubik; 1996

## Research Methods

- Agent-Based Model
- Data Analysis (of Blockchain)


## Other
- __Datasets:__ Blockchain 

<!-- (mention datasets you are going to use) -->
