%%% The main script from which all functions are called

clear;

%Set k and gamma and node number as initial parameters
k_avg_set = 4;  %wanted average degree
gamma = 10;     %wanted gamma
N = 3000;        %number of nodes

% Calculate other parameters based on this
M = k_avg_set*N/2;  %number of edges
G = N/gamma;    %number of opinions

p_connect = (M)/(N*(N-1)); % --> probability of connection given by lecture notes:


for phi = 0.1:0.1:0.9

    phi
    % Generating graph
    A_sp = random_graph(N, p_connect);  %Generate random graph as sparse matrix
    A_adj = full(A_sp);                 %Same graph as an adjacency 
    k_avg = 2*sum(sum(A_adj))/N;        %Compute avg degree to compare with set degree



    %Generating opinion vector
    %Nx1 vector filled with rand ints from 1 to G with replacement=true
    g = randsample(G,N,true);

    %csvwrite('input.csv', A_adj);       %writing inital graph to file



    %Run simulation
    [A_adj, g] = simulation(A_adj, g, N, phi);

    csvwrite(['output_matrix_phi=' num2str(phi) 'N = ' num2str(n) '.csv'], A_adj);      %writing "developed" graph to file
    csvwrite(['output_opinions_phi=' num2str(phi) 'N = ' num2str(n) '.csv'], g);

    hist(cluster_distr(g), length(g))   %generate histogram of cluster size distribution (fig 2 in paper)
    title(['Histogram at \phi = ' num2str(phi) 'N = ' num2str(N)]);
    
end


