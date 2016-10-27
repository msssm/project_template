% Modelling Social Systems with Matlab
% Group: Resilience and Survivability of Complex Networks
% Author: Backes Thierry
% Scale-Free Network by Barbasi Albert Algorithm
function barabasi_albert(N, m_0, m, a)
    % N: Total number of nodes
    % m_0: Initial number of nodes
    % m (<= m_0): connectivity of the new added node
G = graph;
G = addnode(G,m_0);
%connect m_0 seed nodes
for j = 1:m_0-1
    for k = j+1:m_0
        G = addedge(G,j,k);
    end
end

plot(G);
k = 0;
%add N-m_0 total nodes
for i=1:(N-m_0)
    G=addnode(G,1); %at every timestep, add one node
    
    while(k < m)
        target_node = randi(numnodes(G)-1);
        random_value = unifrnd(0,1);
        p=(degree(G,target_node)/(numedges(G)^2))^a;
        if(p > random_value)
            if(findedge(G,numnodes(G),target_node) == 0)
                G = addedge(G,numnodes(G),target_node); 
                k = k+1;
                plot(G);
                drawnow;
            end
        end    
    end
    k = 0;
    %k = randi(m); %every node is conneted to 
end
G.Nodes;
numnodes(G);
numedges(G);
plot(G);
end
