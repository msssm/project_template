class MiningPool():
    def __init__(self):
        self.members = []
        self.hashing_capability = 0.
        self.total_amount_mined = 0.
        self.prepare_next_step()

    def join(self, a):
        self.members.append(a)
        self.hashing_capability += a.hashing_capability

    def prepare_next_step(self):
        self.cash_spent_on_electricity_today = 0.
        self.btc_mined_today = 0.
        self.hardware_bought_today = 0.
