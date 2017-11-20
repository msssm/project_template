from math import exp

class Parameters():
    @staticmethod
    def electricity_cost(t):  # epsilon
        return 1.4e-4
    @staticmethod
    def bitcoins_mined_per_day(t):  # B(t)
        # todo:  should we count mined bitcoins instead?
        if t < 853:
            return 72.
        else:
            return 36.
