%%%Reading csv data and plotting it

clear;

phi = 0.1;
N = 1000;

A_adj = csvread(['output_matrix_phi=' num2str(phi) '.csv']);
g = csvread(['output_opinions_phi=' num2str(phi) '.csv']);

x = hist(cluster_distr(g), length(g))   %generate histogram of cluster size distribution (fig 2 in paper)
title(['Histogram at \phi = ' num2str(phi) 'N = ' num2str(N)]);
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')



