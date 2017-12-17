import numpy as np

from sys import maxsize as infinity_int
from sccm.market import *
from sccm.random import lognormal, normal
from sccm.math import clip
from collections import deque

from ._agent import CryptoCurrencyAgent
from ._equipment import Equipment


class Miner(CryptoCurrencyAgent):
    """A Miner"""
    kind = 'Miner'
    def __init__(self, unique_id, model, cash=0., bitcoin=0.):
        super().__init__(unique_id, model, cash, bitcoin)  # TODO: nicer
        # variables used to keep track of values, for the sake of performance
        self.hashing_capability = 0.
        self.power_consumption = 0.
        self.pool = self.model.global_pool
        self.pool.join(self)  # add myself to pool
        self.equipment = deque()  # equipment owned by the miner

        if self.clock == 0: #entering at time zero
            self.initial_trader_taken_first_decision = False  # the first time initial miners only decide but dont buy or sell hardware to prevent initial sellout
            self.time_when_to_buy_again = np.random.randint(0, self.model.parameters['Miner']['delta_time_to_decide_on_new_hardware']['mu'])  # take decision to buy in the first 60 days uniform distr
            age = np.random.randint(self.model.parameters['Miner']['age_divest_hardware'])  # to prevent all initial miners from divesting at t=365
            Corei5 = Equipment(**self.model.parameters['Miner']['initial_hardware'], time_bought = -age)
            self.equipment.append(Corei5)  # initial hardware

            #update by hand for the sake of performance
            self.hashing_capability = Corei5.hash_rate
            self.pool.hashing_capability += Corei5.hash_rate
            self.power_consumption = Corei5.power_consumption
        else: #later
            self.initial_trader_taken_first_decision = True
            self.buy_hardware()   # buy new hardware immediately
            self.update_time_when_to_buy_again()  # update time when to buy new mining hardware

    def update_time_when_to_buy_again(self):
        self.time_when_to_buy_again = self.clock + round(normal(**self.model.parameters['Miner']['delta_time_to_decide_on_new_hardware']))

    @property
    def fraction_cash_to_buy_hardware(self):
        return clip(lognormal(**self.model.parameters['Miner']['fraction_cash_to_buy_hardware'] ), 0., 1.)

    @property
    def fraction_bitcoin_to_be_sold_for_hardware(self):  # gamma
        return clip(lognormal(**self.model.parameters['Miner']['fraction_bitcoin_to_be_sold_for_hardware'] ), 0., 1.)

    @property
    def electricity_cost(self):  # total electricity cost in usd
        return self.model.parameters.electricity_cost(self.clock) * 24 * self.power_consumption

    def mine(self):
        if len(self.equipment)>0:
            btc_mined = self.hashing_capability / self.pool.hashing_capability * self.model.parameters.bitcoins_mined_per_day(self.clock)
            self.bitcoin_available += btc_mined
            self.cash_available -= self.electricity_cost
            self.pool.cash_spent_on_electricity_today += self.electricity_cost
            self.pool.btc_mined_today += btc_mined
            if(self.cash_available < 0):
                self.sell_bitcoin(min(self.electricity_cost/self.exchange.current_price, self.bitcoin_available))

    def buy_hardware(self, cash_going_to_spend=None):
        if cash_going_to_spend is None:
            cash_going_to_spend = max(self.fraction_cash_to_buy_hardware * self.cash_available, 0.)  # TODO: dont copypaste
        self.cash_available -= cash_going_to_spend
        self.pool.hardware_bought_today += cash_going_to_spend
        new_hardware = self.model.parameters.buy(self.clock, cash_going_to_spend)
        self.hashing_capability += new_hardware.hash_rate
        self.pool.hashing_capability += new_hardware.hash_rate
        self.power_consumption += new_hardware.power_consumption
        self.equipment.append(new_hardware)

    def divest_old_hardware(self):
        equip = lambda: self.equipment[0]
        while len(self.equipment)>0 and self.clock - equip().time_bought  > self.model.parameters['Miner']['age_divest_hardware']:
            self.hashing_capability -= equip().hash_rate
            self.pool.hashing_capability -= equip().hash_rate
            self.power_consumption -= equip().power_consumption
            self.equipment.popleft()

        # todo: should we sell old hardware for profit?

    def sell_bitcoin(self, amount):
        limit = 0.
        expiration_time = float('inf')  # TODO: not really necessary
        order = SellInfiniteOrder(amount, limit, self.clock, expiration_time, self, is_market_order = True)
        self.placeorder(order)

    def invest_divest(self):
        self.divest_old_hardware()
        bitcoin_we_would_be_willing_to_sell = self.fraction_bitcoin_to_be_sold_for_hardware * self.bitcoin_available
        money_we_expect_to_get = bitcoin_we_would_be_willing_to_sell * self.exchange.current_price
        money_we_want_to_spend = max(self.fraction_cash_to_buy_hardware * self.cash_available, 0.)
        if self.model.parameters['Miner']['buy_immediately']:
            money_we_want_to_spend += money_we_expect_to_get
        if money_we_want_to_spend > 0.:
            self.sell_bitcoin(bitcoin_we_would_be_willing_to_sell)
            self.buy_hardware(money_we_want_to_spend)

    def step(self):
        self.mine()
        if self.clock == self.time_when_to_buy_again:
            if self.initial_trader_taken_first_decision:
                self.invest_divest()
            self.initial_trader_taken_first_decision = True
            self.update_time_when_to_buy_again()
