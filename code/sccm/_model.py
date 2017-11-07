from mesa import Model
from mesa.time import RandomActivation
from sccm.agents import *
from sccm.market import Exchange

class CryptoCurrencyModel(Model):
    """A model with some number of agents."""
    def __init__(self, N):
        self.num_agents = N
        self.schedule = RandomActivation(self)
        self.exchange = Exchange(self)
        # Create agents
        #for i in range(self.num_agents):
        #    a = Miner(i, self)
        #    self.schedule.add(a)
        for i in range(self.num_agents):
            a = RandomTrader(i, self)
            self.schedule.add(a)
    def step(self):
        '''Advance the model by one step.'''
        self.schedule.step()
        self.exchange.clear() #todo should we do orders as they come in or once a day
        self.exchange.remove_old_orders()
