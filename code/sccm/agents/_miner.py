from ._agent import CryptoCurrencyAgent


class Miner(CryptoCurrencyAgent):
    """A Miner"""
    def __init__(self, unique_id, model):
        super().__init__(unique_id, model)
        self.gamma1_ = [0.5]  # percentage of cash allocated to buy
        if t == 0:
            # take decision to buy in the first 60 days uniform distr
            # todo use np
            self.tID = random.choice(range(61))
        else:
            self.update_tID()  # time when to buy new mining hardware

    def update_tID(self):
        mu, sigma = 0, 6.
        self.tID = t + round(60 + np.random.normal(mu, sigma))

    def gamma(self, t):
        return 0.5 * self.gamma1(self.clock)

    def gamma1(self, t):
        return self.gamma1_[t-te]

    def ru(self, t):  # hardware capability of units bought
        if t == te:
            return gamma1(self.clock) * c(self.clock) * R(self.clock)
        else:
            return (gamma1(self.clock) * c(self.clock) + gamma(self.clock) * b(self.clock) * self.exchange.p(self.clock)) * R(self.clock)

    def r(self, t):  # hashing capability
        return sum(self.ru(s) for s in range(self.te, t))

    def e(self, t):  # total elextricity cost
        return sum(epsilon * P(s) * self.r(s) * 24 for s in range(self.te, t))

    def b_mined(self, t):  # amount mined at day t
        return self.r(self.clock)/rtot(self.clock) * B(self.clock)

    def buy_hardware(self):
        # todo
        # buy hardware
        # divest hardware older than one year
        pass

    def step(self):
        if t == self.tID:
            self.buy_hardware()
            # todo
            # set next time when to buy
            self.update_tID()
        self.bitcoin_available += self.b_mined(self.clock)
        None
