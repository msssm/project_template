%%%Reading csv data and plotting it

%specify the parameters that you want to read in here
phi = 0.1;
N = 100;
runs = 100;

%A_adj = csvread(['output_matrix_phi=' num2str(phi) 'N = ' num2str(N) '.csv']);
g = csvread(['output_opinions_phi=' num2str(phi) ' N = ' num2str(N) '.csv']); %reading the files while plugging in specified parameters

distr = cluster_distr(g); %generate cluster distribution

[n, xout] = hist(distr, max(distr));   %generate histogram of cluster size distribution (fig 2 in paper)
%title(['Histogram at \phi = ' num2str(phi) 'N = ' num2str(N)]);

loglog(xout,n,'o') %double-log plot of cluster size histogram




