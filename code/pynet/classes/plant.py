class Plant:
    """
    Power plant of a power-grid network.
    """

    def __init__ (self, size, status):
        """
        size: the voltage it produces
        status: whether the power plant is working (True) or not (False)
        """
        self.size = size
        self.status = status

    def fail():
        self.status = False
