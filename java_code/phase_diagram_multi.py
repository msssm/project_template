
import numpy as np
import matplotlib.pylab as plt
#from phase_diagram import phaseDiagram
from scipy import interpolate

# Had trouble importing it from phase_diagram, so just copied it
def phaseDiagram(x, y, danger):

    # levels to be considerated safe/dangerous
    safeDanger = 0.4
    danger1 = 0.9
    danger2 = 1.4


    # interpolates the data to get a full grid
    grid_x, grid_y = mgrid[0:99:200j, 0:99:200j]
    points = (x, y)
    grid_danger = interpolate.griddata(points, danger, (grid_x, grid_y),method='cubic')
#    grid_F = interpolate.griddata(points, F, (grid_x, grid_y),method='cubic')

    plt.figure()
    # plots density diagram
#    plt.subplot(121)
#    plt.subplots_adjust(wspace=0.5)
    imD = plt.imshow(grid_danger, extent=(0,99,0,99), origin='upper', cmap='hot', vmin=safeDanger, vmax=danger2+0.2)
    plt.axis('off')
    cbarD = plt.colorbar(imD, fraction=0.046, pad=0.04, orientation='vertical', ticks=[safeDanger, danger1, danger2])
    cbarD.ax.set_yticklabels(['Low', 'Medium', 'High'])
    plt.title('Danger Level')

    # plots force diagram
#    plt.subplot(122)
#    imF = plt.imshow(grid_F, extent=(0,99,0,99), origin='upper', cmap='hot', vmin=safeForce, vmax=force2+1000)
#    plt.axis('off')
#    cbarD = plt.colorbar(imF, fraction=0.046, pad=0.04, orientation='vertical', ticks=[safeForce, force1, force2])
#    cbarD.ax.set_yticklabels(['Low', 'Medium', 'Death'])
#
#    plt.title('Force danger')

    plt.show()


# This program shows density's and force's levels in a phase
# diagram as an average of a set of 'out.py' files

# Average function which look for two equals points
def average_(points2, d2):
    global continuousDangerLevel_
    global points
#    for i in range(len(points2[0])):
#        for j in range(len(points_[0])):
#            if points_[0][j] == points2[0][i]:
#                if points_[1][j] == points2[1][i]:
#                    density_[j] = 0.6*(density_[j]+d2[i])
#                    force_[j] = 0.6*(force_[j]+f2[i])
#                    d2.pop(i)
#                    f2.pop(i)
#                    points2[0].pop(i)
#                    points2[1].pop(i)
#                    i = i-1
    continuousDangerLevel_ = np.append(continuousDangerLevel_, d2)
    points_[0] = np.append(points_[0], points2[0])
    points_[1] = np.append(points_[1], points2[1])


# Imports and averages the data-set from the out files
def analyse2(test_set, time):
    toDo = "from %s.counter import *" % test_set
    exec(toDo, globals())

    global points_
    global continuousDangerLevel_
    exec("from %s.out_0_0 import *" % (test_set), globals())
    points_ = [x, y]
    continuousDangerLevel_ = continuousDangerLevel
    
    for i in range(0, m):
        try:
            filename_ = 'out_%s_%s' % (i, time)
            exec("from %s.%s import *" % (test_set, filename_), globals())
        except ModuleNotFoundError:
            break
            
        average_((x, y), continuousDangerLevel)
        i = i+1
        
    phaseDiagram(points_[0], points_[1], continuousDangerLevel_)




if __name__ == '__main__' and __package__ is None:
    import sys, os.path as path
    sys.path.append(path.dirname(path.dirname(path.abspath(__file__))))
    from doubleHalfLine.counter import n

    with open("configs.sim") as f:
        next(f)
        for test_set in f:
            time = int(input('Choose time ->    '))
            analyse2(test_set.strip(), time)
