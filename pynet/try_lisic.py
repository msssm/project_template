
# coding: utf-8

# In[2]:

import networkx as nx
import numpy as np
import matplotlib.pyplot as plt


# In[3]:

#G=nx.DiGraph()
G = nx.Graph()
G.add_edges_from([(1,2),(1,3)])
pos = nx.spring_layout(G)
#G.remove_node(2)
M = nx.uniform_random_intersection_graph(10,10,1)
#nx.draw_networkx(G ,pos)
#nx.draw_networkx(G)
nx.draw(G)
plt.show()


# In[59]:

#create a graph with degrees following a power law distribution
s=[]
while len(s)<100:
    nextval = int(nx.utils.powerlaw_sequence(1, 2.5)[0]) #100 nodes, power-law exponent 2.5
    if nextval!=0:
        s.append(nextval)
G = nx.configuration_model(s)
G= nx.Graph(G) # remove parallel edges
G.remove_edges_from(G.selfloop_edges())

#draw and show graph
pos = nx.spring_layout(G)
nx.draw_networkx(G, pos)
#plt.savefig('test.pdf')
plt.show()


# In[98]:

#create a graph with degrees following a power law distribution
s = nx.utils.powerlaw_sequence(50, 3) #100 nodes, power-law exponent 2.5
for i in range(len(s)) :
    s[i]+=1
    #s[i] = int(s[i])+2
G1 = nx.expected_degree_graph(s, selfloops=False)
G2 = nx.expected_degree_graph(s, selfloops=False)
print(s)
#print(G.nodes())
#print(G.edges())
plt.figure(figsize=(10,5))
#draw and show graph
pos = nx.spring_layout(G1)
nx.draw_networkx(G1, pos)

plt.show()


# In[61]:

plt.figure(figsize=(10,5))
pos2 = nx.spring_layout(G2)
nx.draw_networkx(G2, pos2)

plt.show()


# In[90]:

C = nx.disjoint_union(G1,G2)
#elist=[ ('1-'+str(n1),'2-'+str(n1)) for n1 in G1 ]#if n1 in G2]
elist = [(n,50+n) for n in G1]
C.add_edges_from(elist)

plt.figure(figsize=(10,5))
nx.draw_networkx(C)
#nx.draw_networkx(G2)
plt.show()


# In[97]:

a = np.random.randint(0,99,20)
print(a)
C.remove_nodes_from(a)
plt.figure(figsize=(10,5))
nx.draw_networkx(C)
#nx.draw_networkx(G2)
plt.show()

