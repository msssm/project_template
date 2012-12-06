function [A_sp,g,t] = multi_simulation2(A_sp, g, N, phi)
%SIMULATION Executes the simulation steps in a given network
%   Takes an adjencency matrix A_sp and an opinion vector g and also the
%   parameters N and M and phi
%   Applies iterative rules, alternating opinions and network
%   When steady state is reached: Returns network and opinion vector.

%MULTI EDIT: This version allows for self-edges and multi-edges

t = 0;

abort = false;      
%Boolean to stop the simulation loop. Will be set to true when convergent state is reached

%while(counter < 100000)
while(abort == false)
    
%% Determining whether convergent state has been reached:
%%SUGGESTION: Write convergence check into a different function.
    %If so, abort variable will be set to true and while loop is broken on the
    %next iteration
    %This mechanism seems to work, but was only tested stichprobenartig
    for i = 1:N       %Loop through all nodes     
    %Strategy: As soon as one pair of neighboring nodes have different
    %opinions, break the consensus-check loop and continue updating.
        unequal = false;    
        %By "default" assume that there are no different opinions between
        %two neighbors. We will check all connections and set unequal to
        %true if differing opinions exist.

        for neighbor = find(A_sp(i,:));    
            %Loop through Vector of neighbors of current i (entries that are
            %non-zero --> there is a neighbor)
            if g(i) ~= g(neighbor) %Compare g(i) with one of its neighbors.
                %if the opinions are DIFFERENT break both loops and don't
                %change the abort variable since at least one neighbor has a
                %different opinion and we will continue the big while loop
                unequal = true;     %Using this variable, we denote an unequal event
                                    %and break INNER loop
                break

            end

        end
        
        if unequal == true      %If different opinions of neighbors were detected, also break the OUTER loop
            break
        end

        
    end
    
    %Now we've gone through all nodes and are able to check for consensus:
    
        if unequal == false         
        %If no different opinions of neighbors were ever detected and unequal is still false
        %--> set abort to true such that while loop will break on next
        %iteration
            abort = true;
        end
 
        
%% Time evolution

    t = t + 1;

    i = randi(N);     %Picking a random node i out of N nodes (Returning a random 1x1 matrix with entry form 1:N) 
    if sum(A_sp(i,:)) ~= 0     %calculate (DOUBLE-)degree of ith node. If not zero (i.e. if its conncted to SOMEBODY), do following step

        i_cluster = find(A_sp(i,:));   %A vector of nodes that are connected to i (Find nonzero cells in i-th row and return a col-vec with their indices)
        j = i_cluster(randi(length(i_cluster)));  %Choose a random node j connected to i its neighbor to be interacted with 
        
        if g(i)==g(j) 
            continue %If opinions are the same jump to next step in while-loop, i.e. choose new i-j pair.
        end 
        
        %At this point we have randomly chosen a node i and one of its
        %neighbours j. Now let them interact:
        
        %BEFORE, we should check if both i and j have the same opinion. If
        %they do, another j should be chosen! Make for-loop for finding a j
        %of different opinion. This would go forever if we are already in
        %a consensus state. Therefore check before choosing i and j!
        
        if rand<phi            %with probability phi, reconnect

            g_idx = find(g == g(i));  %Find nodes that have the same opinion as i and store their INDEX in a col-vector 
            i2 = g_idx(randi(length(g_idx)));  %Choose a random element from index vector g_idx assign the corresponding value to i2 (= choosing random node with same opinion), which is also an index of g (a node)
            %IDEA for not choosing an i2 that i is already connected to:
            %Take i-th row and produce index-vector of ZERO cells. From
            %this vector choose the nodes of same opinion!
            
            %reconnect i with i2
            %Here the multi/self change takes effect: We do not have an
            %additional if statement

            %Analogous to the graph generator: 
            %If i and i2 are the same (self-edge will be created) only increment the one diagonal
            %entry. However, you have to delete both entries of the i,j
            %pair since i and j are by definition never equal!
            if i == i2
            
                A_sp(i,j) = A_sp(i,j) - 1;     %Delete "old" connection"
                A_sp(j,i) = A_sp(j,i) - 1;
                
                A_sp(i,i2) = A_sp(i,i2) + 1;    %Add new connection
            
            else
                A_sp(i,j) = A_sp(i,j) - 1;     %Delete "old" connection"
                A_sp(j,i) = A_sp(j,i) - 1;

                A_sp(i,i2) = A_sp(i,i2) + 1;    %Add new connection
                A_sp(i2,i) = A_sp(i2,i) + 1;
            end


        else        %If reconnection is not chosen, adjust opinions

            g(i) = g(j);  %Set opinion of i to opinion of neightbor j

        end

    end
    
    
end
t 
%This is the convergence time! This should in fact also be returned!
end

