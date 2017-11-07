from enum import Enum

class Order:
    class Kind(Enum):
        BUY = 1
        SELL = 2
    def __init__(self, kind, amount, limit_price, time,  t_expiration, agent):
        self.agent = agent
        self.kind = kind
        self.amount = amount #sell: in btc ,  buy: in $
        self.residual = amount #sell: in btc ,  buy: in $
        self.t_expiration = t_expiration
        self.time = time
        self.limit_price=limit_price # $ per btc
    def __repr__(self):
        return "BTC {} order of {} with residual {} and limit {}".format(self.kind, self.amount, self.residual, self.limit_price)
