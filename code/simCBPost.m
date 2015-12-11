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
clear dPerFin dCoreFin nErFD erVecResults;
erVec = (0:0.01:0.4);

%define stressed banks
stressedBanks = 1:50;
degRank = [indeg (1:n)'];
degRank = sortrows(degRank,[-1 2]);
stressedBanks = degRank(stressedBanks,2);
%set banks that purse equity adjustment, rest divesture strategy
eAdj = 1:ncAT;
for j=2:16
    aux = sum(sum(ctr(1:(j-1),1:2)))+1;
    eAdj = [eAdj, aux:(aux+ctr(j,1)-1)];
end

for erv=1:length(erVec)
    er = erVec(erv);
    for mc = 1:mc1
        rf = distn.random(1);
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
        end     

        for i=1:n
            if (bank{1,i}(1,6)==1)
                %if under minimum er
                if (bank{1,i}(1,7)<er)
                    if ismember(i,eAdj)
                        changeEq = (er*sum(bank{1,i}(1,1:2))-bank{1,i}(1,4))/(1-er);
                        changeEq = min(changeEq, bank{1,i}(1,4));
                        %update external assets
                        bank{1,i}(1,2) = bank{1,i}(1,2)+changeEq;
                        %update equity
                        bank{1,i}(1,4) = bank{1,i}(1,4)+changeEq;
                        bank{1,i}(1,6) = bank{1,i}(1,4)>0;
                        bank{1,i}(1,7) = bank{1,i}(1,4)/sum(bank{1,i}(1,1:2));                      
                    else                        
                        changeExt = sum(bank{1,i}(1,1:2)) - bank{1,i}(1,4)/er;
                        %external liabilities cannot be <0
                        changeExt = max([min([changeExt;bank{1,i}(1,5);bank{1,i}(1,2)]),0]);
                        %update external assets
                        bank{1,i}(1,2) = bank{1,i}(1,2)-changeExt;
                        %update external liabilites
                        bank{1,i}(1,5) = bank{1,i}(1,5)-changeExt;
                        liabTot(i) = bank{1,i}(1,3) + bank{1,i}(1,5) ;
                        bank{1,i}(1,7) = bank{1,i}(1,4)/sum(bank{1,i}(1,1:2));
                    end 
                end
            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            bank{1,i}(2,:) = bank{1,i}(1,:);
            %new value of external assets
            %determine which banks to stress
            if ismember(i,stressedBanks)
                bank{1,i}(2,2) = (1-rf)*bank{1,i}(1,2);
                %equity is lowered 
                bank{1,i}(2,4) = max(bank{1,i}(2,4) - rf*bank{1,i}(1,2),0);
                %check solvency (==1) that is already the first round
            end    
            bank{1,i}(2,6) = bank{1,i}(2,4)>0;
            if (bank{1,i}(2,6)==1)
                %new equity ratio in t=2
                bank{1,i}(2,7) = bank{1,i}(2,4)/sum(bank{1,i}(2,1:2));
                %if under minimum er, then sell at least external assets
                if (bank{1,i}(2,7)<er)
                    if ismember(i,eAdj)
                        changeEq = (er*sum(bank{1,i}(2,1:2))-bank{1,i}(2,4))/(1-er);
                        changeEq = min(changeEq, (bank{1,i}(1,4))^(0.5));
                        %update external assets
                        bank{1,i}(2,2) = bank{1,i}(2,2)+changeEq;
                        %update equity
                        bank{1,i}(2,4) = bank{1,i}(2,4)+changeEq;
                        bank{1,i}(2,6) = bank{1,i}(2,4)>0;
                        bank{1,i}(2,7) = bank{1,i}(2,4)/sum(bank{1,i}(2,1:2));                      
                    else                        
                        changeExt = (bank{1,i}(2,2)+bank{1,i}(2,1)) - bank{1,i}(2,4)/er;
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
                    %new equity ratio
                    %if under minimum er and solvent, then sell at least external assets
                    if (bank{1,i}(t,7)<er)
                        if ismember(i,eAdj)
                            changeEq = (er*sum(bank{1,i}(t,1:2))-bank{1,i}(t,4))/(1-er);
                            changeEq = min(changeEq, bank{1,i}(1,4)^(1/(t)));
                            %update external assets
                            bank{1,i}(t,2) = bank{1,i}(t,2)+changeEq;
                            %update equity
                            bank{1,i}(t,4) = bank{1,i}(t,4)+changeEq;
                            bank{1,i}(t,6) = bank{1,i}(t,4)>0;
                            bank{1,i}(t,7) = bank{1,i}(t,4)/sum(bank{1,i}(t,1:2));                                               
                        else
                            changeExt = (bank{1,i}(t,2)+bank{1,i}(t,1)) - bank{1,i}(t,4)/er;
                            %external liabilities cannot be <0
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


erVecIP = erVec(1):0.001:erVec(end);
erVecResultsIP = interp1(erVec,erVecResults,erVecIP);
nErFDIP = interp1(erVec,nErFD,erVecIP);
dCoreFinIP = interp1(erVec,dCoreFin,erVecIP);
dPerFinIP = interp1(erVec,dPerFin,erVecIP); 




%% plotting

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
   title(sprintf('FDA simulation with different equity ratios, post-crisis: a=%d, b=%d',distn.a, distn.b),'fontsize',14,'fontweight','bold');
   legend([p1 p2 p3 p4], {'Contagious','Fundamental', 'Core contagion' 'Periphery contagion'},'Location','southoutside','orientation','horizontal');
 print('C:\Users\Timo Schäfer\Documents\Banking and Finance\HS 2015\Computational Social Sciences with Matlab\Text\CBPlotMixedPost', '-dpng');

axoptions={'scaled y ticks = false',...
           'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}',...
           'scaled x ticks = false',...
           'x tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};  
matlab2tikz('C:\Users\Timo Schäfer\Documents\Banking and Finance\HS 2015\Computational Social Sciences with Matlab\Text\CBPlotMixedPost.tex','extraAxisOptions',axoptions); 
 
