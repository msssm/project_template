from ._order import Order


class Exchange:  # TODO maybe move orderbook to its own class
    def __init__(self, model):
        self.orderbook = {}
        self.orderbook[Order.Kind.SELL] = []
        self.orderbook[Order.Kind.BUY] = []
        self.price = {0: 0.0649}
        self._model = model

    @property
    def clock(self):
        return self._model.schedule.time

    def p(self, t):  # current price
        t = max(0,t)  # make sure time is not negative, can be when chartists start at the beginning
        try:
            res = self.price[t]
        except KeyError:
            res = self.p(t-1)
        return res

    def match(self, buy, sell):  # todo: move to order class
        # sj <= bi
        return (sell.limit_price <= buy.limit_price) or (sell.limit_price == 0.) or (buy.limit_price == 0.)

    def place(self, order):
        # print("order placed: {}".format(order))
        self.orderbook[order.kind].append(order)
        # self.clear()

    def clear(self):  # process all available orders
        # first sort orders
        self.orderbook[Order.Kind.SELL].sort(key=lambda o: o.limit_price)  # sort should be stable, so asc time conserved
        self.orderbook[Order.Kind.BUY].sort(key=lambda o: o.limit_price, reverse=True)

        # iterate through and match orders:
        matching = True
        while matching and len(self.orderbook[Order.Kind.SELL]) and len(self.orderbook[Order.Kind.BUY]):  # while there are orders
            buy = self.orderbook[Order.Kind.BUY][0]
            sell = self.orderbook[Order.Kind.SELL][0]

            if self.match(buy, sell):  # see if they match
                self.process(buy, sell)
            else:
                matching = False  # no more matching orders

    def process(self, buy, sell):
        # determine price of transaction pT in $ per btc
        if buy.limit_price > 0. and sell.limit_price == 0.:
            pT = min(buy.limit_price, self.p(self.clock))
        elif sell.limit_price > 0. and buy.limit_price == 0.:
            pT = max(sell.limit_price, self.p(self.clock))
        elif sell.limit_price == 0. and buy.limit_price == 0.:
            pT = self.p(self.clock)
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
        self.price[self.clock] = pT

        if (sell.residual < buy.residual / pT):  # avoid testing for ==0. with float
            toremove = sell
        else:
            toremove = buy
        buy.residual -= amount * pT
        sell.residual -= amount
        self.remove_order(toremove)

    def remove_order(self, order):
        if order.kind == Order.Kind.SELL:  # sell bitcoin
            order.agent.bitcoin_available += order.residual
            order.agent.bitcoin_orders -= order.residual
        else:  # buy bitcoin
            order.agent.cash_available += order.residual
            order.agent.cash_orders -= order.residual

        self.orderbook[order.kind].remove(order)
        # print("order removed: {}".format(order))

    def remove_old_orders(self):
        for kind in list(Order.Kind):
            book = self.orderbook[kind]
            for order in book:  # todo do this in one nice line :D
                if self.clock - order.time > order.t_expiration:  # todo check if correct
                    self.remove_order(order)
