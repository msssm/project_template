
k_avg_set = 4;
N = 500;
gamma = 10;
ii = 10;

phi_range = 0.1:0.1:0.9;
%op = zeros(length(phi_range));
op = [];

for phi=phi_range

    str2=['N',num2str(N),'k',num2str(k_avg_set),'gamma',num2str(gamma),'Phi',num2str(phi),'Runs',num2str(ii)];
    load(['Data/',str2,'/AllFinVar.mat']);
    
    op = [op max(find(s_avg))/N];
    
    
    
end

plot(phi_range, op, 'x')