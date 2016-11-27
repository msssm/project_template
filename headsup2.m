function [capP1,capP2]=headsup2(startCapitalP1,riskFactorP1,startCapitalP2,riskFactorP2,betValue)


%%  S P I E L V A R I A B L E N

pot = 0;            % Geld im Pot
betRounds = 0;% Anzahl Runden
playerP2=zeros(5,1);
playerP1=zeros(5,1);
playerP2(1) = riskFactorP2;
playerP1(1) = riskFactorP1;
playerP2(2) = startCapitalP2;
playerP1(2) = startCapitalP1;
playerP2(3) = rand;
playerP1(3) = rand;


%%  P R E F L O P
%   1. W E T T R U N D E

%if playerP2(3) >= playerP2(1)   % Raise bzw. Call P1
    if playerP2(2)>= betValue && betValue<=playerP1(2)       % ?berpr?fen ob eigenes Kapital gr?sser als Einsatz und Einsatz kleiner als Kapital vom Gegner
        playerP2(4) = playerP2(4)+betValue;    % Einsatz anpassen
        playerP2(2) = playerP2(2)-betValue;    % Kapital anpassen
%    end
end;


if playerP1(3) >= playerP1(1)   % Raise bzw. Call P2
    if playerP1(2)>=betValue && betValue<=playerP2(2)       % ?berpr?fen ob eigenes Kapital gr?sser als Einsatz und Einsatz kleiner als Kapital vom Gegner
        playerP1(4) = playerP1(4)+betValue;    % Einsatz anpassen
        playerP1(2) = playerP1(2)-betValue;    % Kapital anpassen
    end
end;


%%  F L O P
%	2. W E T T R U N D E

    % 3 neue Karten
if playerP2(4) > 0 && playerP1(4) > 0    %Beide wollen Spielen
    
    playerP2(3)=adjustCardValue(.4, playerP2(3)); %Handkarten aktualisiert nach altem Kartenwert           
    playerP1(3)=adjustCardValue(.4, playerP1(3)); %Handkarten aktualisiert nach altem Kartenwert
                    
    betRounds= betRounds +1;        % Anzahl Runden
    
    
    %          E I N S A T Z  A U F  F L O P
    
    % Obwohl schon Geld investiert wurde Gilt die Gleiche Grenze!
    
    if playerP2(3) >= playerP2(1)   % Raise bzw. Call P1
        if playerP2(2)>=0+betValue && betValue<=playerP1(2)       % ?berpr?fen ob eigenes Kapital gr?sser als Einsatz und Einsatz kleiner als Kapital vom Gegner
            playerP2(4) = playerP2(4)+betValue;    % Einsatz anpassen
            playerP2(2) = playerP2(2)-betValue;    % Kapital anpassen
        end
    end;


    if playerP1(3) >= playerP1(1)   % Raise bzw. Call P2
        if playerP1(2)>=0+betValue && betValue<=playerP2(2)+playerP2(4)       % ueberpruefen ob eigenes Kapital groesser als Einsatz und Einsatz kleiner als Kapital+Einsatz vom Gegner, sprich keine All-in situation
            playerP1(4) = playerP1(4)+betValue;    % Einsatz anpassen
            playerP1(2) = playerP1(2)-betValue;    % Kapital anpassen
        end
    end;
end;
%% T U R N
%	3. W E T T R U N D E
    % 1 neue Karte
    %if PlayP1(2) == 2 && PlayP2(2) == 2 %%%%%!!!!!!!!
    
