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
        self.later_agents = []
        # todo: put this in a separate function ?
        for i in range(self.num_agents):
            agentType = np.random.choice((RandomTrader, Chartist, Miner))
            a = agentType(self.next_available_id, self)
            self.next_available_id += 1
            # distribute initial cash/btc according to zipf law
            a.cash_available = numpy.random.zipf(a=1.)
            # a.bitcoin_available = 10.
            self.schedule.add(a)
        self.update_stats()
        # todo: should we generate all traders at beginning? only a few are active
        # todo: distribute initial cash according to zipf law
        rep = {'price': lambda model: model.exchange.current_price}
        rep['n_agents'] = lambda model: model.schedule.get_agent_count()

        #a_t = (Chartist, RandomTrader, Miner)
        #a_str = ('chartist', 'trader', 'miner')
        # p_t = (number_of_agents, bitcoin_of_agents, cash_of_agents)
        #p_str = ('n', 'btc', 'cash')

        # todo: create reporters using loop
        rep['n' + '_' + 'chartist'] = lambda model: model.number_of_agents[Chartist]
        rep['btc' + '_' + 'chartist'] = lambda model: model.bitcoin_of_agents[Chartist]
        rep['cash' + '_' + 'chartist'] = lambda model: model.cash_of_agents[Chartist]
        rep['n' + '_' + 'trader'] = lambda model: model.number_of_agents[RandomTrader]
        rep['btc' + '_' + 'trader'] = lambda model: model.bitcoin_of_agents[RandomTrader]
        rep['cash' + '_' + 'trader'] = lambda model: model.cash_of_agents[RandomTrader]
        rep['n' + '_' + 'miner'] = lambda model: model.number_of_agents[Miner]
        rep['btc' + '_' + 'miner'] = lambda model: model.bitcoin_of_agents[Miner]
        rep['cash' + '_' + 'miner'] = lambda model: model.cash_of_agents[Miner]
        # rep['n_chartist'] = lambda model: [type(a) for a in model.schedule.agents].count(Chartist)
        # rep['n_trader'] = lambda model: [type(a) for a in model.schedule.agents].count(RandomTrader)
        # rep['n_miner'] = lambda model: [type(a) for a in model.schedule.agents].count(Miner)

        rep['hashing_cap' + '_' + 'total'] = lambda model: model.hashing_cap_total
        rep['energy_cons' + '_' + 'total'] = lambda model: model.energy_cons_total
        rep['hashing_cap' + '_' + 'avg'] = lambda model: model.hashing_cap_avg
        rep['energy_cons' + '_' + 'avg'] = lambda model: model.energy_cons_avg
        rep['btc_mined' + '_' + 'avg'] = lambda model: model.btc_mined_avg


        self.datacollector = DataCollector(model_reporters=rep)

    def update_stats(self):
        self.bitcoin_of_agents = {Miner: 0, RandomTrader: 0, Chartist: 0}
        self.cash_of_agents = {Miner: 0, RandomTrader: 0, Chartist: 0}
        for a in self.schedule.agents:
            k = type(a)
            self.bitcoin_of_agents[k] += a.bitcoin_total
            self.cash_of_agents[k] += a.cash_total

        n = len(self.global_pool.members)
        if n == 0: n = 1 #prevent division by 0
        self.hashing_cap_total = self.global_pool.hashing_capability
        self.energy_cons_total = sum(m.power_consumption for m in self.global_pool.members if m.hasmined)
        self.hashing_cap_avg = self.hashing_cap_total/n
        self.energy_cons_avg = self.energy_cons_total/n
        self.btc_mined_avg = sum(m.btc_mined for m in self.global_pool.members if m.hasmined)/n

    def step(self):
        '''Advance the model by one step.'''
        # enter new agents:
        number_to_enter = Parameters.number_of_traders(self.schedule.time) - self.schedule.get_agent_count()
        if number_to_enter > 0:
            to_enter = self.later_traders[-number_to_enter:]
            self.later_traders = self.later_traders[:-number_to_enter]
            for i, kind, c, b in to_enter:
                a = kind(i, self)
                a.cash_available = c
                a.bitcoin_available = b
                self.number_of_agents[kind] += 1
                self.schedule.add(a)
        self.datacollector.collect(self)
        self.schedule.step()
        # todo should we do orders as they come in or once a day
        # self.exchange.clear()
        self.exchange.clear_rel_price_var()
        self.exchange.remove_old_orders()
        self.update_stats()

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
        number_of_initial_traders = Parameters.number_of_traders(0)  # 160 * 100 / Parameters.scaling_factor
        number_of_final_traders = Parameters.number_of_traders(m.t_end)  # ~36000 * 100 / Parameters.scaling_factor
        begin_price = 0.0649  # usd per btc

        def convert_richest_value_to_factor(richest_100, power=1.):
            parts_100 = sum(1/((i+1)**power) for i in range(Parameters.number_of_traders(0,100)))
            total_100 = parts_100 * richest_100
            total_1 = total_100 * 100
            total = total_1 / Parameters.scaling_factor
            parts = sum(1/((i+1)**power) for i in range(Parameters.number_of_traders(0)))  # for Parameters.scaling_factor
            richest = total / parts
            return richest

        begin_cash_richest_trader = convert_richest_value_to_factor(20587.)
        begin_bitcoin_value_in_cash_richest_trader = convert_richest_value_to_factor(4117.) # in usd
        begin_bitcoin_richest_trader = begin_bitcoin_value_in_cash_richest_trader / begin_price
        # total_initial_crypto_cash = 23274 * 100 / Parameters.scaling_factor
        for i in range(number_of_initial_traders):
            kind = Parameters.random_agent_kind(0)
            a = kind(i, m)
            a.cash_available = begin_cash_richest_trader/(i+1)
            a.bitcoin_available = begin_bitcoin_richest_trader/(i+1)
            m.number_of_agents[type(a)] += 1
            m.schedule.add(a)
        initial_cash_traders_afterwards_zipf_const = convert_richest_value_to_factor(200000., power = 0.6)
        later_traders = []
        for i in range(number_of_initial_traders, number_of_final_traders):
            kind = Parameters.random_agent_kind(m.t_end)
            #a = kind(i, m)
            cash_available = initial_cash_traders_afterwards_zipf_const/(i**0.6)
            bitcoin_available = 0.
            later_traders.append((i, kind, cash_available, bitcoin_available))
        np.random.shuffle(later_traders)  # order list randomly
        m.later_traders = later_traders
        m.update_stats()
        return m
