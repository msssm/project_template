function [ speed ] = FUNC_speed( table, houseid)
%Get speed-t profile for a person with a given houseid
%We define time step dt as 1 min
%Initialization
speed=zeros(1,60*24);

% Select the row for a given houseid
% Only select the first member of the household whose PERSONID == 1
rows = table.HOUSEID==houseid & table.PERSONID==1;
subtable= table(rows, {'ENDTIME', 'TRVL_MIN', 'TRPMILES'});

% Create speed profile
for i=1:height(subtable)
    t_start=subtable.ENDTIME(i)- subtable.TRVL_MIN(i);
    if t_start<1
        t_start=1;
    end
    t_range= t_start:(subtable.ENDTIME(i) - 1);
    speed(t_range)= subtable.TRPMILES(i)/subtable.TRVL_MIN(i); 
end

end

