%% Main function. Sets game variables. Calls game function

function winsP1=main(r1,r2)

%game variables
betValue = 1; %the amount of "money" a player can bet if he chooses to play
n = 1000; % number of games played

%player variables
startCapital = 50; % Amount of "money" the players start with 
startCapitalP1 = startCapital; % init. capital player1
startCapitalP2 = startCapital; % init. capital player2

%result variables
winsP1=0;   % Amount of wins by player1

%loop calling the game function
for i=1:n
    
    %input: needed variables capital, risk factor, bet height
    %output: amount of wins by player1
    winner=game(startCapitalP1,r1,startCapitalP2,r2,betValue);
    winsP1=winsP1+winner;
end