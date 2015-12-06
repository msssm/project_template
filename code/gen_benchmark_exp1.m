clear

% only use data of texas
load TexasTable
load CarModel

%define parent folder of alternative plan
parentfolder='../151123_pattern1_5plan'; % this is in the same level as "code" file

car_index=2;
row= (table.TRAVDAY<=5); % only consider weekdays
subtable=table(row,:);
fileID = fopen('agents.txt','r');
HHpool = fscanf(fileID,'%d\n');
fclose(fileID);

total=zeros(1,24*60);
% generate "all original plan benchmark
for i=1:length(HHpool)
    SOCori=FUNC_SOC(subtable,HHpool(i),model(car_index,:));
    if isnan(SOCori(1,1))==0
    total=total+FUNC_electricity(SOCori,model(car_index,:));
    end
end
  
 plot(1:24*60,total)