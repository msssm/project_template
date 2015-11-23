clear

load All_Data
load CarModel

%define parent folder of alternative plan
parentfolder='../plan151117'; % this is in the same level as "code" file
HHpool = unique(table(:,{'HOUSEID'}));
car_index=2; %index means which car we use 1-nissan, 2-tesla
sample_number=1; % how many output sample we need
plan_number=5;

HHpool=HHpool(1:sample_number,:);


for i=1:height(HHpool)
    SOCmatrix=FUNC_SOC(table,HHpool.HOUSEID(i),model(car_index,:));
    if isnan(SOCmatrix(1,1))==0
        for j=1
        alter=FUN_SOCalter(SOCmatrix(1,:),FUNC_location(table,HHpool.HOUSEID(1)),model(car_index,:));


% 
%         agentfolder=['Agent-',num2str(HHpool.HOUSEID(i)),'_Meter-','1'];
%         mkdir(parentfolder, agentfolder)
%         open([parentfolder,'',agentfolder,])
        
    
    
%end

NaN_Label=isnan(SOCmatrix(:,1));
sum(NaN_Label)



    