%% setup

%original liability matrix in absolute numbers
origL = adj .* repmat(ibA,n,1)';
%create relative liability matrix
relL1 = sum(origL,1)+liabTot;
relL = origL ./ repmat(relL1,n,1);

% range of limits of banks to save (EigLim)
Lim = 0:1:40;
% threshold when bailouts start
thold = n/20;
% eigencentrality in the bank network
[EigC, EigInd] = eigencentr(origL);
eigenM = [EigC EigInd];
% %equity ratio as defined by Basel III
eqr = 0.045;

% # MC simulations
mc1 = 100;

%Bailout costs for lender of last resort
BailC = zeros(length(Lim),mc1);
% loss of equity through shock
shockLoss = zeros(length(Lim),mc1);

%draw shock on external assets risk factor
distn = makedist('beta',1,1);
% define banks to be stressed by degree centrality, outdegree
outdeg = fn.outdegree;
outdeg = [(1:n)' outdeg];
outdeg = sortrows(outdeg,-2);
stressedBanks = outdeg(1:30,1);


%% start MC simulation here
% range of limits of banks to save (EigLim)
for bRange = 1:length(Lim)
    EigLim = Lim(bRange);    
    % draws per value of EigLim
    for mc = 1:mc1
        rf = distn.random(1);
        %update bank variables for shock
        for i=1:n
            bank{1,i}(2,:) = bank{1,i}(1,:);
            if ismember(i,stressedBanks)
                bank{1,i}(2,2) = (1-rf)*bank{1,i}(1,2);
                bank{1,i}(2,4) = max(bank{1,i}(2,4) - rf*bank{1,i}(1,2),0);
                bank{1,i}(2,8) = bank{1,i}(1,4) - rf*bank{1,i}(1,2);
                shockLoss(bRange,mc) = shockLoss(bRange,mc) + rf*bank{1,i}(1,2);
            end
            %check solvency (==1) that is already the first round
            bank{1,i}(2,6) = bank{1,i}(2,4)>0;
            %new equity ratio  
            bank{1,i}(2,7) = bank{1,i}(2,4)/sum(bank{1,i}(2,1:2));
            extA(i) = bank{1,i}(2,2);
        end    

        %fundamental defaults
        for i=1:n
            nFD(i) = bank{1,i}(2,6);         
        end      

        %calculate clearing vector using FDA, 
        change = 0;
        
        %set of banks saved
        setBanks = [];
        
        %set up default vector
        for i=1:n
                default(i) = bank{1,i}(2,6);         
        end  
       
        
        
        %initial index for bank data
        t = 3;
        default1 = ones(n,1)';
        
        while change==0
             %set up default vector
             for i=1:n
                default(i) = bank{1,i}(t-1,6);         
             end  
           
            %assets in case of default; payment vector
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

            aux3 = eye(length(find(default==0))) - relL(default==0,default==0)';
            %solve linear equation
            totPayDef = aux3\totPay(default==0)';
            totPay(default==0) = totPayDef;
            %update payment matrix with new payment vector totpay',n,1
            matPay = relL .* repmat(totPay,n,1); 
            %add update of bank values for all i; contagion takes place
            for i=1:n     
                bank{1,i}(t,1) = sum(matPay(i,:));
                bank{1,i}(t,2) = bank{1,i}(t-1,2);
                bank{1,i}(t,3) = bank{1,i}(1,3);
                bank{1,i}(t,5) = bank{1,i}(t-1,5);
                bank{1,i}(t,4) = max(sum(bank{1,i}(t,1:2))-sum(bank{1,i}(t,[3 5])),0);
                bank{1,i}(t,6) = bank{1,i}(t,4)>0;
                bank{1,i}(t,7) = bank{1,i}(t,4)/sum(bank{1,i}(t,1:2));
                bank{1,i}(t,8) = sum(bank{1,i}(t,1:2))-sum(bank{1,i}(t,[3 5]));
                if (bank{1,i}(t-1,6)==0)
                    bank{1,i}(t,4) = 0;
                    bank{1,i}(t,6) = 0;
                    bank{1,i}(t,7) = 0;
                end
                default(i) =  bank{1,i}(t,6);
                extA(i) = bank{1,i}(t,2);
                liabTot(i) = bank{1,i}(t,3) + bank{1,i}(t,5);

            end
            %update change
            if (isequal(default,default1));
                change = 1;
            else
                %condition for bailout; threshold 5%
                if sum(default(:)==0) > thold;
                    aux2 = find(~default)';
                    aux1 = EigInd(ismember(EigInd,aux2));
                    % aux1 = randperm(numel(aux2)); %alternative for random
                    % pick
                    %min of all defaults in t or EigLim
                    aux = aux2(1:min(length(aux1),EigLim));
                   %bailout injection
                   for i=1:n
                       if ismember(i, aux)&& ~ismember(i,setBanks) 
                           setBanks = [setBanks i];
                           injection = (sum(bank{1,i}(t,[3 5])) - (1-eqr)*(sum(bank{1,i}(t,1:2))))/(1-eqr);
                           bank{1,i}(t,2) = injection + bank{1,i}(t,2);
                           bank{1,i}(t,8) = sum(bank{1,i}(t,1:2))-sum(bank{1,i}(t,[3 5]));
                           bank{1,i}(t,4) = sum(bank{1,i}(t,1:2))-sum(bank{1,i}(t,[3 5]));
                           %update external assets and equity ratio after bailouts
                           extA(i) = bank{1,i}(t,2);
                           bank{1,i}(t,7) = bank{1,i}(t,4)/sum(bank{1,i}(t,1:2));
                           bank{1,i}(t,6) = bank{1,i}(t,4)>0;
                           % update bailout costs
                           BailC(bRange,mc) = BailC(bRange,mc) + injection;
                           default(i) = bank{1,i}(t,6);
                           extA(i) = bank{1,i}(t,2);
                           liabTot(i) = bank{1,i}(t,3) + bank{1,i}(t,5);

                       end
                   end
                end
               default1 = default;
               t = t+1;
            end
        end 
        % total defaults relative to number of all banks
        totDefault(bRange,mc) = length(find(default==0))/n;
        % fundamental defaults relative to number of all banks
        FD(bRange,mc) = length(find(nFD == 0))/n;
        
        end     
    end

    
  
     
% average costs for each value of EigLim    
avBailC = mean(BailC,2);  
% average loss of equity for each value of EigLim
avshockLoss = mean(shockLoss,2);
%calculate average defaults over all simulations 
avtotDefault = mean(totDefault,2);
% average fundamental defaults over all simulations
avFD = mean(FD,2);



%% plotting

fig1 = figure(1);
   set(fig1,'defaulttextinterpreter','latex');
   set(fig1, 'defaultAxesTickLabelInterpreter','latex')  ; 
   grid on;
   p1 = plot(Lim/n,avtotDefault,'color','blue');  
   hold on;
   p2 = plot(Lim/n,avFD,'color','red');
   xlabel('\textit{maximum of banks saved per timestep}');
   ylabel('relative \#defaults');
   title('\textbf{FDA simulation with bailouts}','fontsize',14);
   legend([p1 p2], {'Total','Fundamental'},'Location','southeast');
 print('C:\Users\Marion\Desktop\CSS figures\tot_fund_1_1_5', '-dpng');
 
 axoptions={'scaled y ticks = false',...
           'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}',...
           'scaled x ticks = false',...
           'x tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};  
matlab2tikz('C:\Users\Marion\Desktop\CSS figures\tot_fund_1_1_5.tex','extraAxisOptions',axoptions); 
 
fig2 = figure(2);
   set(fig2,'defaulttextinterpreter','latex');
   set(fig2, 'defaultAxesTickLabelInterpreter','latex')  ; 
   grid on;
   p1 = plot(Lim/n,avshockLoss,'color','blue');  
   hold on;
   p2 = plot(Lim/n,avBailC,'color','red');
   xlabel('\textit{maximum of banks saved per timestep}');
   ylabel('billions \$');
   title('\textbf{bailout costs and loss through shock in FDA simulation with bailouts}','fontsize',14);
   legend([p1 p2], {'loss through shock','bailout costs'},'Location','southeast');
 print('C:\Users\Marion\Desktop\CSS figures\bailc_loss_1_1_5', '-dpng');


axoptions={'scaled y ticks = false',...
           'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}',...
           'scaled x ticks = false',...
           'x tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=2}'};  
matlab2tikz('C:\Users\Marion\Desktop\CSS figures\bailc_loss_1_1_5.tex','extraAxisOptions',axoptions); 

 

  