class MiningPool():
    def __init__(self):
        self.members = []
        self.hashing_capability = 0.

    def join(self, a):
        self.members.append(a)
        self.hashing_capability += a.hashing_capability
