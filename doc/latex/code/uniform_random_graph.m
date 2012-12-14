function [A_sp] = uniform_random_graph(N,M)
% Generates a random graph of NxN nodes and M connections

A_sp = sparse(zeros(N));    %Empty sparse NxN matrix

M_counter = 1;              %Counter going through ints

while(M_counter <= M)
    %Loop to set random connections
    %It does not stop until M connections have been set, hence the use of a
    %counter in a while loop: 

    %Pick random nodes
    i = randi(N);
    j = randi(N);
    
    %If diagonal entry or connection already exists --> do nothing an
    %continue loop at next iteration, do not increment counter
    if i == j || A_sp(i,j) == 1
        continue
        
    %Else set connection from i to j (both entries)
    else
        A_sp(i,j) = 1;
        A_sp(j,i) = 1;
        
        %Increment counter to indicate that a connection has been set.
        M_counter = M_counter + 1;
    
    end
end
end