# -*- coding: utf-8 -*-
"""
Created on Sat Dec  2 16:10:23 2017

@author: Johanna
"""


from numpy import *
from matplotlib.pylab import *

from out import *
print(len(x),len(y))
r=sqrt((x-500)**2+(y-500)**2)
figure()
plot(x,y)
show()
def analysis1():
    figure()
    for k in arange(len(x)):
        if(isParticipating[k]==1):
            
            plot(r[k],density[k],'ro')
        else:
            plot(r[k],density[k],'bo')
    xlabel('distance to center')
    ylabel('danger caused by high density')
    title('Density')
    show()

def densityAnalysis():
    figure()
    plot(r,density,'ro')
    xlabel('distance to center')
    ylabel('danger caused by density')
    title('Density')
    show()
    
def analysis2():
    figure()
    for k in arange(len(x)):
        if(isParticipating[k]==1):
                
            plot(r[k],F[k],'ro')
        else:
            plot(r[k],F[k],'bo')
    xlabel('distance to center')
    ylabel('danger caused by high forces')
    title('Force')
    show()

def forceAnalysis():
    figure()
    plot(r,F,'ro')
    xlabel('distance to center')
    ylabel('danger caused by forces')
    title('Force')
    show()
def isParticipatingAnalysis():
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
densityAnalysis()
analysis1()
forceAnalysis()
analysis2()
isParticipatingAnalysis()
