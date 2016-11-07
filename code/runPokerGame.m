function [ GeldverlaufP1, GeldverlaufP2, Counter, Winner ] = runPokerGame( RiskP1, RiskP2, Startkapital )

%%  Outputvariablen

GeldverlaufP1 = [];     %Geld-Zeit-Verlauf des Spielers 1
GeldverlaufP2 = [];     %Geld-Zeit-Verlauf des Spielers 2
Counter = 0;            %z?hlt Anzahl Runden bis Ruin eines Spielers
Winner = 0;             %speichert den Gewinner des Spiels

%%  Zwischenspeichervariablen
%Variablen zum zwischenspeichern der Kapitale von jedem Spieler nach einer
%gespielten Runde. Dienen als Laufvariable der while-Schleife

LaufP1= 1;
LaufP2 = 1;


    
CP1=Startkapital;
CP2=Startkapital;
%Jeder durchlauf der while-Schleife entspricht einer gespielten Runde
%Abbruchbedingung: Ein Spieler hat kein Kapital mehr <-> LaufP1 oder LaufP2
%ist 0


while LaufP1 > 0 && LaufP2 > 0;
    Counter = Counter + 1;
    [EndCreditP1,EndCreditP2,Tempx,TempPot] = headsup(CP1,CP2,RiskP2,RiskP2); %Simulation einer einzelnen Runde
    CP1=EndCreditP1;
    CP2=EndCreditP2;
     
    
    LaufP1 = EndCreditP1;
    LaufP2 = EndCreditP2;
    
    GeldverlaufP1(Counter) = EndCreditP1;
    GeldverlaufP2(Counter) = EndCreditP2;

 

end;

if LaufP1 == 0
    Winner = 2;
end
if LaufP2 == 0
    Winner = 1;
end

end

