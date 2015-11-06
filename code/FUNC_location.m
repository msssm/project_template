function [ location ] = FUNC_location( table, houseid )
%Get location-t profile for a person with a given houseid
%We define time step dt as 1 min
%Initialization
location=ones(1,60*24);
%Selcet data for the given houseid
%only select the first person, which means PERSONID=1
rows = table.HOUSEID==houseid & table.PERSONID==1;
subtable= table(rows, {'ENDTIME','AWAYHOME', 'TRVL_MIN', 'WHYTO' });
%1: at home, -1: on road, 0: other location 
for i=1:height(subtable)
    if subtable.AWAYHOME(i)==-1
        for t= subtable.ENDTIME(i)- subtable.TRVL_MIN(i): subtable.ENDTIME(i)-1;
            location(t)=-1;
        end
        for t=t:60*24-1
            if subtable.WHYTO(i)==1
                location(t)=1;
            else
                location(t)=0;
            end
        end
    end
end




end

