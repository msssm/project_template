clear all
clc


%%  Startvariablen, User Inputs


n = 1000; % Anzahl simulierter Spiele

%Playervalues
riskFactorP1 = 0.3;
riskFactorP2 = 0.4;
startCapitalP1 = 20;
startCapitalP2 = 20;

%Gamevalues
global betValue;
betValue = 1;

blindOn = true;
blindValue = 1;





%%  Auswertungsvariablen

winsP1=0;   % Anzahl Siege Player 1
winsP2=0;   % Anzahl Siege Player 2
rounds=zeros;   % Gespielte Runden pro Spiel
totalRounds=0;
statisticsMatrix=zeros;


%%  Setzen der Spielmatrizen

%   Aufbau der Spieler matrix: [riskFactor, capital, cardValue, CurrentBet, Losses]


global playerP1;
global playerP2;
playerP1=[riskFactorP1 startCapitalP1 -1 -1 -1];
playerP2=[riskFactorP2 startCapitalP2 -1 -1 -1];

%   Aufbau der Game matrix: [betValue, blindOn blindValue]
global gameValues;
gameValues=[betValue blindOn blindValue];

%%  Schleife fuer Games

for i=1:n
    
    game; %Simulation eines Spieles
    
    
    if winner == 1
        winsP1=winsP1+1;
    elseif winner == 2
        winsP2=winsP2+1;
    else
        disp(winner)
        disp('Error with return value of game')
    end
    rounds(n)=counter;
    totalRounds=totalRounds+counter;
end







%%  Statistik und Auswertung

winsP1=winsP1/n*100;
winsP2=winsP2/n*100;
rounds=rounds/n;

sprintf('Wins Player 1: %d %', WinsP1)
sprintf('Wins Player 2: %d %', WinsP2)
sprintf('Average Rounds played: %d', Rounds)