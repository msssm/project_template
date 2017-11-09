function runSimulation()
%RUNSIMULATION Runs the simulation.
%   Execute this function to start running the simulation

    % Size of a vector that represents one individual
    global INDIVIDUAL_SIZE;
    INDIVIDUAL_SIZE = 5;
    
    % Initialize the initial conditions of the simulation
    matrix = initializeMatrix([3, 3], 30);
    
    % TEST
    disp(matrix);

end

