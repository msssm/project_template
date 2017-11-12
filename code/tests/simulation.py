#!/usr/bin/env python3

from sccm import CryptoCurrencyModel
from tqdm import * #progress bar


def main(n_agents, n_steps):
    model = CryptoCurrencyModel(n_agents)
    # todo use batch runner from mesa for MC sim
    for i in tqdm(range(n_steps)):
        model.step()


if __name__ == "__main__":
    print("starting simulation.")
    main(250, 100)
    print("done.")

