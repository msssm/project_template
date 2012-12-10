%%% The main script from which all functions are called

clear;

%Specify inputs here
N_input = [400];
%phi_input = [0.0:0.05:0.30 0.31:0.01:0.54 0.55:0.05:0.95];
phi_input = [0.46:0.01:0.54];
ii = 200;         %Number of iterations used for the averaging loop
k_avg_set = 4;  %wanted average degree
gamma = 10;     %wanted average number of people per opinion

for NN = N_input              %Iterate over different system sizes (number of nodes)
    %% INITIAL PARAMETERS
    
    %External parameters (use for phase diagram later)
    N=NN;
    
    %Calculate other parameters based on this
    M = k_avg_set*N/2;  %number of edges
    G = N/gamma;        %number of opinions
    
    %folder=[num2str(now),'/']; %Name folder to current date and time (serial date number format!) to be created in Data. Folders created for different N and phi will be put in 'folder'.
    
    
    %% GENERATING OPINION GRAPH
    
    %Generate bare graph first
    %p_connect = (2*M)/(N*(N-1));        %probability of connection in a random graph given by lecture notes:
    A_sp = uniform_random_graph(N,M);  %Generate random graph as sparse adjacency matrix
    k_avg = sum(sum(A_sp))/N;           %Compute actual avg degree of generated graph to compare with set degree
    AA_sp=A_sp;                         %Store A_sp into AA_sp that will be unaffected by the averaging-loop, retaining the initial matrix
    
    %Generate opinion vector
    g = randsample(G,N,true);           %Nx1 vector filled with rand ints from 1 to G with replacement=true
    gg=g;                               %Store g into gg that will be unaffected by the averaging-loop
    

%% AVERAGING LOOP FOR GRAPH SIMULATION
%Lets the simulation run several times starting from the SAME rand graph
%given by AA_sp.
        


    for phi=phi_input  %Iterate of different probabilities of reconnection
        
        %Write strings with relevant data for documentation
        str=['N = ',num2str(N),char(10),'k = ',num2str(k_avg_set),char(10),'\gamma = ',num2str(gamma),char(10),'\Phi = ',num2str(phi),char(10),'Runs = ',num2str(ii)]; %String for figure legend
        str2=['N',num2str(N),'k',num2str(k_avg_set),'gamma',num2str(gamma),'Phi',num2str(phi),'Runs',num2str(ii)]; %Shorter string for SAVEDATA
        

        %%Prepare simulation
        
        s_sum=zeros(1,N);       %Initialize sum for calculating the average of s (cluster size distribution vector)
        s=cell(ii,1);           %Create cell with one matrix stored into cell element for each run. Needed for averaging.
        op=0;                   %Initialize order parameter for averaging.
        tt=zeros(ii,1);         %Create vector that contains convergence time for each run.

        %%Run simulation
        for i=1:ii
            status = ['Run ', num2str(i),' of ', num2str(ii), ' at phi = ', num2str(phi), ' and N = ', num2str(N)]       %Some status info printed to screen while simulation is running
            [A_sp, g,t] = simulation2(AA_sp, gg, N, phi);                     %Return upfolderd connections (A_adj)and opinions (g), always starting from the initial AA-adj and gg!
            
            %This is now the NEW clustersize_distr which takes the sparse
            %matrix, not the opinion vector!
            ss=clustersize_distr(A_sp);                %Generate s-vector from g-vector. ss is intermediate variable because s is occupied by s-cell.
 
            s{i}=horzcat(ss,zeros(1,N-length(ss))); %Concatenate zeros to s-vector to ensure that s is of dimension N. This is crucial for being able to add them up and then averaging them! Adding zeros simply means that there are no bigger clusters than the biggest one. The possibly biggest cluster is of size N.
            op=op+find(s{i}, 1, 'last' )/N;
            s_sum=s_sum+s{i};                       %Do the summation.
            tt(i)=t;                                %Filling vector of convergence time.
            %loglog(s{i},'o');hold all;grid on;      %Leave this command to be able to plot s for each run such that the s_avg can be compared to it.
        end
        op=op/ii;
        char 'Simulation done!'
       

        %% PLOT AND SAVE RESULTS
        s_avg=s_sum/ii;                         %Calculate the average cluster size distribution vector.
        %createfigure(s_avg,str,str2);           %Second argument gives input for legend. Third argument (string) gives directory for the saving the figure.
        %clear A_sp g i s_sum ss str t; %Clear all the intermediate or elsewhere-saved variables, before saving all data.
        save(['Data/',str2,'.mat']);  %Save all relevant variables into a matlab file.

    end
end