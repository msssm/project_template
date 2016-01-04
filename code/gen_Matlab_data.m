% Matlab Code for Alternative Plan Generation: 0 Convert Excel Data into Mat
% MicroGrid Project
% Course: Modeling Social System by using Matlab
% Author: Huiting Zhang
% 2015.11.4

data_filename='texas_only.xlsx';   % should be in the same folder
% be careful that the texas_only.xlsx does not contain "states" column now
table=readtable(data_filename);

%sort the data in a ascending endtime
table=sortrows(table, 'ENDTIME'); % Memo: ENDTIME=-1 means skip, ENDTIME=-9 means unknown

%convert the endtime(in XX:XX) into minute time (XXX mins)
t=table2array(table(:,{'ENDTIME','TRVL_MIN','WHODROVE','WHYFROM','WHYTO','TRPMILES'}));
toDelete = sum(t<0,2)>0;  % mark all the useless rows with a positive number
table(toDelete,:) = [];
table.ENDTIME = mod(table.ENDTIME,100) + floor(table.ENDTIME/100)*60 ;

save TexasTable table 


