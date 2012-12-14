function [s] = clustersize_distr(A_sp)
%CLUSTERSIZE_DISTR returns an unnormalized histogram vector that contains the frequency with
%which a cluster of certain size occurs in the network. 

[~,nodes] = graphconncomp(A_sp);
%This function returns the number (replaced by ~ because it is not used in 
%the function) of clusters in the network defined by A_sp and nodes, which 
%is a N-dimensional vector telling which cluster each node belongs to:
%Indices are nodes, values are the cluster labels that each node belongs to

n = hist(nodes,max(nodes));
%Each value of 'nodes' uniquely corresponds to one cluster in the network.
%n is the histogram that plots the count versus the cluster label. The
%clustersize_distr_backup_old.m function falsely took the opinion-value as
%opposed to the cluster-value as the indicator to which cluster it belongs
%to. This did not account for the fact that it is possible to have SEVERAL
%clusters of the SAME opinion.

s=hist(n,max(n));   
%Generate histogram of cluster size distribution (see Fig. 2 in paper)
end