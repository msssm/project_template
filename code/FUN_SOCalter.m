function [SOC_alter] =FUN_SOCalter (SOC,car,location,num)
t=1;
SOC_alter=zeros(num,24*60);
while t<=24*60
    %momerize the start time of this round
    t_start=t;
    %start timing till the car leave
    while location(t)==1 && t<24*60
        t=t+1;
    end
    %move forward if the time is not the end of the day
    if t~=24*60
        %get the leave time
        if t_start=1;
            t_leave0=t;
        end
        %start timing till the car is back home
        while location(t)~=1 && t<24*60
            t=t+1;
        end
        %get the time when the car is home
        t_home=t;
        %calculate the duration needed for full charging
        t_charge=(1-SOC(t_home)/100)*car.CapacityKWh/car.ChargeKW*60;
        %start timing till the car leave again
        while location(t)==1 && t<24*60
            t=t+1;
        end
        if t~=24*60
            t_leave1=t;
            if t_leave1-t_home>=60+t_charge
                %apply alternative plan
            end
        elseif t_leave0+24*60-t_home>=60+t_charge
            %apply alternative plan
        end
    end
end

