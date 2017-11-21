from mesa import Agent
from sccm.market import Order


class CryptoCurrencyAgent(Agent):
    """An agent"""
    def __init__(self, unique_id, model):
        super().__init__(unique_id, model)
        self.cash_available = 0.  # fiat cash
        self.bitcoin_available = 0.  # cryptocurrency
        self.cash_orders = 0.  # fiat cash
        self.bitcoin_orders = 0.  # cryptocurrency
        self.te = 0.  # entry time
        self.exchange = model.exchange
        self._model = model

    @property
    def clock(self):  # todo make it self.clock.now or so
        return self._model.schedule.time

    def round_machine_precision(x):  # todo make use of this
        if abs(x) < machine_precision:
            val = 0.
        return x

    @property
    def cash_total(self):
        return self.cash_available + self.cash_orders

    @property
    def bitcoin_total(self):
        return self.bitcoin_available + self.bitcoin_orders

    def placeorder(self, order):
        if order.amount != 0.: #dont place 0 orders todo: should we prevent this elsewhere?
            if order.kind == Order.Kind.SELL:  # sell bitcoin
                self.bitcoin_orders += order.amount
                self.bitcoin_available -= order.amount
            else:  # buy bitcoin
                self.cash_orders += order.amount
                self.cash_available -= order.amount
            self.exchange.place(order)
