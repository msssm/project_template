clear

load All_Data
load CarModel

%define parent folder of alternative plan
parentfolder='../151123_pattern1_5plan'; % this is in the same level as "code" file

% only use data of texas
row= table.Smoker=='TX';
HHpool = unique(subtable(:,{'HOUSEID'}));
car_index=2; %index means which car we use 1-nissan, 2-tesla
sample_number=500; % how many output sample we need
alt_pattern=1;
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
        fileID = fopen(filename,'a');
        fprintf(fileID,'1.0:');
        fclose(fileID);
        alter=FUN_SOCalter(SOCori,FUNC_location(table,HHpool.HOUSEID(i)),model(car_index,:));
        altMatrix(j,:)=alter(alt_pattern,:);
        dlmwrite(filename,altMatrix(j,:),'-append','delimiter',',')
        fileID = fopen(filename,'a');
        fprintf(fileID,'\n');
        fclose(fileID);
        end
    end
end
        
        
% 
%         
%         
%         open([parentfolder,'',agentfolder,])
        
    
    
%end





    