function [ location ] = FUNC_location( table, houseid )
%Get location-t profile for a person with a given houseid
%We define time step dt as 1 min
%Initialization
location=ones(1,60*24);
%Get the speed profile
speed=FUNC_speed(table,houseid);
%Selcet data for the given houseid
%only select the first person, which means PERSONID=1
rows = table.HOUSEID==houseid & table.PERSONID==1;
subtable= table(rows, {'ENDTIME','AWAYHOME', 'TRVL_MIN', 'WHYTO' });
%1: at home, -1: on road, 0: other location 
for i=1:height(subtable)
    if subtable.AWAYHOME(i)==-1
        period= subtable.ENDTIME(i)- subtable.TRVL_MIN(i): subtable.ENDTIME(i)-1;
        for t=period(period>0)
            location(t)=-1;
        end
        %Starting from next minute to when a new trip start
        %change the location
        t=t+1;
        while (speed(t)==0) && (t<=(60*24-1))
            if subtable.WHYTO(i)==1
                location(t)=1;
            else
                location(t)=0;
            end
            t=t+1;
        end
        if speed(60*24)==0
            location(60*24)=location(60*24-1);
        else
            location(60*24)=-1;
        end
    end
end




end

