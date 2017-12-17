from math import exp, log

def general_exponential(t,a,b,c): # call like general_exponentials(**{'a': 1, 'b': 1., 'c': 0.}, t=1.)
    return a*exp(b*(t+c))

def clip(x, lower, upper):
    assert (lower <= upper)
    return max(min(x, upper), lower)
