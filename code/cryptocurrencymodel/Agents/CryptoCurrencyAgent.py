from mesa import Agent
from cryptocurrencymodel.Order import Order #todo fix this import

class CryptoCurrencyAgent(Agent):
    """An agent"""
    def __init__(self, unique_id, model):
        super().__init__(unique_id, model)
        self.cash_available = 5. #fiat cash
        self.bitcoin_available = 10. #cryptocurrency
        self.cash_orders = 0. #fiat cash
        self.bitcoin_orders = 0. #cryptocurrency
        self.te = 0. #entry time
        self.bitcoin_in_sell_orders = 0.
        self.cash_in_buy_orders = 0.
        self.exchange = model.exchange
        self._model = model

    @property
    def clock(self): #todo make it self.clock.now or so
        return self._model.schedule.time

    def round_machine_precision(x): #todo make use of this
        if abs(x) < machine_precision:
            val = 0.
        return x

    @property
    def cash_total(self):
        return self.cash_available + self.cash_orders
    @property
    def bitcoin_total(self):
        return self.bitcoin_available + self.bitcoin_orders
    #@property
    #def cb(self): #$ not in buy orders, todo do this in a more efficient way
    #    return sum(order.amount for order in self.exchange.orderbook[Order.Kind.SELL] if order.agent==self )
    #@property
    #def bs(self): #btc not in buy orders
    #    return sum(order.amount for order in self.exchange.orderbook[Order.Kind.BUY] if order.agent==self) #TODO dont copypaste

    def placeorder(self, order):
        if order.kind == Order.Kind.SELL: #sell bitcoin
            self.bitcoin_orders += order.amount
            self.bitcoin_available -= order.amount
            #print(self.bitcoin_orders)
            #assert self.bitcoin_available >= 0.

        else: #buy bitcoin
            self.cash_orders += order.amount
            self.cash_available -= order.amount
            #print(self.cash_orders)
            #assert self.cash_available >= 0.

        self.exchange.place(order)
