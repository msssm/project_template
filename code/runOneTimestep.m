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
                
                % TODO: Perform update of individual here
                
                itr.add(individual);
            end
        end
    end
end
