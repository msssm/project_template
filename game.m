function winner=game(startCapitalP1,riskFactorP1,startCapitalP2,riskFactorP2,betValue)
%%  UEBERGABEVARIABLEN
           %speichert den Gewinner des Spiels
winner=0;

playerP1=zeros(5,1);
playerP2=zeros(5,1);
playerP1(1)=riskFactorP1;
playerP2(1)=riskFactorP2;
playerP1(2)=startCapitalP1;
playerP2(2)=startCapitalP2;
counter = 0;

while playerP1(2) > 0 && playerP2(2) > 0; %Kapital gr?sser als 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    counter = counter + 1;
    decide_who_starts = mod(counter, 2);
    if decide_who_starts == 1
        [playerP1(2),playerP2(2)]=headsup(playerP1(2),playerP1(1),playerP2(2),playerP2(1),betValue); %Simulation einer einzelnen Runde
    else
        [playerP1(2),playerP2(2)]=headsup2(playerP1(2),playerP1(1),playerP2(2),playerP2(1),betValue); %Simulation einer einzelnen Runde
    end;
end;

if playerP1(2) == 0
    winner = 0;
elseif playerP2(2) == 0
    winner = 1;
else
    error('Error with headsup')
end
