from math import exp


class Equipment():
    def __init__(self, time_bought=0, hash_rate=0, power_consumption=0):
        self.time_bought = time_bought  # time at which the equipment is bought
        self.hash_rate = hash_rate
        self.power_consumption = power_consumption  # Watt

    def __str__(self):
        return 'Equipment with hashrate {} and power consumption {} that was bouht at time {}'.format(self.hash_rate, self.power_consumption, self.time_bought)

    @classmethod
    def buy(cls, t, cash):
        h = cls.hashrate_available_per_dollar(t) * cash
        p = h * cls.power_consumption_per_hashrate_available(t)  # Watt
        return cls(t, h, p)

    @staticmethod
    def hashrate_available_per_dollar(t):
        a = 8.635e4
        b = 0.006318
        return a * exp(b*t)

    @staticmethod
    def power_consumption_per_hashrate_available(t):
        a = 4.649e-7
        b = -0.004055
        return a * exp(b*t)
