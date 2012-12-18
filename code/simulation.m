function [A_sp,g,t] = simulation(A_sp, g, N, phi)
%SIMULATION Executes the simulation steps in a given network
%   Takes an adjencency matrix A_sp and an opinion vector g and also the
%   parameters N and phi. It applies iterative rules, letting opinions and
%   the network itself evolve over time. When consensus state is reached, 
%   a network and opinion vector is returned.

t = 0;

abort = false; %Boolean to stop the simulation loop. Will be set to true when convergent state is reached

while(abort == false)
    
    
%% CHECKING FOR CONSENSUS STATE:

    for i = 1:N       %Loop through all nodes     
    %Strategy: As soon as one pair of neighboring nodes have different
    %opinions, break the consensus-check loop and continue updating.
        
        unequal = false;    
        %By "default" assume that there are no different opinions between
        %two neighbors. We will check all connections and set unequal to
        %true if differing opinions exist.

        for neighbor = find(A_sp(i,:));    %Loop through Vector of neighbors of current i 
            %(entries that are non-zero mean that there is a neighbor)
            
            if g(i) ~= g(neighbor) %Compare g(i) with one of its neighbors.
                %If the opinions are DIFFERENT break both loops and don't
                %change the abort variable since at least one neighbor has a
                %different opinion and we will continue the big while loop
                
                unequal = true;     
                %Using this variable, we denote an unequal event and break 
                %INNER loop
                break

            end

        end
        
        if unequal == true   
            %If different opinions of neighbors were detected, also break 
            %OUTER loop
            break
        end

        
    end
    
    %Now we've gone through all nodes and are able to check for consensus:
    
    if unequal == false         
    %If no different opinions of neighbors were ever detected and 'unequal' 
    %is still false, set 'abort' to true such that while loop will break on 
    %next iteration:
        abort = true;
    end
 
        
%% PERFORM TIME EVOLUTION

    t = t + 1;

    i = randi(N);           %Pick a random node i out of N nodes (Returning a random 1x1 matrix with entry form 1:N) 
    if sum(A_sp(i,:)) ~= 0  %Calculate (double-)degree of i-th node. If not zero (i.e. if its connected to SOMEBODY), do following step:

        i_cluster = find(A_sp(i,:));                %Creates a vector of nodes that are connected to i (Find nonzero cells in i-th row and return a col-vec with their indices)
        j = i_cluster(randi(length(i_cluster)));    %Choose a random node j that is connected to i to let i and j interact 
        
        if g(i)==g(j) 
            continue        %If opinions are the same jump to next step in while-loop, i.e. choose a new i-j pair. This leaves local consensus states untouched!
        end 
        
        %At this point we have randomly chosen a node i and one of its
        %neighbours j. Now let them interact:
        
        if rand<phi         %RECONNECT WITH PORBABILITY PHI

            g_idx = find(g == g(i));            %Find nodes that have the same opinion as i and store their INDEX in a col-vector 
            i2 = g_idx(randi(length(g_idx)));   %Choose a random element from index vector g_idx assign the corresponding value to i2 (= choosing random node with same opinion), which is also an index of g (a node)
            
            %Reconnect i with i2
            if A_sp(i,i2) ~= 1 && i ~= i2    %Reconnect only if i and i2 are not already connected AND if i is not the same i2!
                %This way a true reconnection to another node is ensured
                %(excluding self-edges!) Otherwise, skip step and do 
                % nothing such that k stays constant.

                %Store reconnection into adjacency matrix
                A_sp(i,j) = 0;     %Delete old connection
                A_sp(j,i) = 0;
                A_sp(i,i2) = 1;    %Add new connection
                A_sp(i2,i) = 1;
            end

        else      %ADJUST OPINION WITH PROBABILITY 1-PHI

            g(i) = g(j);  %Set opinion of i to opinion of neightbor j

        end

    end
    
    
end
t   %Write convergence time to mark the end of a run
end

