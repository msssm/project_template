%% adjustCardValue function. Calculates the new value of the cards

function [newRandValue] = adjustCardValueP1(sigma, randValue)
    newRandValue=-1;
    
    while newRandValue<0 || newRandValue>1 %if the resulting value is outside of the range -> recalculate             
        newRandValue=sigma*randn+randValue;
    end
end