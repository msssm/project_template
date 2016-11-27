function [newRandValue] = adjustCardValueP1(sigma, randValue)

    newRandValue=-1;
    
    while newRandValue<0 || newRandValue>1
        newRandValue=sigma*randn+randValue;
    end
end

