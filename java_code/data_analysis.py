# -*- coding: utf-8 -*-
"""
Created on Sat Dec  2 16:10:23 2017

@author: Johanna
"""


from numpy import *
from matplotlib.pylab import *


        

def analysis1(isParticipating,r,density):
    figure()
    for k in arange(len(r)):
        if(isParticipating[k]==1):
            
            plot(r[k],density[k],'ro')
        else:
            plot(r[k],density[k],'bo')
    xlabel('distance to center')
    ylabel('danger caused by high density')
    title('Density')
    show()

def densityAnalysis(r,density):
    figure()
    plot(r,density,'ro')
    xlabel('distance to center')
    ylabel('danger caused by density')
    title('Density')
    show()
    
def analysis2(r,isParticipating,F):
    figure()
    for k in arange(len(r)):
        if(isParticipating[k]==1):
                
            plot(r[k],F[k],'ro')
        else:
            plot(r[k],F[k],'bo')
    xlabel('distance to center')
    ylabel('danger caused by high forces')
    title('Force')
    show()

def forceAnalysis(r,F):
    figure()
    plot(r,F,'ro')
    xlabel('distance to center')
    ylabel('danger caused by forces')
    title('Force')
    show()
def isParticipatingAnalysis(r,isParticipating,density,F):
    figure()
    plot(isParticipating,density,'ro')
    xlabel('Participating')
    ylabel('danger caused by high density')
    title('Density')
    show()
    figure()
    plot(isParticipating,F,'ro')
    xlabel('Participating')
    ylabel('danger caused by forces')
    title('Force')
    show()
def analyse():
    for k in range(0,5):
        filename='out%s' % k
        exec("from %s import *" %filename, globals())
        print(len(x),len(y))
        r=sqrt((x-500)**2+(y-500)**2)

        densityAnalysis(r,density)
        analysis1(isParticipating,r,density)
        forceAnalysis(r,F)
        analysis2(r,isParticipating,F)
        isParticipatingAnalysis(r,isParticipating,density,F)
analyse()
