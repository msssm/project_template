from __future__ import division, print_function

import networkx as nx
import matplotlib.pyplot as plt
from classes import InterER

def main():
    N = 100
    k = 4

    G = InterER(N, k, k)
    nx.draw(G)
    plt.show()

if __name__ == "__main__":
    main()

