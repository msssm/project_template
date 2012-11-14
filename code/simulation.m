function [A_adj, g] = simulation(A_adj, g, N, M, phi)
%SIMULATION Executes the simulation steps in a given network
%   Takes an adjencency matrix A_adj and an opinion vector g and also the
%   parameters N and M and phi
%   Applies iterative rules, alternating opinions and network
%   When steady state is reached: Returns network and opinion vector.


%while(true)    %Later: execute the whole thing until convergent state is
%reached
    


i = randi(N,1)     %Picking a random node i out of N nodes

if sum(A_adj(i,:)) ~= 0     %calculate degree of ith node. If not zero, do following step
    
    i_cluster = find(A_adj(i,:))   %A vector of nodes that are connected to i
    j = i_cluster(randi(length(i_cluster)))  %Choose a random node j connected to i its neighbor to be interacted with
    %Revise this line for speed, there must be a better way  
    
    if rand<phi             %with probability phi, reconnect
        
        
      
        g_idx = find(g == g(i));  %Find nodes that have the same opinion as i and store their INDEX in a vector 
        i2 = randi(length(g_idx))  %Choose a random element from index vector g_idx,
                                  %assign the corresponding value to i2,
                                  %which is also an index of g (a node)
                                  
        %reconnect i with i2
        %Should the reconnection only occur if opinions differ?
        if A_adj(i,i2) ~= 1     %We should only reconnect if i and i2 are not already connected! Otherwise, skip step and do nothing
                                %just to be sure we don't delete any links
                                %Possibly find a better way to do this
                                %I thought about a while loop looking for
                                %alternative non-existing links, but I'd
                                %rather not get trapped in it.
                                
            A_adj(i,j) = 0;     %Delete "old" connection"
            A_adj(j,i) = 0;
            A_adj(i,i2) = 1;    %Add new connection
            A_adj(i2,i) = 1;
        end
        
        
    else        %If reconnection is not chosen, adjust opinions
        
        g(j) = g(i);  %Set opinion of neighbor j to opinion of i
        %This needs to be confirmed still!
        
        
    end
    
end
    
    
    
%end

end

