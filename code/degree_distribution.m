function p = degree_distribution(G)
% G: graph
% p: degree distribution p(k), k is degree
    deg = degree(G);
    Ntot = numnodes(G);
    
    Ncum = 0;
    k = 1;
    p = 0;
    p_k = 0;
    while (Ncum < Ntot)
        for i = 1:Ntot
            if (deg(i) == k)
                p_k = p_k + 1;
            end
        end
        Ncum = Ncum + p_k;
        k = k + 1;
        p = [p, p_k];
        p_k = 0;
    end
    p(1) = [];
    p = p / Ntot;
end
