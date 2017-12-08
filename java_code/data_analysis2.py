

from numpy import *
from matplotlib.pylab import *
#from counter import n
from scipy import interpolate



def analysis1(isParticipating,r,density):
    figure()
    for k in arange(len(x)):
        if(isParticipating[k]==1):

            plot(r[k],density[k],'ro')
        else:
            plot(r[k],density[k],'bo')
    xlabel('distance to center')
    ylabel('danger caused by high density')
    title('Density')
    #show()

def densityAnalysis(r,density):
    figure()
    plot(r,density,'ro')
    xlabel('distance to center')
    ylabel('danger caused by density')
    title('Density')
    #show()

def analysis2(r,isParticipating,F):
    figure()
    for k in arange(len(x)):
        if(isParticipating[k]==1):

            plot(r[k],F[k],'ro')
        else:
            plot(r[k],F[k],'bo')
    xlabel('distance to center')
    ylabel('danger caused by high forces')
    title('Force')
    #show()

def forceAnalysis(r,F):
    figure()
    plot(r,F,'ro')
    xlabel('distance to center')
    ylabel('danger caused by forces')
    title('Force')
    #show()
def isParticipatingAnalysis(r,isParticipating,density,F):
    figure()
    plot(isParticipating,density,'ro')
    xlabel('Participating')
    ylabel('danger caused by high density')
    title('Density')
    #show()
    figure()
    plot(isParticipating,F,'ro')
    xlabel('Participating')
    ylabel('danger caused by forces')
    title('Force')
    show()


    figure()
    subplot(121)
    grid_x, grid_y = mgrid[0:99:200j, 0:99:200j]
    points = (x, y)
    grid_density = interpolate.griddata(points, density, (grid_x, grid_y),method='cubic')
    grid_F = interpolate.griddata(points, F, (grid_x, grid_y),method='cubic')

    imshow(grid_density, extent=(0,99,0,99), origin='lower')

    xlabel('x Position')
    ylabel('y Position')
#    cbar = plt.colorbar(CS)
#    cbar.ax.set_ylabel('Danger level')
    title('density')
    show()

    subplot(122)
    imshow(grid_F, extent=(0,99,0,99), origin='lower')
    xlabel('x Position')
    ylabel('y Position')
    title('F')



def analyse():
    n = 4
    for k in range(0,n):
        filename='out%s' % k
        exec("from %s import *" %filename, globals())


        r=sqrt((x-50)**2+(y-50)**2)

#        densityAnalysis(r,density)
#        analysis1(isParticipating,r,density)
#        forceAnalysis(r,F)
#        analysis2(r,isParticipating,F)
#        isParticipatingAnalysis(r,isParticipating,density,F)
        phaseDiagram(x, y, density, F)

        print (k)
analyse()

