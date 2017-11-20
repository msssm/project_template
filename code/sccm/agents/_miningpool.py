class MiningPool():
    def __init__(self):
        self.members = []
        self.join = self.members.append
    @property
    def hashing_capability(self):
        return sum(a.hashing_capability for a in self.members) # todo: more efficient
