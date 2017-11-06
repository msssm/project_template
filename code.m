% Definition of individual

%{
An individual is a vector with 
- positionX
- positionY
- velocityX
- velocityY
- isParticipating in moshpit
%}

function [matrix] = initializeMatrix()
end

%{
Returns a vector with 2 fields (x, y) from the input individual.
%}
function [position] = getPosition(individual)
position = [individual(1), individual(2)];
end

%{
Returns a vector with 2 fields representing the velocity.
%}
function [velocity] = getVelocity(individual)
velocity = [individual(3), individual(4)];
end

%{
Returns whether the given individual is participating.
%}
function [isParticipating] = isParticipating(individual)
isParticipating = individual(5);
end

% TODO
%{
Returns the neighbors of the given individual as a matrix where each column
is an individual.
%}
function [neighbors] = getNeighbors(individual)
end

% TODO
%{
Updates the properties of the given individual according to the model from the
paper.
%}
function updateProperties(individual)
end

% TODO
%{
Main loop that iterates through the individuals and updates all their
positions, returning the modified main matrix.
%}
function runOneTimestep(matrix)
matrix = 
end

% TODO
%{
Runs the simulation.
%}
function runSimulation()
initializeMatrix();
for i = 1:MAX
    matrix = runOneTimestep(matrix);
end
end



