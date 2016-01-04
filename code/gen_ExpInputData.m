% this script generates the experimental input data file and folders for the EPOS optimization
% engine
clear

% only use data of texas
load TexasTable
load CarModel
ex=readtable('experiment151207.xlsx');

row= (table.TRAVDAY<=5); % only consider weekdays
subtable=table(row,:);
HHpool = unique(subtable(:,{'HOUSEID'}));

%define parent folder of alternative plan
for i_exp=1:height(ex)
parentfolder=cell2mat(strcat('../',ex.foldername(i_exp))); % this is in the same level as "code" file
car_index=ex.Car(i_exp); %index means which car we use 1-nissan, 2-tesla
EV_number=ex.num_EV(i_exp); % agents in total, including ones don't use alternative plans
plannedEV_number=ex.num_plannedEV(i_exp);
pattern=str2num(ex.Scheme{i_exp});
plan_number=length(pattern);
%initialization
count=1;
i=1;

% generate alternative plan
while count<=EV_number
    SOCori=FUNC_SOC(subtable,HHpool.HOUSEID(i),model(car_index,:));
    if isnan(SOCori(1,1))==0 && range(SOCori)~=0
        agentfolder=['Agent-',num2str(HHpool.HOUSEID(i)),'_Meter-','1'];
        mkdir(parentfolder, agentfolder)
        filename=[parentfolder,'/',agentfolder,'/','2015-01-01.plans'];
        if count<=plannedEV_number
        altMatrix=FUN_SOCalter(SOCori,FUNC_location(table,HHpool.HOUSEID(i)),model(car_index,:),pattern);
        else
        altMatrix=SOCori;
        end
        
        for j=1:length(altMatrix(:,1))
        fileID = fopen(filename,'a');
        fprintf(fileID,'1.0:');
        fclose(fileID);
        dlmwrite(filename,FUNC_electricity(altMatrix(j,:),model(car_index,:)),'-append','delimiter',',')
        end
        count=count+1;
        fprintf('count=%d, folder=%s, plan_number=%d\n',count,parentfolder',length(altMatrix(:,1)) );
    end
    i=i+1;
end
end        
        
% 
%         
%         
%         open([parentfolder,'',agentfolder,])
        
    
    
%end





    