%%  Startvariablen


n = 1000 % Anzahl simulierter Spiele
RiskP1 = 0.3
RiskP2 = 0.4
Startkapital = 20


%%  Auswertungsvariablen

WinsP1=0;   % Anzahl Siege Player 1
WinsP2=0;   % Anzahl Siege Player 2
Rounds=0;


%%  Schleife f?r Pokerrunden

for i=1:n
    ResultOfGame=runPokerGame(RiskP1,RiskP2,Startkapital);
    Rounds = Rounds + ResultOfGame(3);
    if ResultOfGame(4)==1
        WinsP1=WinsP1+1;
    elseif ResultOfGame(4)==2
        WinsP2=WinsP2+1;
    else
        disp(ResultOfGame(4))
        disp('Error with Result of Game')
    end
end







%%  Statistik und Auswertung

WinsP1=WinsP1/n*100;
WinsP2=WinsP2/n*100;
Rounds=Rounds/n;

sprintf('Wins Player 1: %d %', WinsP1)
sprintf('Wins Player 2: %d %', WinsP2)
sprintf('Average Rounds played: %d', Rounds)