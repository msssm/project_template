function [ distance ] = distance( houseid,data )
%Get distance-t profile for a person with a given houseid
%We define time step dt as 1 min
%Initialization
distance=zeros(1,60*24);
i=1;
%Selcet data for the given houseid
for i=1:size(data,1)
if data(i,1)==houseid
    %Only the first person in the house is considered
    if data(i,2)==1
        %Simply define the speed is constant throughout a trip
        for t=(round(data(i,4)*60-data(i,6))):1:round(data(i,4)*60)
            distance(t)=distance(t-1)+data(i,13)/data(i,6);
        end
        %Distance is accumulated
        %Caution: data shall be arranged with an ascending trend
        while t<(60*24)
            distance(t+1)=distance(t);
            t=t+1;
        end
    end
end
end
end

