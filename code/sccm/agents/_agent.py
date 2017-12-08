from mesa import Agent
from sccm.market import *


class CryptoCurrencyAgent(Agent):
    """An agent"""
    def __init__(self, unique_id, model, cash=0., bitcoin=0.):
        super().__init__(unique_id, model)
        self.cash_available = cash  # fiat cash
        self.bitcoin_available = bitcoin  # cryptocurrency
        self.cash_orders = 0.  # fiat cash
        self.bitcoin_orders = 0.  # cryptocurrency
        self.te = 0.  # entry time
        self.exchange = model.exchange
        self._model = model

    @property
    def clock(self):  # todo make it self.clock.now or so
        return self._model.schedule.time

    @property
    def cash_total(self):
        return self.cash_available + self.cash_orders

    @property
    def bitcoin_total(self):
        return self.bitcoin_available + self.bitcoin_orders

    def placeorder(self, order):
        if order.amount > 0:  # prevent too small orders todo: should we prevent this elsewhere?
            self.exchange.place(order)
