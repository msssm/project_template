import numpy as np
from math import exp, log
from sccm.cache import ValueCache

def _convert_lognormal_to_underlying_normal(mulog, sigmalog):
    # see: https://de.wikipedia.org/wiki/Logarithmische_Normalverteilung#Beziehung_zur_Normalverteilung
    varlog = sigmalog**2
    sigma = np.sqrt(np.log(varlog/(mulog**2)+1))
    mu = np.log(mulog) - sigma**2 / 2
    return mu, sigma

convert_lognormal_to_underlying_normal = ValueCache(_convert_lognormal_to_underlying_normal)

def lognormal(mu, sigma, *args):  # uses mean and stddev of lognormal distr instead of underlying normal distr
    return np.random.lognormal(*convert_lognormal_to_underlying_normal(mu, sigma), *args)

def normal(mu, sigma, *args):  # uses mean and stddev of lognormal distr instead of underlying normal distr
    return np.random.normal(mu, sigma, *args)

def general_exponentials(t,a,b,c): # call like general_exponentials(**{'a': 1, 'b': 1., 'c': 0.}, t=1.)
    return a*exp(b*(t+c))
