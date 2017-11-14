class Equipment():
    def __init__(self, t, invest):
        self.bought = t #time at which the equipment is bought
        self.hash_rate = invest * R(t) #GH/s
        self.power_consumption = self.hash_rate * P(t) #Watt

    def price(self, t):
        return self.hash_rate/R(t)











# for test
def R(t):
    return 10
def P(t):
    return 10

def main():
    t = 1
    test_equip = Equipment(t, 10)
    print(test_equip.hash_rate)

if __name__ == '__main__':
    main()
