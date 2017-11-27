timeGap = 0.01;
op = main(500);
edges = [0 0.1:0.1 0.2:0.2 0.3:0.3 0.4:0.4 0.475:0.475 0.525:0.525 0.6:0.6 0.7:0.7 0.8:0.8 0.9:0.9 1];
nbin = 50;
histogram(op, edges);
pause(timeGap)
drawnow;
