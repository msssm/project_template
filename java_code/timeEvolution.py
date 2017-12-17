# -*- coding: utf-8 -*-
"""
Created on Fri Dec  8 15:31:01 2017

@author: Johanna
"""
from numpy import *
from matplotlib.pylab import *


colors=array(['dodgerblue','darkorange','g','red','purple','brown','violet','grey','y','lightskyblue','magenta','black'])

def analyse_medianDanger(test_set,i):
    toDo = "from %s.counter import *" % test_set

    exec(toDo, globals())
    
    medianDanger_TimeEvolution=zeros((n-5,m))
    t=linspace(0,1,n-5)
    title('Time Evolution of Average of Median Danger')
    
    for j in range(0,m):        #iterating over different seeds
        for k in range(0,n-5):    #iterating over time steps
            filename='out_%s_%s' %(j,k)
            exec("from %s.%s import *" % (test_set, filename), globals())   #importing data for given seed and time steps
            medianDanger_TimeEvolution[k,j]+=medianDanger
    y=average(medianDanger_TimeEvolution,axis=1)
    ylabel('Median Danger'  )
    ymax=max(y)
    if(test_set=='control'):
        linewidth_=3
    else:
        linewidth_=1.2
    plot(t,y/ymax,colors[i],linewidth=linewidth_,label=test_set)
#    savefig(test_set+'averageOFmedianDanger_timeEvolution_average.png',dpi=600)


def analyse_isParticipating(test_set,i):
    toDo = "from %s.counter import *" % test_set

    exec(toDo, globals())

    isParticipating_TimeEvolution=zeros(n-5)
    t=linspace(0,1,n-5)
    ylim(0,1)
    title('Time Evolution of Participation Rate')
    for j in range(0,m):        #iterating over different seeds
        for k in range(0,n-5):    #iterating over time steps
            filename='out_%s_%s' %(j,k)
            exec("from %s.%s import *" % (test_set, filename), globals())   #importing data for given seed and time steps
            isParticipating_TimeEvolution[k]+=sum(isParticipating)/(500*50)
            
    if(test_set=='control'):
        linewidth_=3
    else:
        linewidth_=1.2
        
    plot(t,isParticipating_TimeEvolution,colors[i],linewidth=linewidth_,label=test_set)
    ylabel('Participation Rate')
#    savefig(test_set+'isParticipating_timeEvolution_average.png',dpi=600)



if __name__ == '__main__' and __package__ is None:
    import sys, os.path as path
    sys.path.append(path.dirname(path.dirname(path.abspath(__file__))))

#is Participating
    with open("configs.sim") as f:
        next(f)
        figure(figsize=(7,5))
        k=0
        for test_set in f:
            
            analyse_isParticipating(test_set.strip(),k)
            k+=1

    legend(prop={'size':8},fancybox=True,ncol=3,loc=1)
    xlabel('Time')
    savefig('isParticipating_timeEvolution.png',dpi=600)
            
#Median Danger
    with open("configs.sim") as f:
        next(f)
        figure(figsize=(7,5))
        k=0
        for test_set in f:
            

            analyse_medianDanger(test_set.strip(),k)
            k+=1

    legend(prop={'size':8},fancybox=True,ncol=3,loc=1)
    xlabel('Time')
    savefig('medianDanger_timeEvolution.png',dpi=600)
            
            
