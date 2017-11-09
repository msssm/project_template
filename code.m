%{
GENERAL NOTES
=============

Each function should be defined in a separate file according
to MATLAB requirements.
When iterating over the matrix, if possible, parallelize the
accesses using parfor to increase efficiency. To iterate over
the people inside of one sector, use the following piece of
code:

itr = matrix(i, j).iterator();

while itr.hasNext()
    person = itr.next();
    % Do something with that person
end

=============
%}

% Definition of individual

%{
An individual is a vector with 
- positionX
- positionY
- velocityX
- velocityY
- isParticipating in moshpit
%}

%{
Initializes the position matrix. The ground covered by the people
attending the concert is divided into sectors. The people in
each sector are represented with a java.util.ArrayList.
The coordinates of each person are given as absolute coordinates,
i.e. not relative to the sector, but to the entire matrix.
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



