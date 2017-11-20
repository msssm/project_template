import numpy as np

from mesa import Model
from mesa.time import RandomActivation
from mesa.datacollection import DataCollector
from sccm.agents import *
from sccm.market import Exchange
from ._parameters import Parameters

class CryptoCurrencyModel(Model):
    """A model with some number of agents."""
    def __init__(self, N):
        self.running = True
        self.num_agents = N
        self.schedule = RandomActivation(self)
        self.exchange = Exchange(self)
        self.parameters = Parameters()
        self.global_pool = MiningPool()
        self.next_available_id = 0.
        # todo: put this in a separate function ?
        for i in range(self.num_agents):
            agentType = np.random.choice((RandomTrader, Chartist, Miner))
            a = agentType(self.next_available_id, self)
            self.next_available_id += 1
            # todo: distribute initial cash/btc according to correct law
            a.cash_available = 5.
            #a.bitcoin_available = 10.
            self.schedule.add(a)
        # todo: generate all traders at beginning, but only a few are active
        # distribute initial cash according to zipf law
        #tried to extract the price after each iteration (not successful)
        #self.datacollector = DataCollector(model_reporters={'price': lambda model: model.exchange.p})

        #tried to extract the price after each iteration (not successful)
        self.datacollector = DataCollector(model_reporters={'price': lambda model: model.exchange.current_price})

    def step(self):
        '''Advance the model by one step.'''
        self.datacollector.collect(self)
        self.schedule.step()
        # todo should we do orders as they come in or once a day
        self.exchange.clear()
        self.exchange.remove_old_orders()

    def add_agent(self, agentType, cash, n=1):
        for i in range(n):
            a = agentType(self.next_available_id, self)
            self.next_available_id += 1
            a.cash_available = cash
            self.schedule.add(a)
    # todo: enter agents into the market over time
