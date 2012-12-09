function [s,c]=local_graphconncomp(G,varargin)
%GRAPHCONNCOMP finds the connected components in graph.
% 
% [S,C] = GRAPHCONNCOMP(G) finds the strongly connected components using
% Tarjan's algorithm. A strongly connected component is a maximal group of
% nodes that are mutually reachable without violating the edge directions.
% G is an n-by-n sparse matrix that represents the directed graph; all
% nonzero entries indicate the presence of an edge. S is the number of
% components and C is a vector indicating to which component each node
% belongs. Any zeros in C represent nodes that do not belong to a connected
% component.  
% 
% Tarjan's algorithm time complexity is O(n+e), where n and e are number of
% nodes and edges respectively.  
% 
% GRAPHCONNCOMP(...,'DIRECTED',false) assumes G is an undirected graph, the
% upper triangle of the sparse matrix G is ignored. A DFS-based algorithm
% computes the connected components. Time complexity is O(n+e).
% 
% GRAPHCONNCOMP(...,'WEAK',true) finds the weakly connected components. A
% weakly connected component is a maximal group of nodes which are mutually
% reachable by violating the edge directions. Default is false. The state
% of this parameter has no effect on undirected graphs. Time complexity is
% O(n+e).
% 
% Remarks: 
%   - Note that by definition a single node can also be a strongly
%   connected component. 
%   - A DAG must not have any strongly connected components larger than
%   one. 
% 
% Example:
%    % Create a directed graph with 10 nodes and 17 edges
%    g = sparse([1 1 1 2 2 3 3 4 5 6 7 7 8 9 9  9 9], ...
%               [2 6 8 3 1 4 2 5 4 7 6 4 9 8 10 5 3],true,10,10)
%    h = view(biograph(g));
%    % Find the strongly connected components
%    [S,C] = graphconncomp(g)
%    % Mark the nodes for each component with different color
%    colors = jet(S);
%    for i = 1:numel(h.nodes)
%        h.Nodes(i).Color = colors(C(i),:);
%    end
%
% See also: GRAPHALLSHORTESTPATHS, GRAPHISDAG, GRAPHISOMORPHISM,
% GRAPHISSPANTREE, GRAPHMAXFLOW, GRAPHMINSPANTREE, GRAPHPRED2PATH,
% GRAPHSHORTESTPATH, GRAPHTHEORYDEMO, GRAPHTOPOORDER, GRAPHTRAVERSE.
%
% References: 
%  [1]	R. E. Tarjan "Depth first search and linear graph algorithms" SIAM
%       Journal on Computing, 1(2):146-160, 1972. 
%  [2]  R. Sedgewick "Algorithms in C++, Part 5 Graph Algorithms"
%       Addison-Wesley, 2002. 

%   Copyright 2006-2008 The MathWorks, Inc.


debug_level = 0;

% set defaults of optional input arguments
directed = true;
weak = false;

% read in optional PV input arguments
nvarargin = numel(varargin);
if nvarargin
    if rem(nvarargin,2) == 1
        error(message('bioinfo:graphconncomp:IncorrectNumberOfArguments', mfilename));
    end
    okargs = {'directed','weak'};
    for j=1:2:nvarargin-1
        pname = varargin{j};
        pval = varargin{j+1};
        k = find(strncmpi(pname,okargs,numel(pname)));
        if isempty(k)
            error(message('bioinfo:graphconncomp:UnknownParameterName', pname));
        elseif length(k)>1
            error(message('bioinfo:graphconncomp:AmbiguousParameterName', pname));
        else
            switch(k)
                case 1 % 'directed'
                    directed = bioinfoprivate.opttf(pval,okargs{k},mfilename);
                case 2 % 'weak'
                    weak = bioinfoprivate.opttf(pval,okargs{k},mfilename);
            end
        end
    end
end

% call the mex implementation of the graph algorithms
if directed && ~weak
    if nargout>1
        [s,c] = local_graphalgs('scc',debug_level,directed,G);
    else
        s = local_graphalgs('scc',debug_level,directed,G);
    end
else
    if nargout>1
        [s,c] = local_graphalgs('wcc',debug_level,directed,G);
    else
        s = local_graphalgs('wcc',debug_level,directed,G);
    end
end
