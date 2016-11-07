clear all;
close all;

%%  This File should run the function until one player wins.


%%  Konstante Startvariablen (=Input)

%Risikobereitschaft der Spieler. Umso tiefer die Zahl, umso mehr Risiko
%nimmt ein Spieler
RiskP1 = 0.8;
RiskP2 = 0.2;
Startkapital=2000;   %Konstante Startkapitalvariable
 
%%  Outputvariablen fuer die Statistik

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

%%  Endstatistics

%   Ausgabe der wichtigsten gefundenen Werte

sprintf('Player %d wins all in %d rounds', Winner, Counter)

%   Plotten des Geldverlaufes von Spieler 1 und 2
Q=1:Counter;
subplot(2,1,1)
plot (Q, GeldverlaufP1)
title('Geldverlauf Spieler 1')
subplot(2,1,2)
hold on
plot(Q, GeldverlaufP2)
title('Geldverlauf Spieler 2')
