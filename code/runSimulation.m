function runSimulation()
%RUNSIMULATION Runs the simulation.
%   Execute this function to start running the simulation

    % Size of a vector that represents one individual
    global INDIVIDUAL_SIZE;
    INDIVIDUAL_SIZE = 5;
    
    global SECTOR_SIZE;
    SECTOR_SIZE = 10;
    
    % Initialize the initial conditions of the simulation
    matrix = initializeMatrix([2, 2], 50);
    
    % TEST
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

