

from numpy import *
from matplotlib.pylab import *
from scipy import interpolate


# This program shows density's and force's levels in a phase 
# diagram of a single 'out#.py' file

def phaseDiagram(x, y, density, F):

    # levels to be considerated safe/dangerous
    safeDensity = 10;
    density1 = 25;
    density2 = 40;

    safeForce = 1000;
    force1 = 2500;
    force2 = 4000;

    # interpolates the data to get a full grid
    grid_x, grid_y = mgrid[0:99:200j, 0:99:200j]
    points = (x, y)
    grid_density = interpolate.griddata(points, density, (grid_x, grid_y),method='cubic')
    grid_F = interpolate.griddata(points, F, (grid_x, grid_y),method='cubic')

    figure()
    # plots density diagram
    subplot(121)
    subplots_adjust(wspace=0.5)
    imD = imshow(grid_density, extent=(0,99,0,99), origin='upper', cmap='hot', vmin=safeDensity, vmax=density2+10)
    axis('off')
    cbarD = colorbar(imD, fraction=0.046, pad=0.04, orientation='vertical', ticks=[safeDensity, density1, density2])
    cbarD.ax.set_yticklabels(['Low', 'Medium', 'Death'])
    title('Density danger')

    # plots force diagram
    subplot(122)
    imF = imshow(grid_F, extent=(0,99,0,99), origin='upper', cmap='hot', vmin=safeForce, vmax=force2+1000)
    axis('off')
    cbarD = colorbar(imF, fraction=0.046, pad=0.04, orientation='vertical', ticks=[safeForce, force1, force2])
    cbarD.ax.set_yticklabels(['Low', 'Medium', 'Death'])

    title('Force danger')

    show()


def analyse(num):
    # get the file and run the diagramPhase function
    filename='out%s' % num
    exec("from %s import *" %filename, globals())
    phaseDiagram(x, y, density, F)

# user's interface
k = input('Which out to import?\n->  ')
analyse(k)
while k != 0:
    k = input('and now?\n->  ')
    analyse(k)

