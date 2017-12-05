from ._agent import CryptoCurrencyAgent
from sccm.market import Order
from sccm.random import lognormal
import numpy as np

# todo: turn this into abstract base class
class Trader(CryptoCurrencyAgent):
    """A General Trader"""
    def __init__(self, unique_id, model):
        super().__init__(unique_id, model)
        # todo aquire initial btc when entering market after t=0

    def step(self):
        if (np.random.rand() < self.tradeprobability):
            kind = self.decide_on_kind_of_order()
            if kind is None:
                return
            beta = min(1., lognormal(*self.beta_parameters))
            mu = 1.05
            K = 2.4
            sigma_max = 0.01  #paper messes up min/max -> here they are swapped compared to paper,todo: check if they are correcr
            sigma_min = 0.003
            timewindow = 30 #T_i in paper, not the same as tau_i !!!! #TODO: correct value = ?  use value 30 from the older paper
            if np.random.rand() < self.probability_market_order:
                N = None #best available price
            else:
                sigma = K * self.exchange.stddev_price_abs_return(timewindow)
                sigma = np.clip(sigma, sigma_min, sigma_max)
                N = np.random.normal(mu, sigma)
            if kind == Order.Kind.BUY:
                amount = self.cash_available * beta  # ba
                if N is not None:
                    limit = self.exchange.p(self.clock) * N
                else:
                    limit = 0. #TODO: infinity here, when fixed in exchange tuples
            else:  # SELL
                amount = self.bitcoin_available * beta  # sa
                if N is not None:
                    limit = self.exchange.p(self.clock) / N
                else:
                    limit = 0.
            # kind, amount, limit_price, time,  t_expiration, agent
            self.placeorder(Order(kind, amount, limit, self.clock, self.expiration_time, self))


class RandomTrader(Trader):
    """A Random Trader"""
    def __init__(self, unique_id, model):
        super().__init__(unique_id, model)
        self.tradeprobability = 0.1
        self.probability_market_order = 0.2
        self.beta_parameters = (0.25, 0.2)

    def decide_on_kind_of_order(self):
        return np.random.choice((Order.Kind.SELL, Order.Kind.BUY))

    @property
    def expiration_time(self):
        return round(lognormal(3, 1))


class Chartist(Trader):
    """A Chartist"""
    def __init__(self, unique_id, model):
        super().__init__(unique_id, model)
        self.beta_parameters = (0.4, 0.2)
        self.tradeprobability = 0.5
        self.probability_market_order = 0.7
        mu, sigma = 20., 1.
        self.given_time_window = round(np.random.normal(mu, sigma))  # make it an int
        self.expiration_time = 0  # same day

    def decide_on_kind_of_order(self):
        rpv, diff = self.exchange.rel_price_var(self.given_time_window)
        if (rpv < 0.01):  # price stayed more or less the same
            return None
        else:
            if diff > 0:  # price increased significantly
                return Order.Kind.BUY
            else:  # price dropped significantly
                return Order.Kind.SELL
            '''
            if np.random.rand() > 0.1:  # ten percent do contrary strategy
                if diff > 0:  # price increased significantly
                    return Order.Kind.BUY
                else:  # price dropped significantly
                    return Order.Kind.SELL
            else :
                if diff > 0:
                    return Order.Kind.SELL
                else:
                    return Order.Kind.BUY
            '''
        # paper: issues buy order when the price relative variation in a 'given time window' is is higher than threshold 0.01
        # issues sell order otherwise ??? does not make sense
        # 'given time window' is specific for each chartist, normal distr with mu 20, sigma 1
