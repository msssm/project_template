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
        self.number_of_agents = {Miner: 0, RandomTrader: 0, Chartist: 0}

        # todo: put this in a separate function ?
        for i in range(self.num_agents):
            agentType = np.random.choice((RandomTrader, Chartist, Miner))
            a = agentType(self.next_available_id, self)
            self.next_available_id += 1
            # distribute initial cash/btc according to zipf law
            a.cash_available = numpy.random.zipf(a=1.)
            # a.bitcoin_available = 10.
            self.schedule.add(a)
        # todo: should we generate all traders at beginning? only a few are active
        # todo: distribute initial cash according to zipf law
        rep = {'price': lambda model: model.exchange.current_price}
        rep['nagents'] = lambda model: model.schedule.get_agent_count()
        rep['nchartist'] = lambda model: model.number_of_agents[Chartist]
        rep['ntrader'] = lambda model: model.number_of_agents[RandomTrader]
        rep['nminer'] = lambda model: model.number_of_agents[Miner]
        # rep['nchartist'] = lambda model: [type(a) for a in model.schedule.agents].count(Chartist)
        # rep['ntrader'] = lambda model: [type(a) for a in model.schedule.agents].count(RandomTrader)
        # rep['nminer'] = lambda model: [type(a) for a in model.schedule.agents].count(Miner)

        self.datacollector = DataCollector(model_reporters=rep)

    def step(self):
        '''Advance the model by one step.'''
        # enter new agents:
        number_to_enter = Parameters.number_of_traders(self.schedule.time) - self.schedule.get_agent_count()
        if number_to_enter > 0:
            to_enter = self.later_traders[-number_to_enter:]
            self.later_traders = self.later_traders[:-number_to_enter]
            for a in to_enter:
                self.number_of_agents[type(a)] += 1
                self.schedule.add(a)
        self.datacollector.collect(self)
        self.schedule.step()
        # todo should we do orders as they come in or once a day
        # self.exchange.clear()
        self.exchange.clear_rel_price_var()
        self.exchange.remove_old_orders()

    def add_agent(self, agentType, cash, n=1, bitcoin=0.):
        for i in range(n):
            a = agentType(self.next_available_id, self)
            self.next_available_id += 1
            a.cash_available = cash
            a.bitcoin_available = bitcoin
            self.number_of_agents[agentType] += 1
            self.schedule.add(a)
    # todo: enter agents into the market over time
    def PaperModel():
        m = CryptoCurrencyModel(0)
        m.t_end = 365 * 5
        number_of_initial_traders = Parameters.number_of_traders(0)  # 160
        number_of_final_traders = Parameters.number_of_traders(m.t_end)  # ~36000
        begin_price = 0.0649  # usd per btc
        begin_cash_richest_trader = 20587
        begin_bitcoin_value_in_cash_richest_trader = 4117  # in usd
        begin_bitcoin_richest_trader = begin_bitcoin_value_in_cash_richest_trader/begin_price
        # total_initial_crypto_cash = 23274
        for i in range(number_of_initial_traders):
            kind = Parameters.random_agent_kind(0)
            a = kind(i, m)
            a.cash_available = begin_cash_richest_trader/(i+1)
            a.bitcoin_available = begin_bitcoin_richest_trader/(i+1)
            m.number_of_agents[type(a)] += 1
            m.schedule.add(a)
        initial_cash_traders_afterwards_zipf_const = 200000
        later_traders = []
        for i in range(number_of_initial_traders, number_of_final_traders):
            kind = Parameters.random_agent_kind(m.t_end)
            a = kind(i, m)
            a.cash_available = initial_cash_traders_afterwards_zipf_const/(i**0.6)
            a.bitcoin_available = 0.
            later_traders.append(a)
        np.random.shuffle(later_traders)  # order list randomly
        m.later_traders = later_traders
        return m
