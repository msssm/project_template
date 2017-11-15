function [individual] = createIndividual(coordinates, velocity, isParticipating)
%CREATEINDIVIDUAL Creates a new individual
%   Creates a new vector representing an individual with the specified
%   properties.
    individual = [coordinates(1); coordinates(2); velocity(1); velocity(2); isParticipating];

end

