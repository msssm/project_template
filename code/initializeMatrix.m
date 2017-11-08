

function [matrix] = initializeMatrix(resolution)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    % Initialize a matrix of the proper size
    width = resolution(1);
    height = resolution(2);
    matrix = zeros(width, height);

    for i = 1:width
        for j = 1:height
            matrix(i, j) = java.util.ArrayList();
        end
    end

return;



