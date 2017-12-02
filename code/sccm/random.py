import numpy as np


def convert_lognormal_to_underlying_normal(mulog, sigmalog):
    # see: https://de.wikipedia.org/wiki/Logarithmische_Normalverteilung#Beziehung_zur_Normalverteilung
    varlog = sigmalog**2
    sigma = np.sqrt(np.log(varlog/(mulog**2)+1))
    mu = np.log(mulog) - sigma**2 / 2
    return mu, sigma

def lognormal(mean, sigma, *args):  # uses mean and stddev of lognormal distr instead of underlying normal distr
    return np.random.lognormal(*convert_lognormal_to_underlying_normal(mean, sigma), *args)
