function [s] = clustersize_distr(g)
%CLUSTERSIZE_DISTR returns an unnormalized histogram vector that contains the frequency with
%which a cluster of certain size occurs in the network. Clusters of zero
%size, i.e. of non-existent opinions, are disregarded. The function then
%plots this histogram in a logarithmic plot.

n = hist(g,max(g));
%Renerate histogram data of opinion vector with binning nummber equal to 
%number of opinions, i.e. at least the maximal value of g. E.g. it could
%be that there are 50 opinions but the last 3 have gone extinct. Therefore
%it is sufficient to choose 47 bins to capture each opinion with one bin.

nn = n(n~=0);     
%Remove the zeros (there will be tons of clusters with size zero, but nobody cares)
%Clusters of zero size are clusters of opinions that do not exist in the
%consensus state. This step basically prevents a high peak at size zero to
%occur, when we take hist(n)

s=hist(nn,max(nn));   
%Generate histogram of cluster size distribution (see Fig. 2 in paper)

end

