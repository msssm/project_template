function [A_sp] = multi_uniform_random_graph(N,M)
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
    
    %If i and j are the same (self-edges) only change the one diagonal
    %entry
    if i == j
        A_sp(i,j) = A_sp(i,j) + 1;
    
    %Else if they are different, change both the i,j and the j,i entry,
    %keeping the edges undirected and the matrix symmetric.
    else
        A_sp(i,j) = A_sp(i,j) + 1;
        A_sp(j,i) = A_sp(j,i) + 1;
        
    end
    
    %Increment counter to indicate that a connection has been set.
    M_counter = M_counter + 1;
    
      
    
end



end

