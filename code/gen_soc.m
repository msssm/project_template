clear

load All_Data
load CarModel

%define parent folder of alternative plan
parentfolder='../plan151117'; % this is in the same level as "code" file
HHpool = unique(table(:,{'HOUSEID'}));
car_index=2; %index means which car we use 1-nissan, 2-tesla
sample_number=1000; % how many output sample we need


HHpool=HHpool(1:sample_number,:);
SOCmatrix=zeros(height(HHpool),24*60);
for i=1:height(HHpool)
    SOCmatrix(i,:)=FUNC_SOC(table,HHpool.HOUSEID(i),model(car_index,:)); % temporary use Nisaan Leaf as a try
    if isnan(SOCmatrix(i,1))==0
        SOCalter=FUNC(SOCmatrix(i,:),model(car_index,:),FUNC_location(table,HHpool.HOUSEID(i)),3);
        agentfolder=['Agent-',num2str(HHpool.HOUSEID(i)),'_Meter-','1'];
        mkdir(parentfolder, agentfolder)
        open([parentfolder,'',agentfolder,])
        
    end
    
end

NaN_Label=isnan(SOCmatrix(:,1));
sum(NaN_Label)



    