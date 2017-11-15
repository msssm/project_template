function [individuals] = getNeighbors(individual, radius)
%GETNEIGHBORS Gets the neighbors of the given individual
%   Gets the neighbors of an individual in the radius specified by the
%   NEIGHBOR_SEARCH_RADIUS global. Returns these individuals as columns in
%   a matrix.

    individuals = [];

    global matrix;

    % Get location of the individual
    coords = getPosition(individual);
    sector = sectorForCoords(coords);
    
    % Get the sectors where we need to search
    sectorsToSearch = sector;
    northSector = sectorForCoords(coords - [0; radius]);
    if ~isequal(northSector, sector)
        sectorsToSearch = [sectorsToSearch, northSector];
    end
    
    southSector = sectorForCoords(coords + [0; radius]);
    if ~isequal(southSector, sector)
        sectorsToSearch = [sectorsToSearch, southSector];
    end
    
    westSector = sectorForCoords(coords - [radius; 0]);
    if ~isequal(westSector, sector)
        sectorsToSearch = [sectorsToSearch, westSector];
    end
    
    eastSector = sectorForCoords(coords + [radius; 0]);
    if ~isequal(eastSector, sector)
        sectorsToSearch = [sectorsToSearch, eastSector];
    end
    
    northEastSector = sectorForCoords(coords + [radius; -radius]);
    if ~isequal(northEastSector, sector)
        sectorsToSearch = [sectorsToSearch, northEastSector];
    end
    
    northWestSector = sectorForCoords(coords + [-radius; -radius]);
    if ~isequal(northWestSector, sector)
        sectorsToSearch = [sectorsToSearch, northWestSector];
    end
    
    southEastSector = sectorForCoords(coords + [radius; radius]);
    if ~isequal(southEastSector, sector)
        sectorsToSearch = [sectorsToSearch, southEastSector];
    end
    
    southWestSector = sectorForCoords(coords + [-radius; radius]);
    if ~isequal(southWestSector, sector)
        sectorsToSearch = [sectorsToSearch, southWestSector];
    end
            
    % Search over those vectors
    disp(size(sectorsToSearch, 2));
    for k = 1:size(sectorsToSearch, 2)
        i = sectorsToSearch(1, k);
        j = sectorsToSearch(2, k);
        itr = matrix(i, j).iterator();
        while itr.hasNext()
            person = itr.next();
            if distance(individual, person) < radius
                individuals = [individuals; person];
            end
        end
    end
end
