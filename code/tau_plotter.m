%%WRITE FUNCTION THAT PLOTS average convergence time versus N or phi.
read tau from AllFinVar.mat
plot(N,tau);
plot(phi,tau);