import numpy as np
import random
import time

from mesa import Model
from mesa.time import RandomActivation
from mesa.datacollection import DataCollector
from sccm.agents import *
from sccm.market import *
from ._parameters import Parameters, calc_factor_total_vs_richest

def zipf(i, cash, exponent=-1.):  # zero indexed
    return cash * (i+1)**exponent

class PaperModel(Model):
    def __init__(self, parameters, seed=None):
        # super().__init__(seed)  # mesa automatic seeding is broken: TODO: bugreport
        if seed is None:
            seed = int(time.time())
        self.seed = seed
        print('seed: {}'.format(self.seed))
        random.seed(seed)
        np.random.seed(seed)
        self.parameters = parameters
        self.running = True
        self.num_agents = parameters.number_of_agents(0)
        self.t_end = parameters['Model']['number_of_steps']
        self.schedule = RandomActivation(self)
        self.exchange = Exchange(self)
        self.global_pool = MiningPool()
        self.number_of_agents = {Miner: 0, RandomTrader: 0, Chartist: 0}
        self.later_agents = []  # TODO: could use deque
        self.add_initial_agents()
        self.prepare_later_agents()
        self.update_stats()
        self.add_datacollector()

    def add_datacollector(self):

        # todo: should we generate all traders at beginning? only a few are active
        # todo: distribute initial cash according to zipf law
        rep = {'price': lambda model: model.exchange.current_price}
        rep['n_agents'] = lambda model: model.schedule.get_agent_count()

        # todo: create reporters using loop, might as well assign some member functions instead lambdas
        rep['n' + '_' + 'chartist'] = lambda model: model.number_of_agents[Chartist]
        rep['btc' + '_' + 'chartist'] = lambda model: model.bitcoin_of_agents[Chartist]
        rep['cash' + '_' + 'chartist'] = lambda model: model.cash_of_agents[Chartist]
        rep['n' + '_' + 'trader'] = lambda model: model.number_of_agents[RandomTrader]
        rep['btc' + '_' + 'trader'] = lambda model: model.bitcoin_of_agents[RandomTrader]
        rep['cash' + '_' + 'trader'] = lambda model: model.cash_of_agents[RandomTrader]
        rep['n' + '_' + 'miner'] = lambda model: model.number_of_agents[Miner]
        rep['btc' + '_' + 'miner'] = lambda model: model.bitcoin_of_agents[Miner]
        rep['cash' + '_' + 'miner'] = lambda model: model.cash_of_agents[Miner]

        rep['hashing_cap' + '_' + 'total'] = lambda model: model.hashing_cap_total
        rep['energy_cons' + '_' + 'total'] = lambda model: model.energy_cons_total
        rep['hashing_cap' + '_' + 'avg'] = lambda model: model.hashing_cap_avg
        rep['energy_cons' + '_' + 'avg'] = lambda model: model.energy_cons_avg

        rep['n_orders_sell'] = lambda model: len(model.exchange.orderbook['sell'])
        rep['n_orders_sellinf'] = lambda model: len(model.exchange.orderbook['sellinf'])
        rep['n_orders_buy'] = lambda model: len(model.exchange.orderbook['buy'])

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
        self.energy_cons_total = sum(m.power_consumption for m in self.global_pool.members)
        self.hashing_cap_avg = self.hashing_cap_total/n
        self.energy_cons_avg = self.energy_cons_total/n


    def add_agent(self, a):
            self.number_of_agents[type(a)] += 1
            self.schedule.add(a)
        # todo: enter agents into the market over time

    def add_initial_agents(self):
        number_of_initial_traders = self.parameters.number_of_agents(0)
        inv_factor_cash = self.parameters.scalingfactor * calc_factor_total_vs_richest(number_of_initial_traders, exponent=self.parameters['Model']['zipf_total_cash_start']['exponent'], start=0)
        inv_factor_bitcoin = self.parameters.scalingfactor * calc_factor_total_vs_richest(number_of_initial_traders, exponent=self.parameters['Model']['zipf_total_cash_bitcoin_equivalent_start']['exponent'], start=0)
        for i in range(number_of_initial_traders):
            Kind = self.parameters.random_agent_kind(0)
            cash =   zipf(i, **self.parameters['Model']['zipf_total_cash_start'])/ inv_factor_cash
            bitcoin = zipf(i, **self.parameters['Model']['zipf_total_cash_bitcoin_equivalent_start'])/inv_factor_bitcoin  / self.parameters['Model']['initial_price']
            a = Kind(i, self, cash, bitcoin)
            self.add_agent(a)

    def prepare_later_agents (self):
        number_of_initial_traders = self.parameters.number_of_agents(0)
        number_of_final_traders = self.parameters.number_of_agents(self.t_end)
        inv_factor = self.parameters.scalingfactor * calc_factor_total_vs_richest(number_of_final_traders, exponent=self.parameters['Model']['zipf_total_cash_later']['exponent'], start=number_of_initial_traders)

        #TODO TODO TODO where should i for zipf start from?? 0 or number_of_initial_traders??
        for i in range(number_of_final_traders-number_of_initial_traders):  # need range from 0 for zipf
            kind = self.parameters.random_agent_kind(self.t_end)
            cash = zipf(i, **self.parameters['Model']['zipf_total_cash_later'])/inv_factor
            bitcoin = 0.
            self.later_agents.append((kind,(i+number_of_initial_traders, self, cash, bitcoin)))  # i must be unique
        np.random.shuffle(self.later_agents)  # order list randomly

    def step(self):
        '''Advance the model by one step.'''
        # enter new agents:
        self.exchange.prepare_next_step()
        number_to_enter = self.parameters.number_of_agents(self.schedule.time) - self.schedule.get_agent_count()
        if number_to_enter > 0:
            to_enter = self.later_agents[-number_to_enter:]
            self.later_agents = self.later_agents[:-number_to_enter]
            for kind, params in to_enter:
                self.add_agent(kind(*params))
        self.schedule.step()
        self.exchange.remove_old_orders()
        self.update_stats()
        self.datacollector.collect(self)

    def save_results(self, name = ''):
        gini = self.datacollector.get_model_vars_dataframe()
        gini.to_pickle(name + 'statisticss.pkl')
        self.parameters.save(name + 'parameters.json')
