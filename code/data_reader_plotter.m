%%%Reading csv data and plotting it


phi = 0.1;
N = 100;
runs = 100;

%A_adj = csvread(['output_matrix_phi=' num2str(phi) 'N = ' num2str(N) '.csv']);
g = csvread(['output_opinions_phi=' num2str(phi) ' N = ' num2str(N) ' runs = ' num2str(runs) '.csv']);

distr = cluster_distr(g);

[n, xout] = hist(distr, max(distr));   %generate histogram of cluster size distribution (fig 2 in paper)
%title(['Histogram at \phi = ' num2str(phi) 'N = ' num2str(N)]);


loglog(xout,n,'x')

% ph = get(gca,'children');
% vn = get(ph,'Vertices');
% vn(:,2) = vn(:,2) + 1;
% set(ph,'Vertices',vn);
% 
% set(gca,'yscale','log')
% set(gca,'xscale','log')



