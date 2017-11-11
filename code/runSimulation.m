function runSimulation()
%RUNSIMULATION Runs the simulation.
%   Execute this function to start running the simulation

    % Size of a vector that represents one individual
    global INDIVIDUAL_SIZE;
    INDIVIDUAL_SIZE = 5;
    
    % Size of the matrix
    global MATRIX_SIZE;
    MATRIX_SIZE = 2;
    
    % Coordinate space of one sector of the position matrix
    global SECTOR_SIZE;
    SECTOR_SIZE = 10;
    
    % The radius in which to search for neighbors
    global NEIGHBOR_SEARCH_RADIUS;
    NEIGHBOR_SEARCH_RADIUS = 5;
    
    % The size of one individual
    global INDIVIDUAL_RADIUS;
    INDIVIDUAL_RADIUS = 1;
    
    % Initialize the initial conditions of the simulation
    % We make the matrix a global variable to simulate pass-by-reference
    global matrix;
    matrix = initializeMatrix([MATRIX_SIZE, MATRIX_SIZE], 50);
    
    % TEST
    
    runOneTimestep();
    
    for i = 1:matrix.length
        for j = 1:matrix(i).length
            disp('Position: ');
            disp([i, j]);
            list = matrix(i, j);
            itr = list.iterator();
            while itr.hasNext()
                individual = itr.next();
                disp(individual');
            end
        end
    end
    

end

