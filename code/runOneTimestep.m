function runOneTimestep()
%RUNONETIMESTEP Runs one timestep of the simulation.
%   Updates all the individuals in the position matrix according to the
%   model from the paper. 
    
    global matrix;
    global INDIVIDUAL_RADIUS;
    global FLOCK_RADIUS;
    global EPSILON;
    global ALPHA;
    global MU;
    
    % TODO: Implement equations from model
    
    % Basic skeleton for updating the individuals
    for i = 1:matrix.length
        for j = 1:matrix(i).length
            itr = matrix(i, j).iterator();
            while itr.hasNext()
                individual = itr.next();
                
                % Since MATLAB has no support for pass-by-reference, our
                % only choice is to remove the individual from the
                % LinkedList and then add it back again. Luckily this is
                % O(1) using the iterator.
                itr.remove();
                
                % ==================== INITIALIZATION ====================
                F = zeros(2, 1);             % sum over forces   
                sumOverVelocities = zeros(2, 1);  % For calculating the flocking effect
                neighbours = getNeighbors(individual, FLOCK_RADIUS);
                position = getPosition(individual);
                velocity = getVelocity(individual);
                r0 = INDIVIDUAL_RADIUS;
                dt = 0.1;
                
                % ****** definition of the forces ******
                % ================ CALCULATING THE FORCES ================
                for k = 1:size(neighbours, 2)
                    neighbour = neighbours(:, k);
                    positionNeighbour = getPosition(neighbour);
                    velocityNeighbour = getVelocity(neighbour);
                    
                    distance1 = distance(individual, neighbour);

                    % Repulsive Force
                    % We only use neighbors within a radius of 2 * r0
                    if distance1 < 2 * r0
                        F = F + EPSILON * (1 - distance1 / (2*r0))^(5/2) * (position - positionNeighbour) / distance1;
                    end
                    
                    % Velocity summation
                    sumOverVelocities = sumOverVelocities + velocityNeighbour;
                end
                
                % Propulsion
                % 
                % TODO: v0 is the "preferred speed", vi is the
                % "instantaneous speed"
%                 F = F + MU * dot(velocity - velocityNeighbour, velocityNeighbour / length(velocityNeighbour));
                    
                % Flocking
                if ~isequal(sumOverVelocities, [0; 0])
                    F = F + ALPHA * sumOverVelocities / norm(sumOverVelocities);
                end
                % Add noise
                F = F + 0;
                
                % ****** calculate timestep ******
                % using the leap-frog method to integrate the differential
                % equation
                % differential equation d^2y/dt^2=rhs(y)
                
                % shifted initial velocity for leap-frog
                v_temp = velocity + 0.5*dt*F;
                % timestep
%                          
                individual(1:2) = position + dt*v_temp;
                individual(3:4) = v_temp + dt*F/2;
                
                % TEST
%                 individual(1:2) = individual(1:2) + individual(3:4);

                % We need to add the individual to the appropriate sector
                % Check if the sector has changed
                newSector = sectorForCoords(individual);
%                 disp(newSector);
                % If it has, add the individual to the new sector
                if ~isequal([i; j], newSector)
                    matrix(newSector(1), newSector(2)).add(individual);
                % Else, just add it back to the same sector
                else
                    itr.add(individual);
                end
            end
        end
    end
end
