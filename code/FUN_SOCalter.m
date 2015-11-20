function [SOC_alter] =FUN_SOCalter (SOC,location)
t=1;
SOC_alter=zeros(5,24*60);
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
        if t_start==1;
            t_leave0=t;
        end
        %start timing till the car is back home
        while location(t)~=1 && t<24*60
            t=t+1;
        end
        %get the time when the car is home
        t_home=t;
        %calculate the duration needed for full charging
        t_charge=round((1-SOC(t_home)/100)*car.CapacityKWh/car.ChargeKW*60);
        %start timing till the car leave again
        while location(t)==1 && t<24*60
            t=t+1;
        end
        if t~=24*60
            t_leave1=t;
            if t_leave1-t_home>=60+t_charge
                %apply alternative plan
                SOC_alter(1,:)=FUNC_alter1(SOC,t_leave0,t_home,t_leave1);
            end
        elseif t_leave0+24*60-t_home>=60+t_charge
            %apply alternative plan
            SOC_alter(1,:)=FUNC_alter1(SOC,t_leave0,t_home,t_leave0+24*60);
        end
    end
end

end

function [ SOC_a1 ] =FUNC_alter1 ( SOC, t_leave0, t_home, t_leave)
    %alternative plan 1
    SOC_2day=[SOC SOC];
    SOC_a1_2day=SOC_2day;
    t_charge=round((1-SOC(t_home)/100)*car.CapacityKWh/car.ChargeKW*60);
    t_ranstart=t_home+round(rand(1,1)*(t_leave-t_home-60));
    for i=i=t_home:t_ranstart-1
        %before start time SOC stay the same as the car is just home
        SOC_a1_2day(i)=SOC_2day(t_home);
    end
    for i=t_ranstart:t_ranstart+t_charge
        %from start time start charing
        SOC_a1_2day(i)=SOC_2day(t_home+i-t_ranstart);
    end
    for i=t_leave0:24*60
        SOC_a1(i)=SOC_a1_2day(i);
    end
    for i=1:t_leave0
        SOC_a1(i)=SOC_a1_2day(i+24*60);
    end
end


