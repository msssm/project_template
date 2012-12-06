%% Specify the set to be checked
clear;
N=500;
k_avg_set=4;
gamma=10;
phi=0.5;
i=7;
ii=10;
str2=['N',num2str(N),'k',num2str(k_avg_set),'gamma',num2str(gamma),'Phi',num2str(phi),'Runs',num2str(ii)]; %Shorter string for SAVEDATA
str=['N = ',num2str(N),char(10),'k = ',num2str(k_avg_set),char(10),'\gamma = ',num2str(gamma),char(10),'\Phi = ',num2str(phi),char(10),'Runs = ',num2str(ii)]; %String for figure legend
str2='N500k3.824gamma10Phi0.7Runs10'; %This line can be used as alternative to setting all variables above manually.

%% Network checks
%(Un-)comment the following lines to check the network of different runs:
A=csvread(['Data/',str2,'/AdjIni.csv']);
%A=csvread(['Data/',str2,'/AdjRun',num2str(i),'.csv']);
g=csvread(['Data/',str2,'/OpiIni.csv']);
%g=csvread(['Data/',str2,'/OpiRun',num2str(i),'.csv']);
k_avg = sum(sum(A))/N %Check degree of network.
createfigure(clustersize_distr(g),str,str2); %Check clustersize distribution of network
