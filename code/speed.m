function [ speed ] = speed( houseid,data )
%Get speed-t profile for a person with a given houseid
%We define time step dt as 1 min
%Initialization
speed=zeros(1,60*24);
%Selcet data for the given houseid
for i=1:size(data,1)
if data(i,1)==houseid
    %Only the first person in the house is considered
    if data(i,2)==1
        %Simply define the speed as constant throughout a trip
        for t=(round(data(i,4)*60-data(i,6))):1:round(data(i,4)*60)
            speed(t)=data(i,13)/data(i,6);
        end
    end
end
end

end

