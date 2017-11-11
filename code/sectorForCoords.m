function [sector] = sectorForCoords(individual)
%SECTORFORCOORDS Gets which sector an individual is in based on coords.
    clc;

    global SECTOR_SIZE;

    x = individual(1);
    y = individual(2);
    
    sector = floor([x / SECTOR_SIZE, y / SECTOR_SIZE]);
    sector = sector + [1, 1];
end

