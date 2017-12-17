class ValueCache:
    '''Simple cache that allows to prevent having to constantly repeat expensive calculations'''
    def __init__(self, compute):
        self.cache = {}
        self.compute = compute  # routine to compute

    def clear(self):
        self.cache.clear()

    def __call__(self, *args):
        try:
            return self.cache[args]
        except KeyError:
            res = self.compute(*args)
            self.cache[args] = res
            return res
