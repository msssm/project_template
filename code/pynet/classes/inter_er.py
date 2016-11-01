from __future__ import division, print_function

import networkx as nx
import matplotlib.pyplot as plt

class InterER(nx.Graph):

    def __init__(self, n, ka, kb):
        """
        n: number of nodes of each sub network
        ka, kb: average degree of network a, b
        """
        self.n = n
        self.ka = ka
        self.kb = kb

        pa = ka / n
        pb = kb / n

        self.Ga = nx.fast_gnp_random_graph(n, pa)
        self.Gb = nx.fast_gnp_random_graph(n, pb)

        nx.Graph.__init__(self, nx.disjoint_union(self.Ga, self.Gb))

        for i in range(n):
            self.add_edge(i, n+i)

