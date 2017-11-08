

function [matrix] = initializeMatrix(resolution, numberOfPeople)
%INITIALIZEMATRIX Initializes the position matrix used by the simulation.
%   The matrix is a low-resolution representation of the people at the
%   concert and is divided into "sectors". Each sector can contain several
%   people (whose position is defined by their x and y coordinates). The
%   matrix initially contains numberOfPeople people. Each sector is a
%   reference to a java.util.ArrayList which contains a list of the people
%   currently in that sector.

    % Initialize a matrix of the proper size
    width = resolution(1);
    height = resolution(2);
    matrix = javaArray('java.util.ArrayList', width, height);

    parfor i = 1:width
        for j = 1:height
            matrix(i, j) = javaObject('java.util.ArrayList', numberOfPeople/(width * height));
        end
    end
    
    parfor i = 1:width
        for j = 1:height
            % TODO:
            % - Add random number of people per sector
            % - Initialize positions and speeds of people
            % - Decide which people are participating
            matrix(i, j).add(createIndividual(0, 0, 0, 0, false));
        end
    end
    
return;



