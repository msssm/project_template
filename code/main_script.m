%%% The main script from which all functions are called

matlabpool open 2       %Open parallel computing session for N cores

clear;

%for N = 500              %Iterate over different system sizes (number of nodes)

%for PHI=0.4:0.1:0.5  %Iterate of different probabilities of reconnection
parfor PHI=2:1:3
    %% INITIAL PARAMETERS
    
    
    %External parameters (use for phase diagram later)
    k_avg_set = 4;  %wanted average degree
    gamma = 10;     %wanted average number of people per opinion
    N = 500;        %number of nodes
    ii = 100;         %Number of iterations used for the averaging loop
    
    %phi = PHI;      %Reconnection probability
    phi = PHI/10;   %Recalculate phi when parfor is active (since parfor requires consecutive int values)
    
    %Calculate other parameters based on this
    M = k_avg_set*N/2;  %number of edges
    G = N/gamma;        %number of opinions
    
    
    
    
    %% GENERATING OPINION GRAPH
    
    %Generate bare graph first
    p_connect = (M)/(N*(N-1));          %probability of connection in a random graph given by lecture notes:
    A_sp = random_graph(N, p_connect);  %Generate random graph as sparse adjacency matrix
    k_avg = 2*sum(sum(A_sp))/N;         %Compute actual avg degree of generated graph to compare with set degree
    AA_sp=A_sp;                         %Store A_sp into AA_sp that will be unaffected by the averaging-loop, retaining the initial matrix
    
    %Generate opinion vector
    g = randsample(G,N,true);           %Nx1 vector filled with rand ints from 1 to G with replacement=true
    gg=g;                               %Store g into gg that will be unaffected by the averaging-loop
    
    %Write strings with relevant data for documentation
    str=['N = ',num2str(N),char(10),'k = ',num2str(k_avg),char(10),'\gamma = ',num2str(gamma),char(10),'\Phi = ',num2str(phi),char(10),'Runs = ',num2str(ii)]; %String for figure legend
    str2=['N',num2str(N),'k',num2str(k_avg),'gamma',num2str(gamma),'Phi',num2str(phi),'Runs',num2str(ii)]; %Shorter string for SAVEDATA
    
    
    
    
    %% AVERAGING LOOP FOR GRAPH SIMULATION
    %Lets the simulation run several times starting from the SAME rand graph
    %given by AA_sp.
    
    %%Prepare simulation
    mkdir('Data/',str2);    %Create a folder for this particular run.
    csvwrite(['Data/',str2,'/AdjIni.csv'],full(AA_sp));       %Write inital adjacency to file
    csvwrite(['Data/',str2,'/OpiIni.csv'],gg);                %Write inital opinions to file
    s_sum=zeros(1,N);       %Initialize sum for calculating the average of s (cluster size distribution vector)
    s=cell(ii,1);           %Create cell with one matrix stored into cell element for each run. Needed for averaging.
    tt=zeros(ii,1);         %Create vector that contains convergence time for each run.
    
    %%Run simulation
    char 'Starting simulation:'
    for i=1:ii
        status = ['Run ', num2str(i),' of ', num2str(ii), ' at phi = ', num2str(phi)]       %Some status info printed to screen while simulation is running
        [A_sp, g,t] = simulation(AA_sp, gg, N, phi);                     %Return updated connections (A_adj)and opinions (g), always starting from the initial AA-adj and gg!
        %Fabian: I commented these for the case of averaging over larger numbers
        %csvwrite(['Data/',str2,'/AdjRun',num2str(i),'.csv'],full(A_sp));    %Write "developed," i.e. consensus, graph to file
        %csvwrite(['Data/',str2,'/OpiRun',num2str(i),'.csv'],g);             %Write "developed," i.e. consensus, graph to file
        ss=clustersize_distr(g);                %Generate s-vector from g-vector. ss is intermediate variable because s is occupied by s-cell.
        s{i}=horzcat(ss,zeros(1,N-length(ss))); %Concatenate zeros to s-vector to ensure that s is of dimension N. This is crucial for being able to add them up and then averaging them! Adding zeros simply means that there are no bigger clusters than the biggest one. The possibly biggest cluster is of size N.
        s_sum=s_sum+s{i};                       %Do the summation.
        tt(i)=t;                                %Filling vector of convergence time.
        %loglog(s{i},'o');hold all;grid on;      %Leave this command to be able to plot s for each run such that the s_avg can be compared to it.
    end
    char 'Simulation done!'
    
    
    
    %% PLOT AND SAVE RESULTS
    s_avg=s_sum/ii;                         %Calculate the average cluster size distribution vector.
    createfigure(s_avg,str,str2);           %Second argument gives input for legend. Third argument (string) gives directory for the saving the figure.
    clear AA_sp A_sp gg g i s_sum ss str t; %Clear all the intermediate or elsewhere-saved variables, before saving all data.
    save(['Data/',str2,'/AllFinVar.mat']);  %Save all relevant variables into a matlab file.
    
end
%end

matlabpool close