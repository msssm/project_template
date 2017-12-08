from enum import Enum

class Order:
    def __init__(self, amount, limit_price, time,  lifetime, agent, is_market_order = False):
        self.agent = agent
        self.amount = amount  # sell: in btc ,  buy: in $
        self.residual = 0.  # sell: in btc ,  buy: in $
        self.expiration_time = time + lifetime  # expiration time is the date when it expires
        self.time_placed = time
        self.limit_price = limit_price  # $ per btc
        self.is_market_order = is_market_order

    @staticmethod
    def _match(sell, buy):  # todo: move to order class
        return (sell.limit_price <= buy.limit_price)

    def __repr__(self):
        return "BTC {0} order of {1}{2} with residual {3}{2} and limit {4} usd/btc that was placed at time {5}".format(self.kind, self.amount, self.amount_type, self.residual, self.limit_price, self.time_placed)

    def is_expired(self, t):
        return t > self.expiration_time

class SellOrder(Order):
    kind = 'sell'
    amount_type = 'btc'

    def matches(self, buy):  # todo: move to order class
        return self._match(self, buy)

    def __lt__(self, other):
        if self.limit_price == other.limit_price:
            return self.time_placed < other.time_placed
        else:
            return self.limit_price < other.limit_price

    def activate(self): # once order is 'active', the money is no longer available to the agent
        self.agent.bitcoin_orders += self.amount
        self.agent.bitcoin_available -= self.amount
        self.residual = self.amount

    def cancel(self):
        self.agent.bitcoin_available += self.residual
        self.agent.bitcoin_orders -= self.residual

class SellInfiniteOrder(SellOrder):
    kind = 'sellinf'

class SellTodayOrder(SellOrder):
    kind = 'selltoday'

class BuyOrder(Order):
    kind = 'buy'
    amount_type = 'usd'

    def matches(self, sell):  # todo: move to order class
        return self._match(sell, self)

    def __lt__(self, other):
        if self.limit_price == other.limit_price:
            return self.time_placed < other.time_placed
        else:
            return self.limit_price > other.limit_price

    def activate(self): # once order is 'active', the money is no longer available to the agent
        self.agent.cash_orders += self.amount
        self.agent.cash_available -= self.amount
        self.residual = self.amount

    def cancel(self):
        self.agent.cash_available += self.residual
        self.agent.cash_orders -= self.residual

class BuyTodayOrder(BuyOrder):
    kind = 'buytoday'
