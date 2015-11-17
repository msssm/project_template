clear

load All_Data
load CarModel

%define parent folder of alternative plan
parentfolder='../plan151117'; % this is in the same level as "code" file
HHpool = unique(table(:,{'HOUSEID'}));
HHpool=HHpool(1:500,:);
SOCmatrix=zeros(height(HHpool),24*60);
for i=1:height(HHpool)
    SOCmatrix(i,:)=FUNC_SOC(table,HHpool.HOUSEID(i),model(1,:)); % temporary use Nisaan Leaf as a try
    if isnan(SOCmatrix(i,1))==0
        SOCalter=FUNC(SOCmatrix(i,:),model(1,:),FUNC_location(table,HHpool.HOUSEID(i)),3);
        agentfolder=['Agent-',num2str(HHpool.HOUSEID(i)),'_Meter-','1'];
        mkdir(parentfolder, agentfolder)
        open([parentfolder,'',agentfolder,])
        
    end
    
end

NaN_Label=isnan(SOCmatrix(:,1));
sum(NaN_Label)



    