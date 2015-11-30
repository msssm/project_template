clear

% only use data of texas
load TexasTable
load CarModel

%define parent folder of alternative plan
parentfolder='../151127_pattern5_5plan'; % this is in the same level as "code" file

row= (table.TRAVDAY<=5); % only consider weekdays
subtable=table(row,:);
HHpool = unique(subtable(:,{'HOUSEID'}));
car_index=2; %index means which car we use 1-nissan, 2-tesla
sample_number=1000; % how many output sample we need
alt_pattern=5;
plan_number=5;

HHpool=HHpool(1:sample_number,:);

% generate "1 original + 4 first-pattern" alter plan
for i=1:height(HHpool)
    SOCori=FUNC_SOC(subtable,HHpool.HOUSEID(i),model(car_index,:));
    altMatrix=zeros(plan_number, 24*60);
    if isnan(SOCori(1,1))==0
        altMatrix(1,:)=SOCori;
        agentfolder=['Agent-',num2str(HHpool.HOUSEID(i)),'_Meter-','1'];
        mkdir(parentfolder, agentfolder)
        filename=[parentfolder,'/',agentfolder,'/','2015-01-01.plans'];
        for j=2:plan_number
        alter=FUN_SOCalter(SOCori,FUNC_location(table,HHpool.HOUSEID(i)),model(car_index,:));
        altMatrix(j,:)=alter(alt_pattern,:);
        end
        
        for j=1:plan_number
        fileID = fopen(filename,'a');
        fprintf(fileID,'1.0:');
        fclose(fileID);
        dlmwrite(filename,FUNC_electricity(altMatrix(j,:),model(car_index,:)),'-append','delimiter',',')
        end
    end
end
        
        
% 
%         
%         
%         open([parentfolder,'',agentfolder,])
        
    
    
%end





    