import numpy as np

from heapq import heappush, heappop
from ._order import Order


class Exchange:  # TODO maybe move orderbook to its own class
    def __init__(self, model):
        self.orderbook = {}
        self.orderbook[Order.Kind.SELL] = []
        self.orderbook[Order.Kind.BUY] = []
        self.orderbook[Order.Kind.SELLINF] = []
        self.price = [0.0649]
        self.model = model
        self._rel_price_var = {}
        self._stddev_price_abs_return = {}
        self.ntransactions = 0
        self.avgprice = 0.0649
        self.amount_traded = 0.

    def update_avg_price(self, amount, price):
        old_amount = self.amount_traded
        self.amount_traded += amount
        self.avgprice = (old_amount * self.avgprice + amount * price ) / self.amount_traded  # weighted mean

    @property
    def clock(self):
        return self.model.schedule.time

    @property
    def current_price(self):  # current price
        return self.p(self.clock)
        #return self.p(self.clock-1)
        #return self.avgprice

    def p(self, t):  # price at time t, needed for chartists, todo: implement properly
        try:
            return self.price[t]
        except IndexError:
            self.price.append(self.p(t-1))  # recursion
            return self.p(t)  # try again, if implementation correct no infinite loops should happen

    def update_price(self, p, amount):
        self.update_avg_price(amount, p)
        try:
            self.price[self.clock] = p
        except IndexError:
            self.price.append(p)

    def prepare_next_step(self):
        if self.clock > 0:
            self.price[self.clock-1] = self.avgprice
            self.price.append(self.avgprice)
        self._rel_price_var = {}
        self._stddev_price_abs_return = {}
        self.ntransactions = 0
        #self.avgprice = 0.
        self.amount_traded = 0.

    def stddev_price_abs_return(self, window):
        end = self.clock-1
        start = max(end-window, 0)
        if end-start < 2:
            return 0.

        def calc_spar(start, end):
            pricelist = self.price[start:end]
            diff = np.abs(np.diff(pricelist))
            var = np.var(diff)
            return var
        try:
            return self._stddev_price_abs_return[window]
        except KeyError:
            spar = 0.
            diff = self.p(self.clock)  # make sure we access current price
            spar = calc_spar(start, end)  # todo: check this is correct
            self._stddev_price_abs_return[window] = spar
            return spar

    def rel_price_var(self, window):
        end = self.clock-1
        start = max(end-window, 0)
        if end-start < 2:
            return 0., 0.

        def calc_rpv(start, end):
            pricelist = self.price[start:end]
            var = np.var(pricelist)
            mean = np.mean(pricelist)
            diff, _ = np.polyfit(x=range(len(pricelist)), y=pricelist, deg=1)
            return var/abs(mean), diff

        try:
            return self._rel_price_var[window]
        except KeyError:
            rpv = 0.
            diff = self.p(self.clock)  # make sure we access current price
            #diff -= self.price[start]
            rpv, diff = calc_rpv(start, end)  # todo: check this is correct
            self._rel_price_var[window] = (rpv, diff)
            return rpv, diff

    def match(self, buy, sell):  # todo: move to order class
        # sj <= bi
        return (sell.limit_price <= buy.limit_price) or (sell.limit_price == 0.) or (buy.limit_price == 0.)

    def place(self, order):
        # print("order placed: {}".format(order))
        if order.kind == Order.Kind.SELL:
            key = order.limit_price
        else:
            key = -order.limit_price
        heappush(self.orderbook[order.kind], (key, order))
        self.clear()

    def clear(self):  # process all available orders
        # first sort orders
        # self.orderbook[Order.Kind.SELL].sort(key=lambda o: o.limit_price)  # sort should be stable, so asc time conserved
        # self.orderbook[Order.Kind.BUY].sort(key=lambda o: o.limit_price, reverse=True)

        # iterate through and match orders:
        while 1:  # while there are orders
            A = len(self.orderbook[Order.Kind.SELL]) > 0
            B = len(self.orderbook[Order.Kind.SELLINF]) > 0
            C = len(self.orderbook[Order.Kind.BUY]) > 0
            if C:
                buytuple = self.orderbook[Order.Kind.BUY][0]
            else:
                break
            if A and B:
                a = self.orderbook[Order.Kind.SELL][0]
                b = self.orderbook[Order.Kind.SELLINF][0]
                selltuple = min(a, b)
            elif A:
                selltuple = self.orderbook[Order.Kind.SELL][0]
            elif B:
                selltuple = self.orderbook[Order.Kind.SELLINF][0]
            else:
                break
            if self.match(buytuple[1], selltuple[1]):  # see if they match
                self.process(buytuple, selltuple)
            else:
                break  # no more matching orders

    def process(self, buytuple, selltuple):
        _, buy = buytuple
        _, sell = selltuple
        # determine price of transaction pT in $ per btc
        if buy.limit_price > 0. and sell.limit_price == 0.:
            pT = min(buy.limit_price, self.p(self.clock))
        elif sell.limit_price > 0. and buy.limit_price == 0.:
            pT = max(sell.limit_price, self.p(self.clock))
        elif sell.limit_price == 0. and buy.limit_price == 0.:
            pT = self.current_price
        else:  # buy.limit_price > 0 and sell.limit_price > 0
            pT = 0.5 * (buy.limit_price + sell.limit_price)

        # determine amount of transaction
        amount = min(sell.residual, buy.residual/pT)  # amount that is actually traded
        # exchange currency
        sell.agent.bitcoin_orders -= amount
        buy.agent.bitcoin_available += amount
        sell.agent.cash_available += amount * pT
        buy.agent.cash_orders -= amount * pT
        # update price:
        self.update_price(pT, amount)
        self.ntransactions += 1
        if (sell.residual*pT < buy.residual and sell.residual > self.model.parameters.order_threshold):  # avoid testing for ==0. with float
            buy.residual -= amount * pT
            heappop(self.orderbook[sell.kind])
        elif (sell.residual*pT > buy.residual and buy.residual > self.model.parameters.order_threshold):
            sell.residual -= amount
            heappop(self.orderbook[buy.kind])
        else:  # remove both
            heappop(self.orderbook[sell.kind])
            heappop(self.orderbook[buy.kind])

    def remove_old_orders(self):
        for kind in (Order.Kind.SELL, Order.Kind.BUY):
            book = self.orderbook[kind]
            keep = []
            for order_tuple in book:  # todo do this in one nice line :D
                _, order = order_tuple
                if self.clock - order.time > order.t_expiration:
                    if order.kind == Order.Kind.SELL:  # sell bitcoin
                        order.agent.bitcoin_available += order.residual
                        order.agent.bitcoin_orders -= order.residual
                    else:  # buy bitcoin
                        order.agent.cash_available += order.residual
                        order.agent.cash_orders -= order.residual
                    book.remove(order_tuple)
