import numpy as np

from sys import maxsize as infinity_int
from sccm.market import Order
from sccm.random import lognormal
from ._agent import CryptoCurrencyAgent
from ._equipment import Equipment


class Miner(CryptoCurrencyAgent):
    """A Miner"""
    def __init__(self, unique_id, model, miningpool=None):
        super().__init__(unique_id, model)
        self.hashing_capability = 0.
        self.power_consumption = 0.
        self.hasmined = True
        self.btc_mined = 0.
        if miningpool is not None:
            self.pool = miningpool
        else:
            self.pool = self.model.global_pool
        self.pool.join(self)  # add myself to pool
        self.equipment = []  # equipment owned by the miner
        if self.clock == 0:
            self.time_when_to_buy_again = np.random.choice(range(61))  # take decision to buy in the first 60 days uniform distr
            #experimental: distr uniform of time i5 bought over the past, to prevent all of them divesting at same time
            Corei5 = Equipment(round(np.random.uniform(-365,0)), 0.00173, 75)
            #Corei5 = Equipment(self.clock, 0.00173, 75)
            # todo: move corei5 to initial simulation parameters
            self.equipment.append(Corei5)  # initial hardware
            self.hashing_capability = Corei5.hash_rate
            self.pool.hashing_capability += Corei5.hash_rate
            self.power_consumption = Corei5.power_consumption

        else: #later
            self.enter_market()

    def enter_market(self):
        self.buy_hardware()   # buy new hardware immediately
        self.update_time_when_to_buy_again()  # update time when to buy new mining hardware


    def update_time_when_to_buy_again(self):
        mu, sigma = 0, 6.
        self.time_when_to_buy_again = self.clock + round(60 + np.random.normal(mu, sigma))

    @property
    def fraction_cash_to_buy_hardware(self):
        #experimental: typo in the paper?? should it be 0.35??
        return min(lognormal(0.35, 0.15), 1.)
        #return min(lognormal(0.15, 0.15), 1.)
        # gamma1:  percentage of cash allocated to buy

    @property
    def fraction_bitcoin_to_be_sold_for_hardware(self):  # gamma
        return min(lognormal(0.175, 0.075), 1.)
        #return 0.5 * self.fraction_cash_to_buy_hardware

    @property
    def electricity_cost(self):  # total electricity cost in usd
        return self.model.parameters.electricity_cost(self.clock) * 24 * self.power_consumption

    def mine(self):
        # experimental: allow electricity debt
        # Paper: If trader's cash is zero, she issues a sell market order to get the cash to support her electricity expenses
        if self.model.parameters.miners_can_have_negative_cash:
            self.btc_mined = self.hashing_capability / self.pool.hashing_capability * self.model.parameters.bitcoins_mined_per_day(self.clock)
            self.bitcoin_available += self.btc_mined
            self.pool.total_amount_mined += self.btc_mined
            self.cash_available -= self.electricity_cost
            self.model.shop.cash_spent_on_electricity += self.electricity_cost
            # self.hasmined = True  #remains true forever
            if(self.cash_available < 0):
                self.sell_bitcoin_for_electricity(amount = self.electricity_cost*self.exchange.current_price)

        else:
            assert(False)  # TODO:
            if (self.hashing_capability > 0. and self.cash_available >= self.electricity_cost):
                self.hasmined = True
                self.btc_mined = self.hashing_capability / self.pool.hashing_capability * self.model.parameters.bitcoins_mined_per_day(self.clock)
                self.bitcoin_available += self.btc_mined
                self.pool.total_amount_mined += self.btc_mined
                self.cash_available -= self.electricity_cost
                self.model.shop.cash_spent_on_electricity += self.electricity_cost
                assert(self.cash_available >= 0.)
            else:
                self.hasmined = False
                self.sell_bitcoin_for_electricity(amount = self.electricity_cost*self.exchange.current_price)

    def buy_hardware(self, cash_going_to_spend=None):
        if cash_going_to_spend is None:
            assert(self.cash_available >=0)
            cash_going_to_spend = self.fraction_cash_to_buy_hardware * self.cash_available
        self.cash_available -= cash_going_to_spend
        self.model.shop.cash_spent_on_new_hardware += cash_going_to_spend
        new_hardware = Equipment.buy(self.clock, cash_going_to_spend)
        self.hashing_capability += new_hardware.hash_rate
        self.pool.hashing_capability += new_hardware.hash_rate
        self.power_consumption += new_hardware.power_consumption
        self.equipment.append(new_hardware)

    def divest_old_hardware(self, age=365):
        i = 0
        for equip in self.equipment:
            #if (equip.time_bought < self.clock - age):
            if self.should_we_divest_hardware(equip):
                self.hashing_capability -= equip.hash_rate
                self.pool.hashing_capability -= equip.hash_rate
                self.power_consumption -= equip.power_consumption
                i += 1
            else:
                break
        self.equipment = self.equipment[i:]
        # todo: should we sell old hardware for profit?

    def sell_bitcoin_for_electricity(self, amount):
        amount = max(self.bitcoin_available, amount) #only money can become negative (lend from bank ecc), bitcoin can't
        kind = Order.Kind.SELLINF
        limit = 0.
        expiration_time = infinity_int
        order = Order(kind, amount, limit, self.clock, expiration_time, self)
        self.placeorder(order)

    def sell_bitcoin_to_buy_hardware_estimate(self):
        amount = self.fraction_bitcoin_to_be_sold_for_hardware * self.bitcoin_available
        return amount * self.exchange.current_price

    def sell_bitcoin_to_buy_hardware(self, factor=1.):
        reference_amount = self.bitcoin_available * factor
        kind = Order.Kind.SELLINF
        amount = self.fraction_bitcoin_to_be_sold_for_hardware * reference_amount
        limit = 0.
        expiration_time = infinity_int
        order = Order(kind, amount, limit, self.clock, expiration_time, self)
        self.placeorder(order)
        return amount * self.exchange.current_price

    def sell_bitcoin_to_buy_hardware_estimate(self):
        reference_amount = self.bitcoin_available
        amount = self.fraction_bitcoin_to_be_sold_for_hardware * reference_amount
        return amount * self.exchange.current_price

    def should_we_buy_hardware(self, cash=1.):
        e = Equipment.buy(self.clock, cash)
        bitcoin_potentially_mined = e.hash_rate / (self.pool.hashing_capability + e.hash_rate) * self.model.parameters.bitcoins_mined_per_day(self.clock)
        electricity_cost = self.model.parameters.electricity_cost(self.clock) * 24 * e.power_consumption
        return electricity_cost < bitcoin_potentially_mined * self.exchange.current_price

    def should_we_divest_hardware(self, e):
        bitcoin_potentially_mined = e.hash_rate / (self.pool.hashing_capability) * self.model.parameters.bitcoins_mined_per_day(self.clock)
        electricity_cost = self.model.parameters.electricity_cost(self.clock) * 24 * e.power_consumption
        return electricity_cost > 1.2 * bitcoin_potentially_mined * self.exchange.current_price

    def invest_divest(self):
        self.divest_old_hardware()
        money_we_expect_to_get = self.sell_bitcoin_to_buy_hardware_estimate()
        money_we_want_to_spend = money_we_expect_to_get * 0.5 + max(self.fraction_cash_to_buy_hardware * self.cash_available, 0.)
        if self.should_we_buy_hardware(money_we_want_to_spend):
            self.sell_bitcoin_to_buy_hardware()
            if self.model.parameters.miners_can_have_negative_cash:
                self.buy_hardware(money_we_want_to_spend)
            else:
                assert(False) #  TODO: implement; wait until we actually sold the bitcoins, buy then...
        else:
            self.sell_bitcoin_to_buy_hardware(0.5) # for electricity

    def step(self):
        self.mine()
        if self.clock == self.time_when_to_buy_again:
            self.invest_divest()
            self.update_time_when_to_buy_again()
        elif np.random.rand() < 0.1 and self.exchange.rel_price_var(window = 15)[0] > 0.016:
            self.invest_divest()
