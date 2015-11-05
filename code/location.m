function [ location ] = location( houseid,data )
%Get location-t profile for a person with a given houseid
%We define time step dt as 1 min
%Initialization
location=ones(1,60*24);
%Selcet data for the given houseid
for i=1:size(data,1)
if data(i,1)==houseid
    %Only the first person in the house is considered
    if data(i,2)==1
        %1: at home, -1: on road, 0: other location 
        if data(i,3)==-1
            for t=(round(data(i,4)*60-data(i,6))):1:round(data(i,4)*60)
                location(t)=-1;
            end
            for t=(t+1):60*24
                if data(i,10)==1
                    location(t)=1;
                else
                    location(t)=0;
                end
            end
        end
    end
end
end


end

