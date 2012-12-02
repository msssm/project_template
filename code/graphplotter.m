%%This script visualizes the graph and its clusters

%First manually load the adjacency matrix to be plotter!
%AA_sp=random_graph(20,0.1);

bg=biograph(AA_sp);
h = view(bg);
set(bg,'EdgeType','segmented','LayoutType','radial','ShowTextInNodes','None', 'ShowArrows','off');
%The set function does not seem to alter the visual output.

[number, nodes] = graphconncomp(AA_sp);
%This function returns the number of clusters in the network defined by A_sp and
%nodes, which is a vector telling which cluster each node belongs to:
%Indices are nodes, values are the cluster labels that each node belongs to

%Nodes that belong to the same cluster will have the same color.
colors = jet(number);
for i = 1:numel(h.nodes)
  h.Nodes(i).Color = colors(nodes(i),:);
end