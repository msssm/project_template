from math import exp


class Equipment():
    def __init__(self, time_bought=0, hashrate=0, powerconsumption=0):  # TODO make names and underscores consistent
        self.time_bought = time_bought  # time at which the equipment is bought
        self.hash_rate = hashrate
        self.power_consumption = powerconsumption  # Watt

    def __str__(self):
        return 'Equipment with hashrate {} and power consumption {} that was bouht at time {}'.format(self.hash_rate, self.power_consumption, self.time_bought)
