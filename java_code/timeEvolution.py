# -*- coding: utf-8 -*-
from matplotlib.pylab import *
from numpy import *

colors = array(
    ['dodgerblue', 'darkorange', 'g', 'red', 'purple', 'brown', 'violet',
     'grey', 'y', 'lightskyblue', 'black',
     'magenta'])


def analyse_median_danger(test_set, i):
    to_do = "from %s.counter import *" % test_set

    exec(to_do, globals())

    median_danger_time_evolution = zeros((n - 5, m))

    t = linspace(0, 1, n - 5)
    title('Time Evolution of Average of Median Danger')

    for j in range(0, m):  # iterating over different seeds
        for k in range(0, n - 5):  # iterating over time steps
            filename = 'out_%s_%s' % (j, k)
            exec("from %s.%s import *" % (test_set, filename),
                 globals())  # importing data for given seed and time steps
            median_danger_time_evolution[k, j] += medianDanger
    y = average(median_danger_time_evolution, axis=1)
    ylabel('Median Danger')
    ymax = max(y)
    if (test_set == 'control'):
        linewidth_ = 2
    else:
        linewidth_ = 1.2
    plot(t, y / ymax, colors[i], linewidth=linewidth_, label=test_set)


def analyse_is_participating(test_set, i):
    toDo = "from %s.counter import *" % test_set

    exec(toDo, globals())

    is_participating_time_evolution = zeros(n - 5)
    t = linspace(0, 1, n - 5)
    ylim(0, 1)
    title('Time Evolution of Participation Rate')
    for j in range(0, m):  # iterating over different seeds
        for k in range(0, n - 5):  # iterating over time steps
            filename = 'out_%s_%s' % (j, k)
            exec("from %s.%s import *" % (test_set, filename),
                 globals())  # importing data for given seed and time steps
            is_participating_time_evolution[k] += sum(isParticipating) / (
            500 * 50)

    if (test_set == 'control'):
        linewidth_ = 2
    else:
        linewidth_ = 1.2

    plot(t, is_participating_time_evolution, colors[i], linewidth=linewidth_,
         label=test_set)
    ylabel('Participation Rate')


if __name__ == '__main__' and __package__ is None:
    import sys, os.path as path

    # Make sure we can import the out.py files
    sys.path.append(path.dirname(path.dirname(path.abspath(__file__))))

    # isParticipating: iterate over the configs listed in configs.sim
    with open("configs.sim") as f:
        next(f)
        figure(figsize=(7, 5))
        k = 0
        for test_set in f:
            analyse_is_participating(test_set.strip(), k)
            k += 1

    legend(prop={'size': 8}, fancybox=True, ncol=3, loc=1)
    xlabel('Time')
    savefig('isParticipating_timeEvolution.png', dpi=600)

    # Median Danger: iterate over the configs listed in configs.sim
    with open("configs.sim") as f:
        next(f)
        figure(figsize=(7, 5))
        k = 0
        for test_set in f:
            analyse_median_danger(test_set.strip(), k)
            k += 1

    legend(prop={'size': 8}, fancybox=True, ncol=3, loc=1)
    xlabel('Time')
    savefig('medianDanger_timeEvolution.png', dpi=600)
