function runSimulation()
%RUNSIMULATION Summary of this function goes here
%   Detailed explanation goes here

    % Size of a vector that represents one individual
    global INDIVIDUAL_SIZE;
    INDIVIDUAL_SIZE = 5;
    
    % Initialize the initial conditions of the simulation
    matrix = initializeMatrix([10, 10], 100);
    
    % TEST
    disp(matrix);

end

