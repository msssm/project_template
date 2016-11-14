# MATLAB Fall 2014 – Research Plan (Template)
(text between brackets to be removed)

> * Group Name: Royal Flush
> * Group participants names: Weber Tim, Lionel Gulich, Jan Speckien
> * Project Title: Active and passive strategies in Texas hold'em

## General Introduction
Texas hold’em is a variation of the card game of poker. The game is played with a 52-card deck that includes four suits: hearts, diamonds, clubs and spades with each 13 ranks. The ranking from the top down is: A, K, Q, J, 10, 9, 8, 7, 6, 5, 4, 3, and 2. All the players start with the same amount of money. When a player has no more money, he is eliminated. The goal is to be the last man standing with all the cash of the opponents. The game is played in rounds and every round is divided into four phases:
1)	Every player gets handed two cards called the hold cards, these are used for one’s own benefit and kept secret for the others
2)	Three cards are dealt on the table called “the flop”, from now on every player can make use of the cards on table
3)	Then one more is dealt called “the turn”
4)	A last card called “the river” is dealt

The rules are straight forward, in every phase one either:
-	“folds” that means you don’t want to play anymore in this round 
-	“raises” that is when a player puts in more money on the table to play for 
-	“calls” which means you put in as much money as there is on the table 
-	“checks” that is when a player doesn’t want to do any of the above which is only possible when nobody has raised the pot. 
As soon as somebody has raised the amount of money to play for the others have to call to get into the next phase or they drop out.

A player wins a round when all his opponents have folded their cards or at the end when comes to a “showdown” and every party has come to an agreement on how much money to play for, they show each other their cards and the player with the best combination of cards wins the round.

Texas hold’em is a game of strategy, psychology and probability and gamble. It often doesn’t even come to the showdown because a player makes another believe that he has the strongest hand through his way of raising the pot. Of course it is also possible to lure opponents into a trap or to just gamble, luck is involved after all.

Our goal is to research what style of play prevails in a heads-up in Texas hold’em. Even further, if time alouds it, how beneficiary learning the other’s pattern is to winning the game.
Our program is going to include a dealer whom is dealing a random numbers with a certain value, with that abstraction we avoid programming the complexity of all the combinations of cards. Players are going to make decisions based on the card’s value. Later on we want to include the height of a raise of the opponent into the decision making. A last step would be to give one of the players a learning effect with which he studies the pattern of the other player and plays accordingly. 


## The Model
There are a couple of variables that would be interesting to study, depending how far we come with our model.
-	The first being the thresholds which decide how conservative/aggressive the players are and because of that what play style prevails
-	The second one is the quality of the cards that are dealt and which impact that has on the outcome
-	Further interesting are things like learning the opponents play style: can player A capitalise on a too aggressive player B after A has learnt B’s pattern to play. Or the other way around, that B starts to bluff A out of the game because A is too timid.



## Fundamental Questions
    - Is an aggressive or a passive style of play the most successful in a heads-up in Texas hold'em?
    - What influence does the quality of the cards have?
    - What changes if a player can decide how much he wants to raise the pot? 
    - Will studying the opponent's pattern lead to a more successful outcome?


## Expected Results
From personal experience we think the more aggressive player will be more successful over a long period of time. 
But it all depends on how the risk-thresholds are set.


## References 

-

## Research Methods

We don't know yet what kind of model we are going to use but we guess cellular atomata might be interesting to show a learning effect.


## Other


