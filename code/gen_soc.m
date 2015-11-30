clear

% only use data of texas
load TexasTable
load CarModel
ex=readtable('experiment.xlsx');

row= (table.TRAVDAY<=5); % only consider weekdays
subtable=table(row,:);
HHpool = unique(subtable(:,{'HOUSEID'}));

%define parent folder of alternative plan
for i_exp=1:height(ex)
parentfolder=['../',ex.foldername(i)]; % this is in the same level as "code" file
car_index=ex.Car(i); %index means which car we use 1-nissan, 2-tesla
EV_number=ex.num_EV(i); % agents in total, including ones don't use alternative plans
plannedEV_number=ex.num_plannedEV(i);
pattern=str2num(ex.Scheme{i});
plan_number=length(pattern);
%initialization
count=1;
i=1;

% generate "1 original + 4 same-pattern" alter plan
while count<=sample_number
    SOCori=FUNC_SOC(subtable,HHpool.HOUSEID(i),model(car_index,:));
    if isnan(SOCori(1,1))==0 && range(SOCori)~=0
        altMatrix=FUN_SOCalter(SOCori,FUNC_location(table,HHpool.HOUSEID(i)),model(car_index,:),pattern);
        agentfolder=['Agent-',num2str(HHpool.HOUSEID(i)),'_Meter-','1'];
        mkdir(parentfolder, agentfolder)
        filename=[parentfolder,'/',agentfolder,'/','2015-01-01.plans'];
        
        for j=1:plan_number
        fileID = fopen(filename,'a');
        fprintf(fileID,'1.0:');
        fclose(fileID);
        dlmwrite(filename,FUNC_electricity(altMatrix(j,:),model(car_index,:)),'-append','delimiter',',')
        end
        count=count+1;
    end
    i=i+1;
end
end        
        
% 
%         
%         
%         open([parentfolder,'',agentfolder,])
        
    
    
%end





    