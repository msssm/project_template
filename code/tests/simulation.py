#!/usr/bin/env python3

from sccm import *
from sccm.agents import *
from tqdm import * #progress bar


def main(n_steps):
    model = PaperModel()
    # todo use batch runner from mesa for MC sim
    for i in tqdm(range(n_steps)):
        model.step()


if __name__ == "__main__":
    print("starting simulation.")
    main(100)
    print("done.")
