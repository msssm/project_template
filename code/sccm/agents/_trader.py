from ._agent import CryptoCurrencyAgent
from sccm.market import Order
import numpy as np


# todo: turn this into abstract base class
class Trader(CryptoCurrencyAgent):
    """A General Trader"""
    def __init__(self, unique_id, model):
        super().__init__(unique_id, model)
        # todo aquire initial btc when entering market after t=0

    def step(self):
        if (np.random.rand() < self.tradeprobability):
            beta = min(1., np.random.lognormal(mean=0.25, sigma=0.2))
            mu, sigma = 1, 0.05  # TODO correct values
            N = np.random.normal(mu, sigma)
            kind  = self.decide_on_kind_of_order()
            if kind is None:
                return
            if kind == Order.Kind.BUY:
                amount = self.cash_available * beta  # ba
                limit = self.exchange.p(self.clock) * N
            else:  # SELL
                amount = self.bitcoin_available * beta  # sa
                limit = self.exchange.p(self.clock) / N
            # kind, amount, limit_price, time,  t_expiration, agent
            self.placeorder(Order(kind, amount, limit, self.clock, self.expiration_time, self))


class RandomTrader(Trader):
    """A Random Trader"""
    def __init__(self, unique_id, model):
        super().__init__(unique_id, model)
        self.tradeprobability = 0.1

    def decide_on_kind_of_order(self):
        return np.random.choice(list(Order.Kind))

    @property
    def expiration_time(self):
        return round(np.random.lognormal(mean=3, sigma=1))


class Chartist(Trader):
    """A Chartist"""
    def __init__(self, unique_id, model):
        super().__init__(unique_id, model)
        self.tradeprobability = 0.5
        mu, sigma = 20., 1.
        self.given_time_window = round(np.random.normal(mu, sigma))  # make it an int
        self.expiration_time = 0  # same day

    def decide_on_kind_of_order(self):
        rpv, diff = self.exchange.rel_price_var(self.clock-self.given_time_window, self.clock)
        if (rpv < 0.01):  # price stayed more or less the same
            return None
        elif diff > 0:  # price increased significantly
            return Order.Kind.BUY
        else:  # price dropped significantly
            return Order.Kind.SELL
        # paper: issues buy order when the price relative variation in a 'given time window' is is higher than threshold 0.01
        # issues sell order otherwise ??? does not make sense
        # 'given time window' is specific for each chartist, normal distr with mu 20, sigma 1
