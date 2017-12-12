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
bsub -J "sccmjobname[1-100]" -R "rusage[mem=4096]" -W "00:10" 'sccm -o results -id $LSB_JOBINDEX -i parameters.json'

sccm-mcavg -i results*.pkl -o ./montecarlo_

sccm-plot montecarlo_mean.pkl
```
