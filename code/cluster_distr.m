function [distr] = cluster_distr(g)
%CLUSTER_DISTR Computes the frequency with which a cluster of certain size
%appears in system with vectors g

n = hist(g,length(g));
% generate histogram data of opinion vector with binning being the total number of opinions

distr = n(n~=0);     
%remove the zeros (there will be tons of clusters with size zero, but nobody cares)


end

