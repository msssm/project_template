import numpy as np

from sys import maxsize as infinity_int
from sccm.market import Order
from ._agent import CryptoCurrencyAgent
from ._equipment import Equipment

class Miner(CryptoCurrencyAgent):
    """A Miner"""
    def __init__(self, unique_id, model, miningpool=None):
        super().__init__(unique_id, model)
        if miningpool is not None:
            self.pool = miningpool
        else:
            self.pool=self.model.global_pool
        self.pool.join(self)  # add myself to pool
        self.update_fraction_cash_to_buy_hardware();
        self.equipment = []  # equipment owned by the miner
        self.hashing_capability = 0.
        if self.clock == 0:
            self.time_when_to_buy_again = np.random.choice(range(61))  # take decision to buy in the first 60 days uniform distr
            Corei5 = Equipment(self.clock, 0.00173, 75)
            # todo: move corei5 to initial simulation parameters
            self.equipment.append(Corei5)  # initial hardware
        else:
            self.buy_hardware() #buy new hardware immediately
            self.update_time_when_to_buy_again()  # update time when to buy new mining hardware

    def update_time_when_to_buy_again(self):
        mu, sigma = 0, 6.
        self.time_when_to_buy_again = self.clock + round(60 + np.random.normal(mu, sigma))

    def update_fraction_cash_to_buy_hardware(self):
        self.fraction_cash_to_buy_hardware =  np.clip(np.random.lognormal(mean=0.6, sigma=0.15), 0., 1.)
        #gamma1:  percentage of cash allocated to buy

    @property
    def fraction_bitcoin_to_be_sold_for_hardware (self):  # gamma
        return 0.5 * self.fraction_cash_to_buy_hardware

    @property
    def electricity_cost(self):  # total electricity cost in usd
        return self.model.parameters.electricity_cost(self.clock) * 24 * sum(equip.power_consumption for equip in self.equipment)

    def mine(self):
        if (self.hashing_capability > 0. and self.cash_available >= self.electricity_cost):
            self.bitcoin_available += self.hashing_capability / self.pool.hashing_capability * self.model.parameters.bitcoins_mined_per_day(self.clock)
            assert(self.cash_available >= 0.)
        #todo: what to do when we run out of cash for electricity?
        #todo: only use part of equipment to mine if we do not have enought cash
        #todo: sell bitcoin if we run out of cash for electricity

    def buy_hardware(self):
        cash_going_to_spend = self.fraction_cash_to_buy_hardware * self.cash_available
        self.cash_available -= cash_going_to_spend
        new_hardware = Equipment.buy(self.clock, cash_going_to_spend)
        self.hashing_capability += new_hardware.hash_rate
        self.equipment.append(new_hardware)

    def divest_old_hardware(self, age=365):
        equipment_keep = []
        for equip in self.equipment:
            if (equip.time_bought > self.clock - age):
                equipment_keep.append(equip)
            else:
                self.hashing_capability -= equip.hash_rate
        self.equipment = equipment_keep
        # todo: should we sell old hardware for profit?

    def sell_bitcoin_to_buy_hardware(self):
        kind = Order.Kind.SELL
        amount = self.fraction_bitcoin_to_be_sold_for_hardware * self.bitcoin_available
        limit = 0.
        expiration_time = infinity_int
        self.placeorder(Order(kind, amount, limit, self.clock, expiration_time, self))

    def step(self):
        self.mine()
        # update_fraction_cash_to_buy_hardware() todo: when do we need to do this
        # todo: when to sell bitcoin to pay for electricity
        self.divest_old_hardware()
        if self.clock==self.time_when_to_buy_again:
            self.sell_bitcoin_to_buy_hardware()
            self.buy_hardware()
            self.update_time_when_to_buy_again()
