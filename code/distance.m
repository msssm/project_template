function distance = distance(individual1, individual2)
%DISTANCE Gets the distance between two individuals.
    x1 = individual1(1);
    y1 = individual1(2);
    x2 = individual2(1);
    y2 = individual2(2);
    
    dx = x1 - x2;
    dy = y1 - y2;
    
    distance = sqrt(dx*dx + dy*dy);
end
