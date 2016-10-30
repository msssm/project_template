import networkx as nx
from plant import Plant

class Grid(nx.Graph):
    """
    Power_grid network.
    """
    def fail (self, Q):
        """
        remove Q nodes randomly

        """
    def attack (self, Q):
        """
        remove Q mostly connected nodes.
        """

    def robustness (self):
        """
        R = Sum_{Q=1}^{N} S(Q) / N
        """
