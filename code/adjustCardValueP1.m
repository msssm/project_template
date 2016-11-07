function [playerP1(3)] = adjustCardValueP1[sigma, playerP1(3)]

    newRandValue=-1;
    
    while newRandValue<0 || newRandValue>1
        newRandValue=sigma*randn+playerP1(3);
    end
    playerP1(3)=newRandValue;
end

