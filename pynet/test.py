import networkx as nx
import matplotlib.pyplot as plt

G = nx.fast_gnp_random_graph(100, 0.1)
nx.draw(G)
plt.show()

