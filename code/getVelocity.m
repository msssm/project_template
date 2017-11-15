function [velocity] = getVelocity(individual)
%GETVELOCITY Gets the velocity of the given individual.
    velocity = [individual(3); individual(4)];
end
