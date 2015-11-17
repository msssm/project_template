clear
load All_Data
load CarModel

HHpool = unique(table(:,{'HOUSEID'}));
SOCmatrix=zeros(height(HHpool),24*60);
for i=1:height(HHpool)
    SOCmatrix(i,:)=FUNC_SOC(table,HHpool.HOUSEID(i),model(1,:)); % temporary use Nisaan Leaf as a try
end

NaN_Label=isNaN(SOCmatrix(:,1));
sum(NaN_Label)
    