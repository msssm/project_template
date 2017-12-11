from ._agent import CryptoCurrencyAgent
from sccm.market import *
from sccm.random import lognormal, normal
import numpy as np

# todo: turn this into abstract base class
class Trader(CryptoCurrencyAgent):
    """A General Trader"""
    def step(self):
        if (np.random.rand() < self._model.parameters['Trader'][self.kind]['tradeprobability']):
            kind = self.decide_on_kind_of_order()
            if kind is None:
                return
            beta = self.calculate_beta(**self.model.parameters['Trader']['RandomTrader']['fraction_cash_bitcoin_to_trade'])
            # TODO: simplify
            if np.random.rand() < self._model.parameters['Trader'][self.kind]['probability_market_order']:
                if issubclass(kind, BuyOrder): # buy
                    amount = self.cash_available * beta  # ba
                    limit = float('inf')
                    self.placeorder(kind(amount, limit, self.clock, self.order_expiration_time, self, is_market_order = True))
                else:  # SELL
                    amount = self.bitcoin_available * beta  # sa
                    limit = 0.
                    self.placeorder(kind(amount, limit, self.clock, self.order_expiration_time, self, is_market_order = True))
            else:
                N = self.calculate_N(**self.model.parameters['Trader']['strategy_limit'])
                if issubclass(kind, BuyOrder): # buy
                    amount = self.cash_available * beta  # ba
                    limit = self.exchange.current_price * N
                    self.placeorder(kind(amount, limit, self.clock, self.order_expiration_time, self))
                else:  # sell
                    amount = self.bitcoin_available * beta  # sa
                    limit = self.exchange.current_price / N
                    self.placeorder(kind(amount, limit, self.clock, self.order_expiration_time, self))

    def calculate_N(self, mu, K, sigma_max, sigma_min, timewindow):
        sigma = K * self.exchange.stddev_price_abs_return(timewindow)
        sigma = max(min(sigma, sigma_max), sigma_min)  # apparently more efficient than np.clip TODO: own clip function
        return np.random.normal(mu, sigma)
    def calculate_beta(self, **kwargs):
        return min(lognormal(**kwargs), 1.)

class RandomTrader(Trader):
    """A Random Trader"""
    kind = 'RandomTrader'

    def decide_on_kind_of_order(self):
        return np.random.choice((SellOrder, BuyOrder))

    @property
    def order_expiration_time(self):
        return round(lognormal(**self.model.parameters['Trader']['RandomTrader']['order_expiration_time']))

class Chartist(Trader):
    """A Chartist"""
    kind = 'Chartist'
    order_expiration_time = 0.
    def __init__(self, *args):
        super().__init__(*args)
        self.given_time_window = round(normal(**self.model.parameters['Trader']['Chartist']['strategy_timewindow']))  # make it an int

    def decide_on_kind_of_order(self):
        rpv = self.exchange.rel_price_var(self.given_time_window)
        threshold = self.model.parameters['Trader']['Chartist']['strategy_pricevariance_threshold']
        if (rpv > threshold): # price increased significantly
            return BuyTodayOrder
        elif(rpv < -threshold):  # price dropped significantly
            return SellTodayOrder
        else: # price stayed more or less the same
            return None
