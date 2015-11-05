% Matlab Code for Alternative Plan Generation: 0 Convert Excel Data into Mat
% MicroGrid Project
% Course: Modeling Social System by using Matlab
% Author: Huiting Zhang
% 2015.11.4

filename='simplified.xlsx';   % should be in the same folder
sheetname=2;  % we use TX state only
[data,head,raw]=xlsread(data_filename,sheet);

convert the endtime(in XX:XX) into a decimal time (X.XX HR)
if data(1,4)>24
data(:,4)=mod(data(:,4),100)+floor(data(:,4)/100)*60;
end

% remember to change the name here!
save data_Texas data
save head_Texas head 
save raw_Texas raw





