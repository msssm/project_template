function [playerP2(3)] = adjustCardValueP2(sigma, playerP2(3) )

    newRandValue=-1;
    playerP2 = [];
    while newRandValue<0 || newRandValue>1
        newRandValue=sigma*randn+playerP2(3);
    end
    playerP2(3)=newRandValue;
end

