function [distr] = cluster_distr(g)
%CLUSTER_DISTR Computes the frequency with which a cluster of certain size
%appears in system with vectors g

n = hist(g,length(g));
distr= n(n~=0);


end

