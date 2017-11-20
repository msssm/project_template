#!/usr/bin/env python3

from sccm import CryptoCurrencyModel
from sccm.agents import *
from tqdm import * #progress bar


def main(n_steps):
    model = CryptoCurrencyModel(0)
    model.add_agent(Miner, 5000., 100)
    model.add_agent(RandomTrader, 10., 20)
    model.add_agent(Chartist, 20., 20)
    # todo use batch runner from mesa for MC sim
    for i in tqdm(range(n_steps)):
        model.step()


if __name__ == "__main__":
    print("starting simulation.")
    main(100)
    print("done.")
