function [ distance ] = FUNC_distance(table, houseid)
%Get distance-t profile for a person with a given houseid
%Input Data: Table, HouseholdID 
%We define time step dt as 1 min
%Initialization
speed=zeros(1,60*24);
distance=zeros(1,60*24);
%Select data for the given houseid
%only select the first person, which means PERSONID=1
rows = table.HOUSEID==houseid & table.PERSONID==1;
subtable= table(rows, {'ENDTIME', 'TRVL_MIN', 'TRPMILES' });

%create speed profile
for i=1:height(subtable)
    t_range= subtable.ENDTIME(i)- subtable.TRVL_MIN(i): subtable.ENDTIME(i)-1;
    speed(t_range)= subtable.TRPMILES(i)/ subtable.TRVL_MIN(i); 
end

%create distance profile
for t=1:length(speed)-1
    distance(t+1)=distance(t)+speed(t);
end
end

