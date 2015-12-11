clear all;
load('data.mat');
%data = sortrows(data,[1,-2]);
%setseed

%create country specific network characteristics
probCtr = 0.05;

ncAT=2; npAT=5; mcAT=12; mpAT=3; mcpAT=4;
AT = [ncAT npAT mcAT mpAT mcpAT];

ncBE=3; npBE=4; mcBE=12; mpBE=3; mcpBE=6;
BE = [ncBE npBE mcBE mpBE mcpBE];

ncCH=5; npCH=10; mcCH=20; mpCH=7; mcpCH=10;
CH = [ncCH npCH mcCH mpCH mcpCH];

ncDE=11; npDE=23; mcDE=44; mpDE=17; mcpDE=22;
DE = [ncDE npDE mcDE mpDE mcpDE];

ncDK=4; npDK=7; mcDK=16; mpDK=5; mcpDK=8;
DK = [ncDK npDK mcDK mpDE mcpDK];

ncES=5; npES=13; mcES=20; mpES=9; mcpES=10;
ES = [ncES npES mcES mpES mcpES];

ncFI=2; npFI=2; mcFI=4; mpFI=2; mcpFI=1;
FI = [ncFI npFI mcFI mpFI mcpFI];

ncFR=10; npFR=33; mcFR=40; mpFR=24; mcpFR=20;
FR = [ncFR npFR mcFR mpFR mcpFR];

ncGB=9; npGB=30; mcGB=36; mpGB=22; mcpGB=18;
GB = [ncGB npGB mcGB mpGB mcpGB];

ncGR=1; npGR=3; mcGR=4; mpGR=2; mcpGR=2;
GR = [ncGR npGR mcGR mpGR mcpGR];

ncIE=2; npIE=6; mcIE=8; mpIE=4; mcpIE=4;
IE = [ncIE npIE mcIE mpIE mcpIE];

ncIT=6; npIT=19; mcIT=24; mpIT=14; mcpIT=12;
IT = [ncIT npIT mcIT mpIT mcpIT];

ncLU=2; npLU=6; mcLU=8; mpLU=5; mcpLU=4;
LU = [ncLU npLU mcLU mpLU mcpLU];

ncNL=3; npNL=5; mcNL=12; mpNL=3; mcpNL=6;
NL = [ncNL npNL mcNL mpNL mcpNL];

ncPT=2; npPT=4; mcPT=8; mpPT=3; mcpPT=4;
PT = [ncPT npPT mcPT mpPT mcpPT];

ncSE=3; npSE=4; mcSE=12; mpSE=3; mcpSE=5;
SE = [ncSE npSE mcSE mpSE mcpSE];

ctr = [AT;BE;CH;DE;DK;ES;FI;FR;GB;GR;IE;IT;LU;NL;PT;SE];
[n,~] = size(data);
[fn, adj] = Gnm(ctr, probCtr,data);
adj = adj';
% plot(fn);
% title('$$G(n,m,p)$$','Interpreter','latex');
% axis off;

%%basis for t=0
indeg = fn.indegree;
%get interbank assets and external assets from balance sheet
for i = 1:n
    bank{1,i}(1,1) = data(i,3);
    bank{1,i}(1,2) = data(i,2)-data(i,3);
end

%vector of interbank assets (claims) of n banks
ibA = cell2mat(bank);
ibA = ibA(1,1:2:2*n);


%remaing variables
for i= 1:n
    %L_IB via outgoing links
    bank{1,i}(1,3) = ibA * adj(:,i);
    %equity from balance sheet
    bank{1,i}(1,4) = data(i,4);
    %L_E endogenous
    bank{1,i}(1,5) = sum(bank{1,i}(1,1:2))-sum(bank{1,i}(1,3:4));
    %check solvency
    bank{1,i}(1,6) = bank{1,i}(1,4)>0;
    %current equity ratio
    bank{1,i}(1,7) = bank{1,i}(1,4)/sum(bank{1,i}(1,1:2));
    liabTot(i) = bank{1,i}(1,3) +  bank{1,i}(1,5) ;
end     


%% plot aggregation
subplot(1,2,1) 
fig1 = figure(1);
   set(fig1,'defaulttextinterpreter','latex');
   set(fig1, 'defaultAxesTickLabelInterpreter','latex')  ; 
   grid on;
   p1 = plot(erVecIP1,erVecResultsIP1,'color','blue');  
   hold on;
   p2 = plot(erVecIP1,nErFDIP1,'color','red');
   hold on;
   p3 = plot(erVecIP1,dCoreFinIP1,'color','magenta');
   hold on;
   p4 = plot(erVecIP1,dPerFinIP1,'color','green');
   xlabel('\textit{ER}');
   ylim([0.1 0.5]);
   ylabel('relative \#defaults');
   ybounds = ylim();
   set(gca, 'ytick', ybounds(1):0.05:ybounds(2));
   title(sprintf('FDA simulation with different equity ratios, pre-crisis: a=%d, b=%d',distn.a, distn.b),'fontsize',14,'fontweight','bold');
subplot(1,2,2) 
fig2 = figure(1);
   set(fig2,'defaulttextinterpreter','latex');
   set(fig2, 'defaultAxesTickLabelInterpreter','latex')  ; 
   grid on;
   p1 = plot(erVecIP,erVecResultsIP,'color','blue');  
   hold on;
   p2 = plot(erVecIP,nErFDIP,'color','red');
   hold on;
   p3 = plot(erVecIP,dCoreFinIP,'color','magenta');
   hold on;
   p4 = plot(erVecIP,dPerFinIP,'color','green');
   xlabel('\textit{ER}');
   ylabel('relative \#defaults');
   ylim([0.1 0.5]);
   ybounds = ylim();
   set(gca, 'ytick', ybounds(1):0.05:ybounds(2));
   title(sprintf('FDA simulation with different equity ratios, post-crisis: a=%d, b=%d',distn.a, distn.b),'fontsize',14,'fontweight','bold');
leg = legend([p1 p2 p3 p4], {'Contagious','Fundamental','Core contagion','Periphery contagion'},'Location','southoutside','orientation','horizontal');
newPosition = [0.4 0.03 0.2 0.03];
newUnits = 'normalized';
set(leg,'Position', newPosition,'Units', newUnits);
print('C:\Users\Timo Schäfer\Documents\Banking and Finance\HS 2015\Computational Social Sciences with Matlab\Text\CBPlotCombi', '-dpng');

axoptions={'scaled y ticks = false',...
           'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}',...
           'scaled x ticks = false',...
           'x tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};  
matlab2tikz('C:\Users\Timo Schäfer\Documents\Banking and Finance\HS 2015\Computational Social Sciences with Matlab\Text\CBPlotCombi.tex','extraAxisOptions',axoptions); 
 



