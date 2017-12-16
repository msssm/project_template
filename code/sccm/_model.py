import numpy as np
import random
import time
import pickle

from mesa import Model
from mesa.time import RandomActivation
from mesa.datacollection import DataCollector
from tqdm import *
from sccm.agents import *
from sccm.market import *
from ._parameters import Parameters, calc_factor_total_vs_richest

def zipf(i, cash, exponent=-1.):  # zero indexed
    return cash * (i+1)**exponent

class PaperModel(Model):
    def __init__(self, parameters, seed=None):
        # super().__init__(seed)  # mesa automatic seeding is broken: saves current time into seed, but then seeds np and random with None; they do their own default seeding that might not be correlated with the time mesa saves into seed TODO: bugreport
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
        rep = {'price': lambda model: model.exchange.current_price}
        rep['n_agents'] = lambda model: model.schedule.get_agent_count()

        # todo: create reporters using loop, might as well assign some member functions instead lambdas
        rep['n' + '_' + 'chartist'] =   lambda model: model.number_of_agents[Chartist]
        rep['btc' + '_' + 'chartist'] = lambda model: model.bitcoin_of_agents[Chartist]
        rep['cash' + '_' + 'chartist'] =lambda model: model.cash_of_agents[Chartist]
        rep['n' + '_' + 'trader'] =     lambda model: model.number_of_agents[RandomTrader]
        rep['btc' + '_' + 'trader'] =   lambda model: model.bitcoin_of_agents[RandomTrader]
        rep['cash' + '_' + 'trader'] =  lambda model: model.cash_of_agents[RandomTrader]
        rep['n' + '_' + 'miner'] =      lambda model: model.number_of_agents[Miner]
        rep['btc' + '_' + 'miner'] =    lambda model: model.bitcoin_of_agents[Miner]
        rep['cash' + '_' + 'miner'] =   lambda model: model.cash_of_agents[Miner]

        rep['hashing_cap' + '_' + 'total'] =    lambda model: model.hashing_cap_total
        rep['energy_cons' + '_' + 'total'] =    lambda model: model.energy_cons_total
        rep['hashing_cap' + '_' + 'avg'] =      lambda model: model.hashing_cap_avg  # TODO: redundant
        rep['energy_cons' + '_' + 'avg'] =      lambda model: model.energy_cons_avg  # TODO: redundant

        rep['n_orders_sell_left'] =     lambda model: len(model.exchange.orderbook['sell'])
        rep['n_orders_sellinf_left'] =  lambda model: len(model.exchange.orderbook['sellinf'])
        rep['n_orders_buy_left'] =      lambda model: len(model.exchange.orderbook['buy'])

        rep['price_max'] =      lambda model: np.max(model.exchange.allprices[-1])  if len(model.exchange.allprices[-1]) > 0 else 0.
        rep['price_min'] =      lambda model: np.min(model.exchange.allprices[-1])  if len(model.exchange.allprices[-1]) > 0 else 0.
        rep['price_open'] =     lambda model: model.exchange.allprices[-1][0]       if len(model.exchange.allprices[-1]) > 0 else 0.
        rep['price_close'] =    lambda model: model.exchange.allprices[-1][-1]      if len(model.exchange.allprices[-1]) > 0 else 0.

        rep['n_transactions'] = lambda model: len(model.exchange.allprices[-1])
        rep['transaction_volume_btc'] =     lambda model: model.exchange.tradevolume['bitcoin']
        rep['transaction_volume_cash'] =    lambda model: model.exchange.tradevolume['cash']

        rep['cash_spent_on_electricity'] =     lambda model: model.global_pool.cash_spent_on_electricity_today #TODO: redundant: divide by electricity cost to get energy_cons, might be useful if electricity cost is not constant and not stored otherwise
        rep['cash_spent_on_hardware'] =     lambda model: model.global_pool.hardware_bought_today #usd

        rep['btc_mined'] =    lambda model: model.global_pool.btc_mined_today  # TODO: this is redundant information, could just take difference of sum of bitcoin of agents between days

        rep['stddev_price_abs_return'] = lambda model: model.exchange.stddev_price_abs_return(model.parameters['Trader']['strategy_limit']['timewindow'])

        #TODO can calculate divested hardware/hashrate from cash_spent_on_hardware, hashrate avail and delta hashing_cap


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

    def add_initial_agents(self):
        number_of_initial_traders = self.parameters.number_of_agents(0)
        inv_factor_cash = self.parameters.scalingfactor * calc_factor_total_vs_richest(number_of_initial_traders, exponent=self.parameters['Model']['zipf_total_cash_start']['exponent'])
        inv_factor_bitcoin = self.parameters.scalingfactor * calc_factor_total_vs_richest(number_of_initial_traders, exponent=self.parameters['Model']['zipf_total_cash_bitcoin_equivalent_start']['exponent'])
        for i in range(number_of_initial_traders):
            Kind = self.parameters.random_agent_kind(0)
            cash =   zipf(i, **self.parameters['Model']['zipf_total_cash_start'])/ inv_factor_cash
            bitcoin = zipf(i, **self.parameters['Model']['zipf_total_cash_bitcoin_equivalent_start'])/inv_factor_bitcoin  / self.parameters['Model']['initial_price']
            a = Kind(i, self, cash, bitcoin)
            self.add_agent(a)

    def prepare_later_agents (self):
        number_of_initial_traders = self.parameters.number_of_agents(0)
        number_of_final_traders = self.parameters.number_of_agents(self.t_end)
        number_of_later_traders = number_of_final_traders-number_of_initial_traders
        inv_factor = self.parameters.scalingfactor * calc_factor_total_vs_richest(number_of_later_traders - , exponent=self.parameters['Model']['zipf_total_cash_later']['exponent'])
        for i in range(number_of_later_traders):  # need range from 0 for zipf
            kind = self.parameters.random_agent_kind(self.t_end)
            cash = zipf(i, **self.parameters['Model']['zipf_total_cash_later'])/inv_factor
            bitcoin = 0.
            self.later_agents.append((kind,(i+number_of_initial_traders, self, cash, bitcoin)))  # i must be unique
        np.random.shuffle(self.later_agents)  # order list randomly

    def step(self):
        '''Advance the model by one step.'''
        # enter new agents:
        self.exchange.prepare_next_step()
        self.global_pool.prepare_next_step()
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

    def save_results(self, name = '', save_allprices=False):
        gini = self.datacollector.get_model_vars_dataframe()
        gini.to_pickle(name + 'statistics.pkl')
        self.parameters.save(name + 'parameters.json')
        if save_allprices:
            with open(name + 'allprices.pkl', 'wb') as f:
                pickle.dump(self.exchange.allprices, f)


    def run(self, steps=None):
        if steps is None:
            steps = self.parameters['Model']['number_of_steps'] - self.schedule.time
        for _ in tqdm(range(steps)):
            self.step()
