%Phi_range= [0.15:0.05:0.3];
%Phi_range= [0.3:0.01:0.55];
Phi_range= [0.2 0.4 0.9];
%Phi_range=[0.2:0.05:0.3 0.39:0.01:0.43 0.7:0.1:09];
str1='N300k4gamma10';
for Phi=Phi_range
    str2=['Data\',str1,'Phi',num2str(Phi),'Runs200.mat'];
    load(str2,'s_avg');
    str3=['\Phi = ',num2str(Phi)];
    createfigure(s_avg,str3);
    %hold on;
end
hold off;