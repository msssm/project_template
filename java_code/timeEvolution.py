# -*- coding: utf-8 -*-
"""
Created on Fri Dec  8 15:31:01 2017

@author: Johanna
"""



from numpy import *
from matplotlib.pylab import *


def analyse_maxDanger(test_set):

    toDo = "from %s.counter import *" % test_set


    exec(toDo, globals())

    maxDanger_TimeEvolution=zeros((n-5,m))
    averageDanger_TimeEvolution=zeros((n,m))
    
    t=linspace(0,1,n-5)

    figure()    
#    ylim(0,5)
    title('Maximum Danger for Configuration: ' + test_set)
    
    for j in range(0,m):        #iterating over different seeds
        for k in range(5,n):    #iterating over time steps
            filename='out_%s_%s' %(j,k)
            exec("from %s.%s import *" % (test_set, filename), globals())   #importing data for given seed and time steps
            maxDanger_TimeEvolution[k,j]+=maxDanger
#        plot(t,maxDanger_TimeEvolution[:,j],'--',linewidth=0.2)   #creating plot
    y=median(maxDanger_TimeEvolution,axis=1)
    plot(t,y/((y)),linewidth=1.5,label='mean for different seeds')

    legend()
    savefig(test_set+'_maxDanger_timeEvolution.png')
    show()    
    
def anayse_averageDanger(test_set):
    toDo = "from %s.counter import *" % test_set


    exec(toDo, globals())

    averageDanger_TimeEvolution=zeros((n,m))
    
    t=linspace(0,1,n)
    figure()   
#    ylim(0,1)
    title('Median of Average Danger for Configuration: '+ test_set)
    
    for j in range(0,m):        #iterating over different seeds
        for k in range(0,n):    #iterating over time steps
            filename='out_%s_%s' %(j,k)
            exec("from %s.%s import *" % (test_set, filename), globals())   #importing data for given seed and time steps
            averageDanger_TimeEvolution[k,j]+=averageDanger
#        plot(t,averageDanger_TimeEvolution[:,j],'--',linewidth=0.2)
    y=median(averageDanger_TimeEvolution,axis=1)
    plot(t,y,linewidth=1.5,label='mean for different seeds')
    legend()
    savefig(test_set+'medianOfMeanDanger_timeEvolution.png')
    show()

def analyse_medianDanger(test_set):
    toDo = "from %s.counter import *" % test_set


    exec(toDo, globals())
    medianDanger_TimeEvolution=zeros((n-5,m))
    
    t=linspace(0,1,n-5)
#    figure(x)   
#    ylim(0,1)
    title('Average of Median Danger for Configuration: '+ test_set)
    print(m,n-5,test_set)
    
    for j in range(0,m):        #iterating over different seeds
        for k in range(0,n-5):    #iterating over time steps
            filename='out_%s_%s' %(j,k)
            exec("from %s.%s import *" % (test_set, filename), globals())   #importing data for given seed and time steps
            medianDanger_TimeEvolution[k,j]+=medianDanger
#        plot(t,averageDanger_TimeEvolution[:,j],'--',linewidth=0.2)
    y=average(medianDanger_TimeEvolution,axis=1)
    ymax=max(y)
    plot(t,y/ymax,linewidth=1.5,label='mean for different seeds')
    legend(prop={'size':5},fancybox=True)
#    savefig(test_set+'averageOFmedianDanger_timeEvolution_average.png',dpi=600)
#    show()


def analyse_isPartisipating(test_set):
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
#        plot(t,isParticipating_TimeEvolution[:,j],'--',linewidth=0.2)
    plot(t,isParticipating_TimeEvolution,linewidth=1.5,label=test_set)
    legend(prop={'size':5},fancybox=True)


if __name__ == '__main__' and __package__ is None:
    import sys, os.path as path
    sys.path.append(path.dirname(path.dirname(path.abspath(__file__))))


    with open("configs.sim") as f:
        next(f)
        figure()
        for test_set in f:
            
            analyse_isPartisipating(test_set.strip())
        savefig('isPArticipating_TimeEvolution.png',dpi=600)
            
            
                        
#            analyse_medianDanger(test_set.strip())
#        savefig('MedianDangerComparison.png',dpi=600)
            

        
