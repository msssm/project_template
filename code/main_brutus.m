%%% The main script from which all functions are called

clear;

for NN = [200]              %Iterate over different system sizes (number of nodes)
    %% INITIAL PARAMETERS
    
    %External parameters (use for phase diagram later)
    k_avg_set = 4;  %wanted average degree
    gamma = 10;     %wanted average number of people per opinion
    N=NN;
    ii = 2;         %Number of iterations used for the averaging loop
    
    %Calculate other parameters based on this
    M = k_avg_set*N/2;  %number of edges
    G = N/gamma;        %number of opinions
    
  
    
    %% GENERATING OPINION GRAPH
    
    %Generate bare graph first
    p_connect = (2*M)/(N*(N-1));        %probability of connection in a random graph given by lecture notes:
    A_sp = random_graph(N, p_connect);  %Generate random graph as sparse adjacency matrix
    k_avg = sum(sum(A_sp))/N;           %Compute actual avg degree of generated graph to compare with set degree
    AA_sp=A_sp;                         %Store A_sp into AA_sp that will be unaffected by the averaging-loop, retaining the initial matrix
    
    %Generate opinion vector
    g = randsample(G,N,true);           %Nx1 vector filled with rand ints from 1 to G with replacement=true
    gg=g;                               %Store g into gg that will be unaffected by the averaging-loop
    

%% AVERAGING LOOP FOR GRAPH SIMULATION
%Lets the simulation run several times starting from the SAME rand graph
%given by AA_sp.

    for phi=[0.1:0.1:0.2]  %Iterate of different probabilities of reconnection. Different phi will be used for the SAME initial graph.
        
        %Write strings with relevant data for documentation
        str2=['N',num2str(N),'k',num2str(k_avg_set),'gamma',num2str(gamma),'Phi',num2str(phi),'Runs',num2str(ii)]; %Shorter string for SAVEDATA

        %%Prepare simulation
        s_sum=zeros(1,N);       %Initialize sum for calculating the average of s (cluster size distribution vector)
        s=cell(ii,1);           %Create cell with one matrix stored into cell element for each run. Needed for averaging.
        op=0;                   %Initialize order parameter for averaging.
        tt=zeros(ii,1);         %Create vector that contains convergence time for each run.

        %%Run simulation
        for i=1:ii
            [A_sp, g,t] = simulation2(AA_sp, gg, N, phi);                     %Return upfolderd connections (A_adj)and opinions (g), always starting from the initial AA-adj and gg!
            ss=clustersize_distr(A_sp);                %Generate s-vector from g-vector. ss is intermediate variable because s is occupied by s-cell.
            s{i}=horzcat(ss,zeros(1,N-length(ss))); %Concatenate zeros to s-vector to ensure that s is of dimension N. This is crucial for being able to add them up and then averaging them! Adding zeros simply means that there are no bigger clusters than the biggest one. The possibly biggest cluster is of size N.
            op=op+find(s{i}, 1, 'last' )/N;
            s_sum=s_sum+s{i};                       %Do the summation.
            tt(i)=t;                                %Filling vector of convergence time.
        end
        op=op/ii;
        tau=sum(tt)/ii;                             %Calculate average convergence time for a specific N and Phi.
        s_avg=s_sum/ii;
        
        %% SAVE RESULTS FOR BRUTUS
        %clear i s_sum ss phi; %Check this here!
        save([str2,'.mat']);
    end
end