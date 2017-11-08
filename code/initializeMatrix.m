

function [matrix] = initializeMatrix(resolution)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    % Initialize a matrix of the proper size
    width = resolution(1);
    height = resolution(2);
    matrix = javaArray('java.util.ArrayList', width, height);

    for i = 1:width
        for j = 1:height
            matrix(i, j) = javaObject('java.util.ArrayList');
        end
    end
    
    for i = 1:width
        for j = 1:height
            % TODO:
            % - Add random number of people per sector
            % - Initialize positions and speeds of people
            % - Decide which people are participating
            matrix(i, j).add(createIndividual(0, 0, 0, 0, FALSE));
        end
    end
    
return;



