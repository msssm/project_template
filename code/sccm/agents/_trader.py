from ._agent import CryptoCurrencyAgent
from sccm.market import Order

import numpy as np
import random #todo use np.random for everyting


class Trader(CryptoCurrencyAgent):
    """A General Trader"""
    def __init__(self, unique_id, model):
        super().__init__(unique_id, model)
        self.tradeprobability = 0.5 #todo
    def step(self):
        if (random.random() < self.tradeprobability):
            beta = min(1., np.random.lognormal(mean=0.25, sigma=0.2))
            mu, sigma = 1, 0.05 # TODO correct values
            N = np.random.normal(mu, sigma)
            kind = random.choice(list(Order.Kind))
            order_is_valid = True
            if kind == Order.Kind.BUY:
                amount = self.cash_available * beta #ba
                order_is_valid =  (amount > 0.)
                limit = self.exchange.p(self.clock) * N
            else: #SELL
                amount = self.bitcoin_available * beta #sa
                order_is_valid =  (amount > 0.)
                limit = self.exchange.p(self.clock) / N

            expiration_time = round(np.random.lognormal(mean=3, sigma=1))
            #todo
            if not expiration_time > 0:
                order_is_valid = False
            #assert limit >= usdp0. #wqit
            #kind, amount, limit_price, time,  t_expiration, agent
            if order_is_valid:
                self.placeorder(Order(kind , amount, limit, self.clock, expiration_time, self) )


class RandomTrader(Trader):
    """A Random Trader"""
    def __init__(self, unique_id, model):
        super().__init__(unique_id, model)
        self.tradeprobability = 0.2 #todo
from ._trader import Trader

class Chartist(Trader):
    """A Chartist"""
    def __init__(self, unique_id, model):
        super().__init__(unique_id, model)
        self.tradeprobability = 0.9 #todo
