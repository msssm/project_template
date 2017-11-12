%{
GENERAL NOTES
=============

Each function should be defined in a separate file according
to MATLAB requirements. Upload these files to the code folder
in the repository.
When iterating over the matrix, if possible, parallelize the
accesses using parfor to increase efficiency. To iterate over
the people inside of one sector, use the following piece of
code:

itr = matrix(i, j).iterator();

while itr.hasNext()
    person = itr.next();
    % Do something with that person
end

Inside the matrix, the position of the individual is represented in
absolute terms (i.e. relative to the entire matrix, not the sector). For
precision reasons, the coordinates range from 0 to 10 * resolution (for
now, we can always make it finer-grained by changing the SECTOR_SIZE
global).

To convert coordinates to a sector, use the function
sectorForCoords(individual). You can also pass pure coordinates to this
function.

Define all globals in the runSimulation.m file. This way, the parameters of
the simulation are easy to find and change.

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
each sector are represented with a java.util.LinkedList.
The coordinates of each person are given as absolute coordinates,
i.e. not relative to the sector, but to the entire matrix.
%}
function initializeMatrix()
end

% Gets the position of the given individual
function [position] = getPosition(individual)
end

% Gets the velocity of the given individual
function [velocity] = getVelocity(individual)
end

% Returns true if the given individual is participating in the circle pit
function [isParticipating] = isParticipating(individual)
end

% Returns the distance between two individuals
function [distance] = distance(individual1, individual2)
end

%{
Returns the neighbors of the given individual as a matrix where each column
is an individual.
%}
function [neighbors] = getNeighbors(individual)
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
        runOneTimestep(matrix);
    end
end



