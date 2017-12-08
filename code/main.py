#!/usr/bin/env python3

from sccm import *
from tqdm import *

def run():
	p = Parameters()
	p['Model']['scalingfactor'] = 1000
	model = PaperModel(p)
	for i in tqdm(range(1000)): #todo use batch runner from mesa for MC sim
		model.step()
	model.save_results()

if __name__ == "__main__":
	run()
