% Modelling Social Systems with Matlab
% Group: Resilience and Survivability of Complex Networks
% Author: Backes Thierry
% Random Network
function random_network(n, p)
G = graph;
G = addnode(G,n);
for i=1:n
    for j=1:n
        random_value = rand;
        if((random_value < p) && (j~=i))
            if(findedge(G,i,j) == 0)
                G = addedge(G,i,j);   
            end
        end
    end
end
plot(G);
end
