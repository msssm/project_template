function winsP1=main(r1,r2)
clc


%%  Startvariablen, User Inputs


n = 1000; % Anzahl simulierter Spiele

%Playervalues
riskFactorP1 = r1;
riskFactorP2 = r2;
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
for i=1:10000



            winners(i)=game(startCapitalP1,r1,startCapitalP2,r2,betValue);%Simulation eines Spieles
            winsP1=winsP1+winners(i);
end

%sprintf('Wins Player 1: %d %', winsP1);
%sprintf('Wins Player 2: %d %', winsP2);
%sprintf('Average Rounds played: %d', totalRounds);