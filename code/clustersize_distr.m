function [s] = clustersize_distr(A_sp)
%CLUSTERSIZE_DISTR returns an unnormalized histogram vector that contains the frequency with
%which a cluster of certain size occurs in the network. 

[number, nodes] = graphconncomp(A_sp)
%This function returns number, the number of clusters in the network and
%nodes, which is a vector telling which cluster each node belongs to:
%Indices are nodes, values are the cluster labels that each node belongs to

n = hist(nodes,max(nodes));

s=hist(n,max(n));   
%Generate histogram of cluster size distribution (see Fig. 2 in paper)


end