if playerP2(4) == playerP1(4)    %Beide wollen Spielen
    
    playerP2(3)=adjustCardValue(.2, playerP2(3)); %Handkarten aktualisiert nach altem Kartenwert           
    playerP1(3)=adjustCardValue(.2, playerP1(3)); %Handkarten aktualisiert nach altem Kartenwert
                    
    betRounds= betRounds +1;        % Anzahl Runden
    
    %          E I N S A T Z  A U F  T U R N
    
    
    if playerP2(3) >= playerP2(1)   % Raise bzw. Call P1
        if playerP2(2)>=0+betValue && betValue<=playerP1(2)       % ?berpr?fen ob eigenes Kapital gr?sser als Einsatz und Einsatz kleiner als Kapital vom Gegner
        playerP2(4) = playerP2(4)+betValue;    % Einsatz anpassen
        playerP2(2) = playerP2(2)-betValue;    % Kapital anpassen
        end
    end;


    if playerP1(3) >= playerP1(1)   % Raise bzw. Call P2
        if playerP1(2)>=0+betValue && betValue<=playerP2(2)+playerP2(4)       % ?berpr?fen ob eigenes Kapital gr?sser als Einsatz und Einsatz kleiner als Kapital vom Gegner
            playerP1(4) = playerP1(4)+betValue;    % Einsatz anpassen
            playerP1(2) = playerP1(2)-betValue;    % Kapital anpassen
        end
    end;
    
end;
%% R I V E R
% 4. W E T T R U N D E ------------------%
    % 1 neue Karte
    
if playerP2(4) == playerP1(4)    %Beide wollen Spielen
    
    playerP2(3)=adjustCardValue(.1, playerP2(3)); %Handkarten aktualisiert nach altem Kartenwert           
    playerP1(3)=adjustCardValue(.1, playerP1(3)); %Handkarten aktualisiert nach altem Kartenwert
                    
    betRounds= betRounds +1;        % Anzahl Runden
    
    %          E I N S A T Z  A U F  R I V E R
    
    
    
    if playerP2(3) >= playerP2(1)   % Raise bzw. Call P1
        if playerP2(2)>=0+betValue && betValue<=playerP1(2)       % ?berpr?fen ob eigenes Kapital gr?sser als Einsatz und Einsatz kleiner als Kapital vom Gegner
            playerP2(4) = playerP2(4)+betValue;    % Einsatz anpassen
            playerP2(2) = playerP2(2)-betValue;    % Kapital anpassen
        end
    end;


    if playerP1(3) >= playerP1(1)   % Raise bzw. Call P2
        if playerP1(2)>=0+betValue && betValue<=playerP2(2)+playerP2(4)     % ?berpr?fen ob eigenes Kapital gr?sser als Einsatz und Einsatz kleiner als Kapital vom Gegner
            playerP1(4) = playerP1(4)+betValue;    % Einsatz anpassen
            playerP1(2) = playerP1(2)-betValue;    % Kapital anpassen
        end
    end;
end;



%%  S H O W D O W N

pot = playerP2(4) + playerP1(4);         %Pot aktualisieren

if playerP2(4) > playerP1(4)           %P2 Bietet nicht mehr, P1 gewinnt
    %disp('Player 1 Wins: ');
    %disp(Pot - PlayP1(2));
    playerP2(2) = playerP2(2)+pot;
end;
    
if playerP2(4) < playerP1(4)           %P1 Bietet nicht mehr, P2 gewinnt
    %disp('Player 1 Wins: ');
    %disp(Pot - PlayP1(2));
    playerP1(2) = playerP1(2)+pot;
end;
    

if playerP2(4) == playerP1(4)  %beide Spielen ALLE Runden
    %disp('SHOWDOWN')
    if  playerP2(3) > playerP1(3) %P1 gewinnt
        playerP2(2) = playerP2(2)+pot;
        
    elseif playerP2(3) < playerP1(3) %P2 gewinnt
        playerP1(2) = playerP1(2)+pot;
        
    elseif playerP2(3) == playerP1(3) %Draw
    playerP2(2) = playerP2(2)+pot/2;
    playerP1(2) = playerP1(2)+pot/2;

    end;
end;
capP2=playerP2(2);
capP1=playerP1(2);
playerP2(4)=0;  %R?cksetzen des Einsatzes von P1 auf 0
playerP1(4)=0;  %R?cksetzen des Einsatzes von P2 auf 0

                          