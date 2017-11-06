from .Trader import Trader

class RandomTrader(Trader):
    """A Miner"""
    def __init__(self, unique_id, model):
        super().__init__(unique_id, model)
        self.tradeprobability = 0.2 #todo
