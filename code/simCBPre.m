%% setup
%original liability matrix in absolute numbers
origL = adj .* repmat(ibA,n,1)';
%create relative liability matrix
relL1 = sum(origL,1)+liabTot;
relL = origL ./ repmat(relL1,n,1);


%draw shock on external assets risk factor (rf) from beta distn
distn = makedist('beta',1,1);
mc1= 250;
%% start MC simulation here
erVec = (0.0:0.01:0.4);

%define stressed banks
stressedBanks = 1:50;
degRank = [indeg (1:n)'];
degRank = sortrows(degRank,[-1 2]);
stressedBanks = degRank(stressedBanks,2);
%set banks that purse equity adjustment, rest divesture strategy
eAdj = 1:ncAT;
for i=2:16
    aux = sum(sum(ctr(1:(i-1),1:2)))+1;
    eAdj = [eAdj, aux:(aux+ctr(i,1)-1)];
end

for erv=1:length(erVec)
    er = erVec(erv);
    for mc = 1:mc1
        rf = distn.random(1);
        for i=1:n
            bank{1,i}(2,:) = bank{1,i}(1,:);
            %new value of external assets
            if ismember(i,stressedBanks)
                bank{1,i}(2,2) = (1-rf)*bank{1,i}(1,2);
                %equity is lowered 
                bank{1,i}(2,4) = max(bank{1,i}(2,4) - rf*bank{1,i}(1,2),0);
                %check solvency (==1) that is already the first round
                bank{1,i}(2,6) = bank{1,i}(2,4)>0;
            end    
            if (bank{1,i}(2,6)==1)
                %new equity ratio in t=2
                bank{1,i}(2,7) = bank{1,i}(2,4)/sum(bank{1,i}(2,1:2));
                %if under minimum er
                if (bank{1,i}(2,7)<er)
                    %if core, issue equity
                    if ismember(i,eAdj)
                        changeEq = (er*sum(bank{1,i}(2,1:2))-bank{1,i}(2,4))/(1-er);
                        changeEq = min(changeEq, bank{1,i}(1,4));
                        %update external assets
                        bank{1,i}(2,2) = bank{1,i}(2,2)+changeEq;
                        %update equity
                        bank{1,i}(2,4) = bank{1,i}(2,4)+changeEq;
                        bank{1,i}(2,6) = bank{1,i}(2,4)>0;
                        bank{1,i}(2,7) = bank{1,i}(2,4)/sum(bank{1,i}(2,1:2));  
                    %else (periphery) sell external assets
                    else                        
                        changeExt = sum(bank{1,i}(2,1:2)) - bank{1,i}(2,4)/er;
                        %external liabilities cannot be <0
                        changeExt = max([min([changeExt;bank{1,i}(2,5);bank{1,i}(2,2)]),0]);
                        %update external assets
                        bank{1,i}(2,2) = bank{1,i}(2,2)-changeExt;
                        %update external liabilites
                        bank{1,i}(2,5) = bank{1,i}(2,5)-changeExt;
                        liabTot(i) = bank{1,i}(2,3) + bank{1,i}(2,5) ;
                        bank{1,i}(2,6) = bank{1,i}(2,4)>0;
                        bank{1,i}(2,7) = bank{1,i}(2,4)/sum(bank{1,i}(2,1:2));
                    end 
                end
            end
            extA(i) = bank{1,i}(2,2);
        end    

        %fundamental defaults
        for i=1:n
            nFD(i) = bank{1,i}(2,6);         
        end      
        nMCFD(mc) = length(find(nFD==0))/length(nFD);
        %calculate clearing vector using FDA, each round banks adjust their equity
        %ratio when necessary (and possible)
        change = 0;
        %initial index for bank data
        t = 3;
        default1 = ones(n,1)';
        while change==0
            %set up default vector
            for i=1:n
                default(i) = bank{1,i}(t-1,6);         
            end  
            %assets in case of no default
            for i=1:n
                %when solvent pay full
                if (default(i)==1)
                    totPay(i) = bank{1,i}(1,3);
                end
            end
            relL1 = sum(origL,1)+liabTot;
            relL = origL ./ repmat(relL1,n,1);
            for i=1:n
                if (default(i)==0)
                %if not, pay only rest (assuming proportionality)    
                    totPay(i) = extA(i) + (liabTot(default==1)*relL(default==1,i));
                end
            end
            aux = eye(length(find(default==0))) - relL(default==0,default==0)';
            %solve linear equation
            totPayDef = aux\totPay(default==0)';
            totPay(default==0) = totPayDef;
            %update payment matrix with new payment vector
            matPay = relL .* repmat(totPay,n,1); 
            %add update of bank values for all i
            for i=1:n     
                bank{1,i}(t,1) = min(sum(matPay(i,:)),bank{1,i}(1,1));
                bank{1,i}(t,2) = bank{1,i}(t-1,2);
                bank{1,i}(t,3) = bank{1,i}(1,3);
                bank{1,i}(t,5) = bank{1,i}(t-1,5);
                bank{1,i}(t,4) = max(sum(bank{1,i}(t,1:2))-sum(bank{1,i}(t,[3 5])),0);
                bank{1,i}(t,6) = bank{1,i}(t,4)>0;
                bank{1,i}(t,7) = bank{1,i}(t,4)/sum(bank{1,i}(t,1:2));
                if (bank{1,i}(t-1,6)==0)
                    bank{1,i}(t,[1:3 5]) = bank{1,i}(t-1,[1:3 5]);
                    bank{1,i}(t,4) = 0;
                    bank{1,i}(t,6) = 0;
                    bank{1,i}(t,7) = 0;
                end
                if (bank{1,i}(t,6)==1)
                    if (bank{1,i}(t,7)<er)
                        %change in equity resp. external assets
                        if ismember(i,eAdj)
                            changeEq = (er*sum(bank{1,i}(t,1:2))-bank{1,i}(t,4))/(1-er);
                            changeEq = min(changeEq, bank{1,i}(1,4)^(1/(t-1)));
                            %update external assets
                            bank{1,i}(t,2) = bank{1,i}(t,2)+changeEq;
                            %update equity
                            bank{1,i}(t,4) = bank{1,i}(t,4)+changeEq;
                            bank{1,i}(t,6) = bank{1,i}(t,4)>0;
                            bank{1,i}(t,7) = bank{1,i}(t,4)/sum(bank{1,i}(t,1:2));                                               
                        else
                            changeExt = (bank{1,i}(t-1,2)+bank{1,i}(t,1)) - bank{1,i}(t,4)/er;
                            changeExt = max([min([changeExt;bank{1,i}(t,5);bank{1,i}(t,2)]),0]);
                            %update external assets
                            bank{1,i}(t,2) = bank{1,i}(t,2)-changeExt;
                            %update external liabilites
                            bank{1,i}(t,5) = bank{1,i}(t,5)-changeExt;
                            bank{1,i}(t,4) = max(sum(bank{1,i}(t,1:2))-sum(bank{1,i}(t,[3 5])),0);
                            bank{1,i}(t,6) = bank{1,i}(t,4)>0;
                            bank{1,i}(t,7) = bank{1,i}(t,4)/sum(bank{1,i}(t,1:2));
                            liabTot(i) = bank{1,i}(t,3) + bank{1,i}(t,5);
                        end
                    end
                end
                extA(i) = bank{1,i}(t,2);
            end   
            %update change
            if (isequal(default,default1))
                change = 1;
            else
                default1 = default;
                t = t+1;
            end    
        end
        mcERVec(mc) = length(find(abs(default-nFD)~=0))/length(default);
        dCore(mc) =  length(find(abs(default(eAdj)-nFD(eAdj))~=0))/length(default(eAdj));
        dPer(mc) = length(find(abs(default(setdiff(1:n,eAdj))-nFD(setdiff(1:n,eAdj)))~=0))/length(default(setdiff(1:n,eAdj)));
    end
    nErFD(erv) = mean(nMCFD);
    erVecResults(erv) = mean(mcERVec);
    dCoreFin(erv) = mean(dCore);
    dPerFin(erv) = mean(dPer);
end


erVecIP1 = erVec(1):0.001:erVec(end);
erVecResultsIP1 = interp1(erVec,erVecResults,erVecIP);
nErFDIP1 = interp1(erVec,nErFD,erVecIP);
dCoreFinIP1 = interp1(erVec,dCoreFin,erVecIP);
dPerFinIP1 = interp1(erVec,dPerFin,erVecIP); 

%% plotting

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
   ylabel('relative \#defaults');
   title(sprintf('FDA simulation with different equity ratios, pre-crisis: a=%d, b=%d',distn.a, distn.b),'fontsize',14,'fontweight','bold');
   legend([p1 p2 p3 p4], {'Contagious','Fundamental','Core contagion','Periphery contagion'},'Location','southoutside','orientation','horizontal');
 print('C:\Users\Timo Schäfer\Documents\Banking and Finance\HS 2015\Computational Social Sciences with Matlab\Text\CBPlotMixed', '-dpng');

axoptions={'scaled y ticks = false',...
           'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}',...
           'scaled x ticks = false',...
           'x tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};  
matlab2tikz('C:\Users\Timo Schäfer\Documents\Banking and Finance\HS 2015\Computational Social Sciences with Matlab\Text\CBPlotMixed.tex','extraAxisOptions',axoptions); 
 
