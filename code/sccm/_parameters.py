import numpy as np

from math import exp, log
from sccm.agents import *


class Parameters():
    scaling_factor = 1000  # factor by which we make the model smaller than the real world

    miners_can_have_negative_cash = True

    order_threshold = 1e-11 #throw away orders with amounts less than this

    @staticmethod
    def electricity_cost(t):  # epsilon
        return 1.4e-4

    @classmethod
    def bitcoins_mined_per_day(cls, t):  # B(t)
        # todo:  should we count mined bitcoins instead?
        if t < 853:
            return 7200./cls.scaling_factor
        else:
            return 3600./cls.scaling_factor

    @classmethod
    def number_of_traders(cls,t, scaling = None):  # N_t
        if scaling is None:
            scaling = cls.scaling_factor
        a = 2624.
        b = 0.002971
        c = 608 + 1  # our time starts at 0
        return round(a * exp(b * (t + c ))/scaling)

    @staticmethod
    def probability_to_be_a_miner(t):  # N_t
        a = 0.9425
        # TODO: next line has experimental value because of inconsistencies in paper;
        # write nminers should be 1000 at end, but fitting curve only gives 400
        # -0.00182 was calculated fitting the exp curve to one of the monte carlo runs from the files in the appendix of the paper
        b = -0.00182 #-0.002654
        return a * exp(b * (t-1))  # our time starts at 0, paper starts at 1

    probability_to_be_a_chartist = 0.3  # given it is not a miner

    probability_to_be_a_random_trader = 1-probability_to_be_a_chartist  # 0.7; given it is not a miner

    @classmethod
    def random_agent_kind(cls, t):
        if np.random.random() < cls.probability_to_be_a_miner(t):
            return Miner
        elif np.random.random() < cls.probability_to_be_a_random_trader:
            return RandomTrader
        else:
            return Chartist
