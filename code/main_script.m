%%% This is the main script from which all functions are called.
%Functions that are called are "uniform_random_graph(N,M)",
%"simulation2(AA_sp, gg, N, phi)" and "clustersize_distr". This script saves a matlab-file with all
%relevant data.

clear;

%% INITIAL PARAMETERS
N_input = [400];    %Network sizes(number of nodes)
phi_input = [0.0:0.05:0.20 0.21:0.01:0.54 0.55:0.05:0.95]; %Phi range
ii = 200;           %Number of iterations used for the averaging loop
k_avg_set = 4;      %Wanted average degree
gamma = 10;         %Wanted average number of people per opinion

for NN = N_input    %Iterate over different network sizes (number of nodes)
    
    %Calculate other parameters based on initial parameters
    N=NN;               %Set current NN-value to N for further calculations
    M = k_avg_set*N/2;  %Wanted umber of edges
    G = N/gamma;        %Number of opinions
    
    
    %% GENERATING OPINION GRAPH
    
    %Generate bare graph first
    A_sp = uniform_random_graph(N,M);   %Generate random graph as sparse adjacency matrix
    k_avg = sum(sum(A_sp))/N;           %Compute actual avg degree of generated graph to compare with set/wanted degree
    AA_sp=A_sp;                         %Store A_sp into AA_sp that will be unaffected by the averaging-loop, retaining the initial matrix
    
    %Generate opinion vector
    g = randsample(G,N,true);           %Nx1 vector filled with rand ints from 1 to G with replacement=true
    gg=g;                               %Store g into gg that will be unaffected by the averaging-loop
    

%% AVERAGING LOOP FOR GRAPH SIMULATION
%Let's the simulation run several times starting from the SAME random
%network given by AA_sp and gg.
        
    for phi=phi_input  %Iterate for different reconnection probabilities
        
        %Write strings with relevant data for documentation
        str=['N',num2str(N),'k',num2str(k_avg_set),'gamma',num2str(gamma),'Phi',num2str(phi),'Runs',num2str(ii)]; %Shorter string for the file name.
        
        %Prepare simulation        
        s_sum=zeros(1,N);       %Initialize sum for calculating the average of s (cluster size distribution vector)
        s=cell(ii,1);           %Create cell with one matrix stored into cell element for each run. Needed for averaging.
        op=0;                   %Initialize order parameter for averaging.
        tt=zeros(ii,1);         %Create vector that contains convergence time for each run.

        %Run simulation
        for i=1:ii
            %Some status info printed to screen while simulation is running
            status = ['Run ', num2str(i),' of ', num2str(ii), ' at phi = ', num2str(phi), ' and N = ', num2str(N)]   

            [A_sp, g,t] = simulation(AA_sp, gg, N, phi); %Return connections (A_adj), opinions (g) and convergence time (t) of the consensus state, always starting from the initial AA-adj and gg!
            ss=clustersize_distr(A_sp);             %Generate s-vector from adjacency matrix. For this ONLY connections, not specific opinions, matter! ss is intermediate variable because s is occupied by s-cell.
            s{i}=horzcat(ss,zeros(1,N-length(ss))); %Concatenate zeros to s-vector to ensure that s is of dimension N. This is crucial for being able to add them up and then averaging them! Adding zeros simply means that there are no bigger clusters than the biggest one. The possibly biggest cluster is of size N.
            op=op+find(s{i}, 1, 'last' )/N;         %Calculate order parameter from each s{i}-value by storing the index, i.e. s-value, of the "1" "'last'" cell that is not zero.
            s_sum=s_sum+s{i};                       %Do the summation
            tt(i)=t;                                %Fill vector of convergence time needed for mean and standard deviation calculations
            %loglog(s{i},'o');hold all;grid on;     %Leave this command to be able to plot s for each run such that the s_avg can be compared to it.
        end
        
        char 'Simulation done!'
       

        %% PLOT AND SAVE RESULTS
        
        op=op/ii;                    %Calculate the average order parameter value
        s_avg=s_sum/ii;              %Calculate the average cluster size distribution vector
        save(['Data/',str,'.mat']);  %Save all relevant variables into a matlab file.

    end
end