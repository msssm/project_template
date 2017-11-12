function runOneTimestep()
%RUNONETIMESTEP Runs one timestep of the simulation.
%   Updates all the individuals in the position matrix according to the
%   model from the paper. 
    
    global matrix;
    
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
                % O(1).
                itr.remove();
                %initialize
                Forces = zeros(2,1)            %sum over forces   
                sumOverVelocities = zeros(2,1) % For calculating the flocking effect
                neighbours = getNeighbors(individual)
                position = getPosition(individual)
                velocity = getVelocity(individual)
                r0=1 %TODO: set variables ro, epsilon, my , alpha, dt
                epsilon=1
                alpha=1
                dt=1
                my=1
                itr_neighbours = neighbours(i, j).iterator();
                % ******definition of the forces******
                while itr1_neighbours.hasNext()
                    neighbour = itr_neighbours.next();
                    positionNeighbour = getPosition(neighbour)
                    velocityNeighbour = getVelocity(neighbour)
                    
                    distance  =distance(individual,neighbour)
                    %repulsive Force
                    F+= epsilon*(1-distance/(2*ro))**(5/2)*(positionNeighbour-position)/distance
                    %propulsion
                    F+= my*(velocityIndividual-velocityNeighbour)*velocityNeighbour/length(velocityNeighbour)
                    %velocity summation
                    sumOverVelocities+= velocityNeighbour
                end
                %Flocking
                F+= alpha*sunOverVelocities/length(sumOverVelocities)
                %add noise
                F+= 0
                
                
                %******calculate timestep******
                %using the leap-frog method to integrate the differential
                %equation
                %differential equation d^2y/dt^2=rhs(y)
                function [righthandside] = rhs(F)
                    righthandside = F
                end
                
                %shifted initial velocity for leap-frog
                v_temp = velocity+0.5*dt*rhs(position)
                %timestep
                         
                individual(1:2) = position+dt*v_temp
                individual(3:4) = v_temp+h*rhs(positionUpdated)/2
                

                
                
                
                itr.add(individual);
            end
        end
    end
end
