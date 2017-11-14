function [X, Y] = getXY()
%GETXY Gets the x and y coordinates of all the individuals for plotting.
%   Stores the x coordinates of all the individuals in X and the
%   corresponding y coordinates in Y.
%   TODO: Find a way to separate the people based on isParticipating

    global matrix;
    global NUMBER_OF_PEOPLE;
    
    X = zeros(NUMBER_OF_PEOPLE, 1);
    Y = zeros(NUMBER_OF_PEOPLE, 1);
    
    k = 1;
    
    for i = 1:matrix.length
        for j = 1:matrix(i).length
            itr = matrix(i, j).iterator();
            while itr.hasNext()
                individual = itr.next();
                position = getPosition(individual);
                X(k) = position(1);
                Y(k) = position(2);
                k = k + 1;
            end
        end
    end

end

