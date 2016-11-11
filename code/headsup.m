

function[EndCreditP1, EndCreditP2,x,Pot] = headsup(CP1,CP2,RiskP1,RiskP2)           %Funktionsaufruf



%%  S T A R T V A R I A B L E 
Player_1 = RiskP1;     %Risikobereitschaft P1
Player_2 = RiskP2;     %Risikobereitschaft P2

BetValue = 1;       %Einsatz
Blind = 1;          %Blind-einsatz

CreditP1 = CP1;
CreditP2 = CP2;

PlayP1 = [0 0];     % [ Wert Karte P1 | Wert Bet P1 ]
PlayP2 = [0 0];     % [ Wert Karte P2 | Wert Bet P2 ]

%%  S P I E L V A R I A B L E N


PlayP1(1) = rand;   %Einstigskarte P1
PlayP2(1) = rand;   %Einstigskarte P2

Pot = 0;            % Geld im Pot
x = 0;              % Anzahl Runden



%%  Blind

 PlayP1(2) = Blind;
 PlayP2(2) = Blind;


%%  P R E F L O P
%   1. W E T T R U N D E

if PlayP1(1) >= Player_1            % Raise bzw. Call P1
    if CreditP1-PlayP1(2)>0
    PlayP1(2) = PlayP1(2)+BetValue;          % Gewetteter Betrag P1
    end
end;
if PlayP2(1) >= Player_2           % Raise bzw. Call P2
    if CreditP2-PlayP2(2)>0
    PlayP2(2) = PlayP2(2)+BetValue;           % Gewetteter Betrag P2
    end
end;


%%  F L O P
%	2. W E T T R U N D E

    % 3 neue Karten
if PlayP1(2) > 0 && PlayP2(2) > 0    %Beide wollen Spielen
    
    PlayP1(1) = adjustRandValue(PlayP1(1),.4); %Handkarten aktualisiert nach altem Kartenwert           
    PlayP2(1) = adjustRandValue(PlayP2(1),.4); %Handkarten aktualisiert nach altem Kartenwert
                    
    
    x= x +1;        % Anzahl Runden
    
    %          E I N S A T Z  A U F  F L O P
    
    % Obwohl schon Geld investiert wurde Gilt die Gleiche Grenze!
    
    if PlayP1(1) >= Player_1             %Raise bzw. Call P1
        if CreditP1-PlayP1(2)>0
        PlayP1(2) = PlayP1(2)+1;          %Achtung Bet ist immernoch 1
        end
    end;
    if PlayP2(1) >= Player_2             % Raise bzw. Call P2
        if CreditP2-PlayP2(2)>0
        PlayP2(2) = PlayP2(2)+1;
        end
    end;
end;
%% T U R N
%	3. W E T T R U N D E
    % 1 neue Karte
    %if PlayP1(2) == 2 && PlayP2(2) == 2 %%%%%!!!!!!!!
    
if PlayP1(2) == PlayP2(2)    %Beide wollen Spielen
    
    PlayP1(1) = adjustRandValue(PlayP1(1),0.2);    %Handkarten aktualisiert nach altem Kartenwert
    PlayP2(1) = adjustRandValue(PlayP2(1),0.2);    %Handkarten aktualisiert nach altem Kartenwert

    
    x= x +1;        % Anzahl Runden
    
    %          E I N S A T Z  A U F  T U R N
    
    
    if PlayP1(1) >= Player_1             % Raise bzw. Call P1
        if CreditP1-PlayP1(2)>0
        PlayP1(2) = PlayP1(2)+1;
        end
    end;
    if PlayP2(1) >= Player_2             % Raise bzw. Call P2
        if CreditP2-PlayP2(2)>0
        PlayP2(2) = PlayP2(2)+1;
        end
    end;
    
end;
%% R I V E R
% 4. W E T T R U N D E ------------------%
    % 1 neue Karte
    
if PlayP1(2) == PlayP2(2)    %Beide wollen Speilen
     PlayP1(1) = adjustRandValue(PlayP1(1),0.1);        %Handkarten aktualisiert nach altem Kartenwert
     PlayP2(1) = adjustRandValue(PlayP2(1),0.1);        %Handkarten aktualisiert nach altem Kartenwert
    
     
    x= x +1;        % Anzahl Runden
    
    %          E I N S A T Z  A U F  R I V E R
    
    
    if PlayP1(1) >= Player_1             %Raise bzw. Call P1
        if CreditP1-PlayP1(2)>0
        PlayP1(2) = PlayP1(2)+1;
        end
    end;
    if PlayP2(1) >= Player_2             % Raise bzw. Call P2
        if CreditP2-PlayP2(2)>0
        PlayP2(2) = PlayP2(2)+1;
        end
    end;
end;
%%  R A N D O M

Pot = PlayP1(2) + PlayP2(2);         %Pot 
EndCreditP1 = CreditP1-PlayP1(2);   %EndCreditP1
EndCreditP2 = CreditP2-PlayP2(2);   %EndCreditP2
%%  S H O W D O W N

if PlayP1(2) == Blind && PlayP2(2) == Blind  %Kein Spiel
    %disp('Draw: ');
    %disp(Pot - PlayP1(2));
end;

if PlayP1(2) > PlayP2(2)           %P2 Bietet nicht mehr
    %disp('Player 1 Wins: ');
    %disp(Pot - PlayP1(2));
    EndCreditP1 = EndCreditP1+Pot;
end;
    
if PlayP1(2) < PlayP2(2)           %P1 Bietet nicht mehr
    %disp('Player 2 Wins:');
    %disp(Pot - PlayP2(2));
    EndCreditP2 = EndCreditP2+Pot;
end;

if PlayP1(2) == PlayP2(2)  %beide Spielen ALLE Runden
    %disp('SHOWDOWN')
    if  PlayP1(1) > PlayP2(1)
        %disp('Player 1 Wins: ');
        %disp(Pot - PlayP1(2));
        EndCreditP1 = EndCreditP1+Pot;
    elseif PlayP1(1) == PlayP2(1)
        %disp('Draw');
        EndCreditP1 = EndCreditP1+PlayP1(2);
        EndCreditP2 = EndCreditP2+PlayP2(2);
    elseif PlayP2(1) > PlayP1(1)
        %disp('Player 2 Wins:');
        %disp(Pot - PlayP2(2));
        EndCreditP2 = EndCreditP2+Pot;
    end;
end;





%%  B I L A N Z

%% Bilanz = ['gespielte Runden ' num2str(x) ' EndCredit P1: ' num2str(EndCreditP1) '|' 'EndCredit P2: ' num2str(EndCreditP2)];
%%disp(Bilanz);

end                                                                                %End of the Function