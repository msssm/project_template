## Installation on Euler
make sure to always load python when you login: 
```
module load new python/3.6.1
```

__download:__

```
git clone git@gitlab.ethz.ch:gclemens/simulating_cryptocurrency_markets.git
```
or
```
git clone https://gitlab.ethz.ch:gclemens/simulating_cryptocurrency_markets.git
```

__install:__

```
cd simulating_cryptocurrency_markets/code
python3 setup.py install --user
```

__run__

```
bsub -n 1 -W'00:10' sccm
```


__montecarlo simulations__
(using job arrays)

```
bsub -J "sccmjobname[1-100]" -W "00:10" 'sccm -o run_$LSB_JOBINDEX'

sccm-mcavg -i *.pkl -o montecarlo_average.pkl

sccm-plot -i montecarlo_average.pkl
```
