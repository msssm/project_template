
%%  UEBERGABEVARIABLEN

counter = 0;            %z?hlt Anzahl Runden bis Ruin eines Spielers
winner = 0;             %speichert den Gewinner des Spiels

% %%  Zwischenspeichervariablen
% %Variablen zum zwischenspeichern der Kapitale von jedem Spieler nach einer
% %gespielten Runde. Dienen als Laufvariable der while-Schleife
% 
% LaufP1= 1;
% LaufP2 = 1;
% 
% 
%     
% CP1=Startkapital;
% CP2=Startkapital;
% %Jeder durchlauf der while-Schleife entspricht einer gespielten Runde
% %Abbruchbedingung: Ein Spieler hat kein Kapital mehr <-> LaufP1 oder LaufP2
% %ist 0
% 

while playerP1(2) > 0 && playerP2(2) > 0; %Kapital gr?sser als 0
    counter = counter + 1;
    headsup; %Simulation einer einzelnen Runde
    
    
    %statisticsMatrix(1,counter)=playerP1;
    %statisticsMatrix(2,counter)=playerP2;
    


end;

if player1(2) == 0
    winner = 2;
elseif player2(2) == 0
    winner = 1;
else
    disp('Error with headsup')
end

% %%  Endstatistics
% 
% %   Ausgabe der wichtigsten gefundenen Werte
% 
% sprintf('Player %d wins all in %d rounds', Winner, Counter)
% 
% %   Plotten des Geldverlaufes von Spieler 1 und 2
% Q=1:Counter;
% subplot(2,1,1)
% plot (Q, GeldverlaufP1)
% title('Geldverlauf Spieler 1')
% subplot(2,1,2)
% hold on
% plot(Q, GeldverlaufP2)
% title('Geldverlauf Spieler 2')
