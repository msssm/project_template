import numpy as np

from heapq import heappush, heappop, heapify
from collections import deque
from ._order import *
from sccm.cache import ValueCache


class Calc_rpv:  # relative price variance
    def __init__(self, exchange):
        self._exchange = exchange
    def __call__(self, window):
        end = self._exchange.clock -1
        start = max(end-window, 0)
        if end-start < 2 or end-start > len(self._exchange.price):
            return 0., 0.
        pricelist = self._exchange.price[start:end]
        var = np.var(pricelist)
        mean = np.mean(pricelist)
        #diff, _ = np.polyfit(x=range(len(pricelist)), y=pricelist, deg=1)  # todo: how should we do this
        diff = pricelist[-1] - pricelist[-2]
        return var/abs(mean), diff

class Calc_spar:  # standarddeviation of absolute price return
    def __init__(self, exchange):
        self._exchange = exchange
    def __call__(self, window):
        end = self._exchange.clock - 1
        start = max(end-window, 0)
        if end-start < 2:
            return 0.
        pricelist = self._exchange.price[start:end]
        diff = np.abs(np.diff(pricelist))
        var = np.var(diff)
        return var

class Exchange:
    def __init__(self, model):
        self.orderbook = {'sell': [], 'buy':[], 'sellinf': deque(), 'selltoday': deque(), 'buytoday': deque()}
        self.price = [model.parameters['Model']['initial_price']]
        self._model = model  # needed for clock
        self.rel_price_var = ValueCache(Calc_rpv(self))
        self.stddev_price_abs_return = ValueCache(Calc_spar(self))

    @property
    def clock(self):
        return self._model.schedule.time

    @property
    def current_price(self):
        return self.price[-1]

    @current_price.setter
    def current_price(self, value):
        self.price[-1] = value

    def prepare_next_step(self):
        self.rel_price_var.clear()
        self.stddev_price_abs_return.clear()
        self.price.append(self.price[-1])

    def place(self, order):
        order.activate()  # make money unavailable
        if order.kind in ['buy', 'sell']:  # heapq
            heappush(self.orderbook[order.kind], order)
        else:  # dequeue
            self.orderbook[order.kind].append(order)
        self.clear_all_orders()

    def clear_all_orders(self):  # process all available orders
        while 1:  # while there are orders
            buykinds = ['buy', 'buytoday']
            sellkinds = ['sell', 'selltoday', 'sellinf']
            sell = None
            buy = None
            for k in sellkinds:
                if len(self.orderbook[k]) > 0:
                    if sell is None:
                        sell = self.orderbook[k][0]
                    else:
                        sell = min(sell, self.orderbook[k][0])
            for k in buykinds:
                if len(self.orderbook[k]) > 0:
                    if buy is None:
                        buy = self.orderbook[k][0]
                    else:
                        buy = min(buy, self.orderbook[k][0])
            if (buy is None) or (sell is None):
                break # no more matching orders
            if buy.matches(sell):  # see if they match
                self.process(buy, sell)
            else:
                break  # no more matching orders

    def process(self, buy, sell):
        # determine price of transaction pT in $ per btc
        if sell.is_market_order and buy.is_market_order:
            pT = self.current_price
        elif sell.is_market_order:  # zero limit
            pT = min(buy.limit_price, self.current_price)
        elif buy.is_market_order:  # infinite limit
            pT = max(sell.limit_price, self.current_price)
        else:
            pT = 0.5 * (buy.limit_price + sell.limit_price)
        # determine amount of transaction
        amount = min(sell.residual, buy.residual/pT)  # amount that is actually traded
        # exchange currency
        sell.agent.bitcoin_orders -= amount
        buy.agent.bitcoin_available += amount
        sell.agent.cash_available += amount * pT
        buy.agent.cash_orders -= amount * pT
        # update price:
        self.current_price = pT

        def remove(order):  # helper function to remove an order from the different datastructures
            # TODO: assert that this is first order on list
            if order.kind in ['buy', 'sell']:  # heapq
                heappop(self.orderbook[order.kind])
            else:  # dequeue
                self.orderbook[order.kind].popleft()

        if (sell.residual*pT < buy.residual):  # TODO: threshold
            buy.residual -= amount * pT
            remove(sell)
        elif (sell.residual*pT > buy.residual):
            sell.residual -= amount
            remove(buy)
        else:  # remove both
            remove(sell)
            remove(buy)

    def remove_old_orders(self):
        self.orderbook['buytoday'].clear()
        self.orderbook['selltoday'].clear()
        for kind in ('buy', 'sell'):
            book = self.orderbook[kind]
            toremove = []
            for order in book:  # TODO what is the most efficient way?
                if order.is_expired(self.clock):
                    order.cancel()  # give the agent his money back, mark as cancelled, will be removed when encountered by clear_all_orders
                    toremove.append(order)
            for order in toremove:
                book.remove(order)
            if len(toremove)>0:
                heapify(book)  # repair heap
