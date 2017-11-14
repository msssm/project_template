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
    
    % The size of one individual
    global INDIVIDUAL_RADIUS;
    INDIVIDUAL_RADIUS = 1;
    
    % The number of people at the concert
    global NUMBER_OF_PEOPLE;
    NUMBER_OF_PEOPLE = 50;
    
    % The radius in which to search for neighbors
    global FLOCK_RADIUS;
    FLOCK_RADIUS = 10;
    
    % ===================== PARAMETERS FROM THE PAPER =====================
    % TODO: Set these variables
    global EPSILON;
    EPSILON = 1;
    
    global MU;
    MU = 1;
    
    global ALPHA;
    ALPHA = 1;
    
    % Initialize the initial conditions of the simulation
    % We make the matrix a global variable to simulate pass-by-reference
    global matrix;
    matrix = initializeMatrix([MATRIX_SIZE, MATRIX_SIZE], NUMBER_OF_PEOPLE);

    % =============================== TEST ===============================
    
    % This is a temporary way to plot the data
    
    [X, Y] = getXY();
    
    disp(size(X));
    disp(size(Y));
    
    p = scatter(X, Y);
    axis([0, SECTOR_SIZE * MATRIX_SIZE, 0, SECTOR_SIZE * MATRIX_SIZE]);

    axis off;
    
    % We run the simulation endlessly
    while true
        runOneTimestep();
        [X, Y] = getXY();
        set(p, 'XData', X, 'YData', Y);
        drawnow;
    end
    
    % ====================================================================
    
    % TEST (old)
    
%     runOneTimestep();
%     
%     for i = 1:matrix.length
%         for j = 1:matrix(i).length
%             disp('Position: ');
%             disp([i, j]);
%             list = matrix(i, j);
%             itr = list.iterator();
%             while itr.hasNext()
%                 individual = itr.next();
%                 disp(individual');
%             end
%         end
%     end
    

end

