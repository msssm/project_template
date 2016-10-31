import networkx as nx
import matplotlib.pyplot as plt

N = 100
G = nx.fast_gnp_random_graph(N, 4./N)

histo = nx.degree_histogram(G)
mean_degree = 0
for k in range (len(histo)):
    mean_degree += histo[k] * k
mean_degree /= N

#nx.draw(G)
#plt.show()

print(G.nodes())

print (histo)
print(mean_degree)

