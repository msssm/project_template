function [sector] = sectorForCoords(individual)
%SECTORFORCOORDS Gets which sector an individual is in based on coords.

    global SECTOR_SIZE;
    global MATRIX_SIZE;
    
    x = individual(1) / SECTOR_SIZE;
    y = individual(2) / SECTOR_SIZE;
    
    if x < 0
        x = 0;
    elseif x >= MATRIX_SIZE
        x = MATRIX_SIZE - 1;
    end
    
    if y < 0
        y = 0;
    elseif y >= MATRIX_SIZE
        y = MATRIX_SIZE - 1;
    end
    
    sector = floor([x; y]);
    sector = sector + [1; 1];
end

