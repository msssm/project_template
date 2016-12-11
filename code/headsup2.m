%% headsup function. Simulating the play of one hand, player1 starts. Calls the function adjustCardValue
function [capP1,capP2]=headsup(startCapitalP1,riskFactorP1,startCapitalP2,riskFactorP2,betValue)

%transfer of variables
playerP1 = [riskFactorP1 startCapitalP1 rand 0];
playerP2 = [riskFactorP2 startCapitalP2 rand 0];


% P R E F L O P. First Phase  

%the following line is deactivated if a game is played with blinds.
%then a player is forced to play with his starting hand and he has to put 
%money in the pot.
if playerP2(3) >= playerP2(1) 
   
    %(*) explanation used often throughout the programm
    %tests if player2 has enough capital to bet and if the bet value isn't
    %higher than player1's capital.
    if playerP2(2)>= betValue && betValue<=playerP1(2)                                                
       playerP2(4) = playerP2(4)+betValue; %adjusting money put in the pot by player2
       playerP2(2) = playerP2(2)-betValue; %adjusting player2's capital
    end
end;

%if the card value is higher than the risk factor, player1 keeps playing
%otherwise he drops out and a new  hand is dealt
if playerP1(3) >= playerP1(1)  
    
    %(**) explanation used often throughout the programm
    %tests if player1 has enough capital to bet and if the bet value isn't
    %higher than player2's capital.
    if playerP1(2)>=betValue && betValue<=playerP2(2)      
        playerP1(4) = playerP1(4)+betValue; %adjusting money put in the pot by player1
        playerP1(2) = playerP1(2)-betValue; %adjusting player1's capital
    end
end;


% F L O P. Second Phase. Three cards are dealt on the table

%tests if no player has dropped out
if playerP2(4) > 0 && playerP1(4) > 0
    
    %Because new cards are dealt the value of the cards must be adjusted
    playerP2(3)=adjustCardValue(.4, playerP2(3));            
    playerP1(3)=adjustCardValue(.4, playerP1(3)); 
    
    %(*)
    if playerP2(3) >= playerP2(1)   
        if playerP2(2)>=0+betValue && betValue<=playerP1(2)      
            playerP2(4) = playerP2(4)+betValue;   
            playerP2(2) = playerP2(2)-betValue;    
        end
    end;

    %(**)
    if playerP1(3) >= playerP1(1)   
        if playerP1(2)>=0+betValue && betValue<=playerP2(2)+playerP2(4)
            playerP1(4) = playerP1(4)+betValue;    
            playerP1(2) = playerP1(2)-betValue;    
        end
    end;
end;


% T U R N. Third Pase. One new card is dealt on the table

%tests if both are allowed to play this phase
if playerP2(4) == playerP1(4) 
    
    %a new card is dealt, hence the value of the cards must be adjusted
    playerP2(3)=adjustCardValue(.2, playerP2(3));            
    playerP1(3)=adjustCardValue(.2, playerP1(3)); 
                    
    %(*)
    %(***)the 0.1 in the next line lowers the risk factor of a player. This is
    %simulating the case that a player more seldomly drops out when he
    %already has invested some money, so he stays in the game even if the
    %cards aren't up to the standard he wishes them to be
    if playerP2(3) >= (playerP2(1)-0.1)   
        if playerP2(2)>=0+betValue && betValue<=playerP1(2)     
        playerP2(4) = playerP2(4)+betValue;    
        playerP2(2) = playerP2(2)-betValue;    
        end
    end;

    %(**),(***)
    if playerP1(3) >= (playerP1(1)-0.1)   
        if playerP1(2)>=0+betValue && betValue<=playerP2(2)+playerP2(4)       
            playerP1(4) = playerP1(4)+betValue;    
            playerP1(2) = playerP1(2)-betValue;   
        end
    end;
end;


% R I V E R. Fourth phase. A last card is dealt on the table
   
%checks if both players are allowed to play this phase
if playerP2(4) == playerP1(4)    
    
    %the card values have to be adjusted a last time
    playerP2(3)=adjustCardValue(.2, playerP2(3));           
    playerP1(3)=adjustCardValue(.2, playerP1(3)); 

    %(*),(***)
    if playerP2(3) >= (playerP2(1)-0.15) 
        if playerP2(2)>=0+betValue && betValue<=playerP1(2)   
            playerP2(4) = playerP2(4)+betValue;    
            playerP2(2) = playerP2(2)-betValue;    
        end
    end;

    %(**),(***)
    if playerP1(3) >= (playerP1(1)- 0.15)  
        if playerP1(2)>=0+betValue && betValue<=playerP2(2)+playerP2(4)     
            playerP1(4) = playerP1(4)+betValue;   
            playerP1(2) = playerP1(2)-betValue;  
        end
    end;
end;


% S H O W D O W N. If both players stay in until the end they have to show 
%their cards

pot = playerP2(4) + playerP1(4); %putting the money bet in the pot

%player1 drops out. player2 wins. cards are not shown
if playerP2(4) > playerP1(4)
    playerP2(2) = playerP2(2)+pot;
end;

%player2 drops out. player1 wins. cards are not shown
if playerP2(4) < playerP1(4)          
    playerP1(2) = playerP1(2)+pot;
end;
    
if playerP2(4) == playerP1(4) %both players want to play until the end
    
    %if player2's cards are better he wins and receives the pot
    if  playerP2(3) > playerP1(3) 
        playerP2(2) = playerP2(2)+pot;
     
    %if player1's cards are better he wins and receives the pot    
    elseif playerP2(3) < playerP1(3)
        playerP1(2) = playerP1(2)+pot;
    
    %both players have the same cards. They get back their own money
    elseif playerP2(3) == playerP1(3)
    playerP2(2) = playerP2(2)+pot/2;
    playerP1(2) = playerP1(2)+pot/2;
    end;
end;

%setting the remaining capital as the output variables
capP2=playerP2(2);
capP1=playerP1(2);                                                                           