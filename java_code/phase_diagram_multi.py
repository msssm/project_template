import numpy as np
import matplotlib.pylab as plt
from scipy import interpolate


def phase_diagram(x, y, danger):
    # levels to be considered safe/dangerous
    safe_danger = 0.4
    danger1 = 0.9
    danger2 = 1.4

    # interpolates the data to get a full grid
    grid_x, grid_y = mgrid[0:99:200j, 0:99:200j]
    points = (x, y)
    grid_danger = interpolate.griddata(points, danger, (grid_x, grid_y),
                                       method='cubic')

    plt.figure()
    # plots danger diagram
    im_d = plt.imshow(grid_danger, extent=(0, 99, 0, 99), origin='upper',
                      cmap='hot', vmin=safe_danger, vmax=danger2 + 0.2)
    plt.axis('off')
    cbar_d = plt.colorbar(im_d, fraction=0.046, pad=0.04, orientation='vertical',
                         ticks=[safe_danger, danger1, danger2])
    cbar_d.ax.set_yticklabels(['Low', 'Medium', 'High'])
    plt.title('Danger Level')

    plt.show()


# This program shows danger levels in a phase
# diagram as an average of a set of 'out.py' files

# Average function which looks for two equals points
def average_(points2, d2):
    global continuous_danger_level_
    global points
    continuous_danger_level_ = np.append(continuous_danger_level_, d2)
    points_[0] = np.append(points_[0], points2[0])
    points_[1] = np.append(points_[1], points2[1])


# Imports and averages the data-set from the out files
def analyse2(test_set, time):

    # Import the data from the out.py files
    to_do = "from %s.counter import *" % test_set
    exec(to_do, globals())

    global points_
    global continuous_danger_level_
    exec("from %s.out_0_0 import *" % (test_set), globals())
    points_ = [x, y]
    continuous_danger_level_ = continuousDangerLevel

    # Iterate over the seeds
    for i in range(0, m):
        try:
            filename_ = 'out_%s_%s' % (i, time)
            exec("from %s.%s import *" % (test_set, filename_), globals())
        except ModuleNotFoundError:
            break

        # Average over the seeds
        average_((x, y), continuousDangerLevel)

    phase_diagram(points_[0], points_[1], continuous_danger_level_)


if __name__ == '__main__' and __package__ is None:
    import sys, os.path as path

    sys.path.append(path.dirname(path.dirname(path.abspath(__file__))))

    # Iterate over all the config files in configs.sim
    with open("configs.sim") as f:
        next(f)
        for test_set in f:
            time = int(input('Choose time ->    '))
            analyse2(test_set.strip(), time)
