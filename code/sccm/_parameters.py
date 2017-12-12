import numpy as np
import json
import copy

from math import exp, log
from sccm.agents import *
from sccm.math import general_exponential

defaultparameters = {}

defaultparameters['Model'] = {}

defaultparameters['Trader'] = {}
defaultparameters['Trader']['RandomTrader'] = {}
defaultparameters['Trader']['Chartist'] = {}
defaultparameters['Miner'] = {}

defaultparameters['Model']['scalingfactor'] = 100
defaultparameters['Model']['initial_price'] = 0.0649
defaultparameters['Model']['electricity_cost'] = 1.4e-4
defaultparameters['Model']['number_of_steps'] = 1856

def calc_factor_total_vs_richest(n, exponent=-1., start=0):  # TODO: paper says with -1 one could somehow use euler-mascheroni const + log...
    return sum((i+1)**exponent for i in reversed(range(0, n)))

#calc_factor_total_vs_richest(160) = 5.655511224939

defaultparameters['Model']['zipf_total_cash_start'] = {'cash': 20587 * calc_factor_total_vs_richest(160, -1.) * 100, 'exponent': -1.}  #
defaultparameters['Model']['zipf_total_cash_bitcoin_equivalent_start'] = {'cash': 4117. * calc_factor_total_vs_richest(160) * 100, 'exponent': -1.}  #          #usd, divide by initial price to get initial bitcoin
defaultparameters['Model']['zipf_total_cash_later'] = {'cash': 200000 * calc_factor_total_vs_richest(39694, -0.6, 160) * 100, 'exponent': -0.6}
defaultparameters['Model']['zipf_later_start_at_zero'] = False  # start i for zipf law at zero or start at n_initial_agents+1


defaultparameters['Model']['number_of_agents'] = {'a' : 2624., 'b': 0.002971, 'c': 608}  # a*exp(b*(t+c))
defaultparameters['Model']['fraction_miners'] = {'a' : 0.9425, 'b': -0.002654, 'c': 0.}  # a*exp(b*(t+c))
defaultparameters['Model']['fraction_random_traders'] = 0.7  # 70% random traders, 30% chartists of all non-miners

defaultparameters['Model']['hashrate_available_per_dollar'] = {'a' : 8.635e4, 'b': 0.006318, 'c': 0.}  # a*exp(b*(t+c))
defaultparameters['Model']['power_consumption_available_per_hashrate'] = {'a' : 4.649e-7, 'b': -0.004055, 'c': 0.}  # a*exp(b*(t+c))
defaultparameters['Model']['bitcoin_mined_per_day'] = {0: 7200, 853: 3600}  # key means starting from that date value is valid until next key, needs to be sorted!!

defaultparameters['Trader']['strategy_limit'] = {'mu' : 1.05, 'K': 2.4, 'sigma_max':0.03, 'sigma_min': 0.01 , 'timewindow': 30}  # use value 30 from the older paper

defaultparameters['Trader']['RandomTrader']['tradeprobability'] = 0.1
defaultparameters['Trader']['RandomTrader']['fraction_cash_bitcoin_to_trade'] = {'mu': 0.25, 'sigma':0.2 }
defaultparameters['Trader']['RandomTrader']['probability_market_order'] = 0.2
defaultparameters['Trader']['RandomTrader']['order_expiration_time'] = {'mu': 3, 'sigma': 1}

defaultparameters['Trader']['Chartist']['fraction_cash_bitcoin_to_trade'] = {'mu': 0.4, 'sigma': 0.2}
defaultparameters['Trader']['Chartist']['tradeprobability'] = 0.5
defaultparameters['Trader']['Chartist']['probability_market_order'] = 0.7
defaultparameters['Trader']['Chartist']['strategy_timewindow'] = {'mu':20, 'sigma': 1.}
defaultparameters['Trader']['Chartist']['strategy_pricevariance_threshold'] = 0.01

defaultparameters['Miner']['delta_time_to_decide_on_new_hardware'] = {'mu': 60, 'sigma': 6}
defaultparameters['Miner']['fraction_cash_to_buy_hardware'] = {'mu': 0.6, 'sigma': 0.15}
defaultparameters['Miner']['fraction_bitcoin_to_be_sold_for_hardware'] = {'mu': 0.3, 'sigma': 0.075} #half of fraction_cash_to_buy_hardware TODO check half is correct
defaultparameters['Miner']['initial_hardware'] = {'hashrate': 0.00173, 'powerconsumption': 75}  # corei5
defaultparameters['Miner']['age_divest_hardware'] = 365

defaultparameters['Miner']['buy_immediately'] = False


class Parameters():  # TODO: inherit from dict?
    def __init__(self, pdict = None):
        if pdict is None:
            pdict = copy.deepcopy(defaultparameters)
        self._pdict = pdict
    @property
    def scalingfactor(self):  # for convenience
        return self._pdict['Model']['scalingfactor']

    #TODO: is there a better way?
    def __getitem__(self, key):
        return self._pdict[key]

    def __setitem__(self, key, value):
        self._pdict[key] = value

    def save(self, filename='parameters.json'):
        with open(filename, 'w') as f:
            json.dump(self._pdict, f)

    def load(self, filename='parameters.json'):
        with open(filename, 'r') as f:
            self._pdict = json.load(f)
        d = self._pdict['Model']['bitcoin_mined_per_day']
        d_intkeys = {int(key):value for key,value in d.items()}  # this seems to sort it as well
        self._pdict['Model']['bitcoin_mined_per_day'] = dict(sorted(d_intkeys.items()))  # probably not necessary to sort again here

    def electricity_cost(self, t=0.):  # epsilon
        return self._pdict['Model']['electricity_cost']

    def bitcoins_mined_per_day(self, t):
        d = self._pdict['Model']['bitcoin_mined_per_day']
        condition = [t >= k for k in d.keys()]
        values = list(d.values())
        res = np.piecewise(t, condition, values)
        return float(res)/self.scalingfactor

    def number_of_agents(self, t):
        return round(general_exponential(t+1, **self._pdict['Model']['number_of_agents'])/self.scalingfactor)

    def fraction_miners(self, t):  # N_t
        return general_exponential(t+1, **self._pdict['Model']['fraction_miners'])

    def random_agent_kind(self, t):
        if np.random.random() < self.fraction_miners(t):
            return Miner
        elif np.random.random() < self._pdict['Model']['fraction_random_traders']:
            return RandomTrader
        else:
            return Chartist

    def hashrate_available_per_dollar(self, t):
        return general_exponential(t+1, **self._pdict['Model']['hashrate_available_per_dollar'])

    def power_consumption_available_per_hashrate(self, t):
        return general_exponential(t+1, **self._pdict['Model']['power_consumption_available_per_hashrate'])

    def buy(self, t, cash):  # todo: better name
        h = self.hashrate_available_per_dollar(t) * cash
        p = h * self.power_consumption_available_per_hashrate(t)  # Watt
        return Equipment(t, h, p)
