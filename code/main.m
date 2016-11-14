clear all
clc


%%  Startvariablen, User Inputs


n = 1000; % Anzahl simulierter Spiele

%Playervalues
riskFactorP1 = 0.2;
riskFactorP2 = 0.2;
startCapital = 50;  %Startkapital
startCapitalP1 = startCapital;
startCapitalP2 = startCapital;

%Gamevalues
betValue = 1;
blindOn = true;
blindValue = 1;





%%  Auswertungsvariablen

winsP1=0;   % Anzahl Siege Player 1
winsP2=0;   % Anzahl Siege Player 2
rounds=[];   % Gespielte Runden pro Spiel
totalRounds=0; % Heads up's (Hands played)

statisticsMatrix=zeros;


%%  Setzen der Spielmatrizen

%   Aufbau der Spieler matrix: [riskFactor, capital, cardValue, currentBet, Losses]


playerP1=[riskFactorP1 startCapitalP1 -1 0 -1];
playerP2=[riskFactorP2 startCapitalP2 -1 0 -1];

%   Aufbau der Game matrix: [betValue, blindOn blindValue]
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
    % rounds(i)=counter;
    totalRounds=totalRounds+counter;
end







%%  Statistik und Auswertung

%winsP1=winsP1/n*100;  %umwandeln in Prozent
%winsP2=winsP2/n*100;  %umwandeln in Prozent
totalRounds=totalRounds/n;

sprintf('Wins Player 1: %d %', winsP1)
sprintf('Wins Player 2: %d %', winsP2)
sprintf('Average Rounds played: %d', totalRounds)