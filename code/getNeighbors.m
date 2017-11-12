function [individuals] = getNeighbors(individual)
%GETNEIGHBORS Gets the neighbors of the given individual
%   Gets the neighbors of an individual in the radius specified by the
%   NEIGHBOR_SEARCH_RADIUS global. Returns these individuals as columns in
%   a matrix.

    individuals = [];

    global NEIGHBOR_SEARCH_RADIUS;
    global matrix;

    % Get location of the individual
    coords = [individual(1), individual(2)];
    sector = sectorForCoords(coords);
    
    % Get the sectors where we need to search
    sectorsToSearch = [sector];
    northSector = sectorForCoords(coords - [0, NEIGHBOR_SEARCH_RADIUS]);
    if ~isequal(northSector, sector)
        sectorsToSearch = [sectorsToSearch, northSector];
    end
    
    southSector = sectorForCoords(coords + [0, NEIGHBOR_SEARCH_RADIUS]);
    if ~isequal(southSector, sector)
        sectorsToSearch = [sectorsToSearch, southSector];
    end
    
    westSector = sectorForCoords(coords - [NEIGHBOR_SEARCH_RADIUS, 0]);
    if ~isequal(westSector, sector)
        sectorsToSearch = [sectorsToSearch, westSector];
    end
    
    eastSector = sectorForCoords(coords + [NEIGHBOR_SEARCH_RADIUS, 0]);
    if ~isequal(eastSector, sector)
        sectorsToSearch = [sectorsToSearch, eastSector];
    end
    
    northEastSector = sectorForCoords(coords + [NEIGHBOR_SEARCH_RADIUS, -NEIGHBOR_SEARCH_RADIUS]);
    if ~isequal(northEastSector, sector)
        sectorsToSearch = [sectorsToSearch, northEastSector];
    end
    
    northWestSector = sectorForCoords(coords + [-NEIGHBOR_SEARCH_RADIUS, -NEIGHBOR_SEARCH_RADIUS]);
    if ~isequal(northWestSector, sector)
        sectorsToSearch = [sectorsToSearch, northWestSector];
    end
    
    southEastSector = sectorForCoords(coords + [NEIGHBOR_SEARCH_RADIUS, NEIGHBOR_SEARCH_RADIUS]);
    if ~isequal(southEastSector, sector)
        sectorsToSearch = [sectorsToSearch, southEastSector];
    end
    
    southWestSector = sectorForCoords(coords + [-NEIGHBOR_SEARCH_RADIUS, NEIGHBOR_SEARCH_RADIUS]);
    if ~isequal(southWestSector, sector)
        sectorsToSearch = [sectorsToSearch, southWestSector];
    end
        
    disp(sectorsToSearch);
    
    % Search over those vectors
    for k = 1:2:size(sectorsToSearch, 2)
        i = sectorsToSearch(k);
        j = sectorsToSearch(k+1);
        itr = matrix(i, j).iterator();
        while itr.hasNext()
            person = itr.next();
            if distance(individual, person) <= NEIGHBOR_SEARCH_RADIUS
                individuals = [individuals, person];
            end
        end
    end
end
