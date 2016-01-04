clear

% only use data of texas
load TexasTable
load CarModel

%define parent folder of alternative plan
parentfolder='../151123_pattern1_5plan'; % this is in the same level as "code" file

row= (table.TRAVDAY<=5); % only consider weekdays
subtable=table(row,:);
HHpool = unique(subtable(:,{'HOUSEID'}));
car_index=2; %index means which car we use 1-nissan, 2-tesla
EV_number=1000; % how many output sample we need

count=1;
i=1;
total=zeros(1,24*60);
% generate "all original plan benchmark
while count<=EV_number
    SOCori=FUNC_SOC(subtable,HHpool.HOUSEID(i),model(car_index,:));
    if isnan(SOCori(1,1))==0 && range(SOCori)~=0
        count=count+1;
        total=total+FUNC_electricity(SOCori,model(car_index,:));
    end
    i=i+1;
end        
 plot(1:24*60,total)