function [SOC_alter] =FUN_SOCalter (SOC,location,car)
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
                %apply alternative plans
                SOC_alter(1,:)=FUNC_altPlan1(SOC,t_leave0,t_home,t_leave1,t_charge);
                SOC_alter(2,:)=FUNC_altPlan2(SOC,t_leave0,t_home,t_leave1,t_charge, car);
                SOC_alter(3,:)=FUNC_altPlan3(SOC,t_leave0,t_home,t_leave1,t_charge, car);
                SOC_alter(4,:)=FUNC_altPlan4(SOC,t_leave0,t_home,t_leave1,t_charge, car);
                SOC_alter(5,:)=FUNC_altPlan5(SOC,t_leave0,t_home,t_leave1,t_charge, car);
            end
        elseif t_leave0+24*60-t_home>=60+t_charge
            %apply alternative plans
            SOC_alter(1,:)=FUNC_altPlan1(SOC,t_leave0,t_home,t_leave0+24*60,t_charge);
            SOC_alter(2,:)=FUNC_altPlan2(SOC,t_leave0,t_home,t_leave0+24*60,t_charge, car);
            SOC_alter(3,:)=FUNC_altPlan3(SOC,t_leave0,t_home,t_leave0+24*60,t_charge, car);
            SOC_alter(4,:)=FUNC_altPlan4(SOC,t_leave0,t_home,t_leave0+24*60,t_charge, car);
            SOC_alter(5,:)=FUNC_altPlan5(SOC,t_leave0,t_home,t_leave0+24*60,t_charge, car);
        end
    else
        t=t+1;
    end
end

end

function [ SOC_a1 ] =FUNC_altPlan1 ( SOC, t_leave0, t_home, t_leave, t_charge)
    %alternative plan 1
    SOC_2day=[SOC SOC];
    SOC_a1_2day=SOC_2day;
    t_ranstart=t_home+round(rand(1,1)*(t_leave-t_home-60));
    for i=t_home:t_ranstart-1
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

function [ altSOC2 ] = FUNC_altPlan2(SOC, t_leave0, t_home, t_leave, t_charge,car)
% This subfunction finds the SOC when the second alternative plan is applied
% This plan charges a vehicle halfway as soon as the car is parked, pauses, and charges up to 100% at the end of the parking hours 


    % Initialize altSOC2; only the elements during charging will be replaced
    SOC_2day=[SOC SOC];
    altSOC2_2day = SOC_2day;
    
    % t_charge_half is the time when the vehicle gets charged halfway
    t_charge_half = round(t_home + t_charge/2);
    
    % This for loop represents the first charging step that charges the vehicle halfway
    for i = (t_home + 1):t_charge_half
        % SOC increases by (car.ChargeKW/car.CapacityKWh)*(100/60) every minute
        altSOC2_2day(i) = altSOC2_2day(t_home) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i-t_home);
    end
    
    % pause is the duration of the break between two charging steps [in minutes]
    pause = round(t_leave - t_home - t_charge - 60);
    
    % SOC stays at the same level during the break
    for i = (t_charge_half + 1):(t_charge_half + pause);
        altSOC2_2day(i) = altSOC2_2day(t_charge_half);
    end
    
    % This for loop represents the second charging step that charges the vehicle up to 100%
    for i = (t_charge_half + pause + 1):(t_leave - 60)
        altSOC2_2day(i) = altSOC2_2day(t_charge_half + pause) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i - (t_charge_half + pause));
        
        % Set the upper bound for SOC in case SOC goes above 100
        if altSOC2_2day(i) > 100
            altSOC2_2day(i) = 100;
        end
        
    end
    
    % SOC stays at 100% for the last 60 minutes
    for i = (t_leave - 59):t_leave
        altSOC2_2day(i) = 100;
    end
    for i=t_leave0:24*60
        altSOC2(i)=altSOC2_2day(i);
    end
    for i=1:t_leave0
        altSOC2(i)=altSOC2_2day(i+24*60);
    end
end

function [ altSOC3 ] = FUNC_altPlan3(SOC, t_leave0, t_home, t_leave, t_charge, car)
% This subfunction finds the SOC when the third alternative plan is applied
% This plan charges a vehicle halfway as soon as the car is parked, takes a break of random length, and charges up to 100% 


    % Initialize altSOC3; only the elements during charging will be replaced
    SOC_2day=[SOC SOC];
    altSOC3_2day = SOC_2day;
    
    % t_charge_half is the time when the vehicle gets charged halfway
    t_charge_half = round(t_home + t_charge/2);
    
    % This for loop represents the first charging step that charges the vehicle halfway
    for i = (t_home + 1):t_charge_half
        % SOC increases by (car.ChargeKW/car.CapacityKWh)*(100/60) every minute
        altSOC3_2day(i) = altSOC3_2day(t_home) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i-t_home);
    end
    
    % pause is the randomly determined duration of the break between two charging steps [in minutes]
    pause = round(rand*(t_leave - t_home - t_charge - 60));
    
    % SOC stays at the same level during the break
    for i = (t_charge_half + 1):(t_charge_half + pause);
        altSOC3_2day(i) = altSOC3_2day(t_charge_half);
    end
    
    % This for loop represents the second charging step that charges the vehicle up to 100%
    for i = (t_charge_half + pause + 1):(t_charge_half + pause + t_charge/2)
        altSOC3_2day(i) = altSOC3_2day(t_charge_half + pause) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i - (t_charge_half + pause));
        
        % Set the upper bound for SOC in case SOC goes above 100
        if altSOC3_2day(i) > 100
            altSOC3_2day(i) = 100;
        end
        
    end
    
    % SOC stays at 100% for the last 60 minutes
    for i = (t_leave - 59):t_leave
        altSOC3_2day(i) = 100;
    end
    for i=t_leave0:24*60
        altSOC3(i)=altSOC3_2day(i);
    end
    for i=1:t_leave0
        altSOC3(i)=altSOC3_2day(i+24*60);
    end
end

function [ altSOC4 ] = FUNC_altPlan4(SOC, t_leave0, t_home, t_leave, t_charge, car)
% This subfunction finds the SOC when the fourth alternative plan is applied
% This plan charges a vehicle in three discrete steps that are evenly spaced


    % Initialize altSOC4; only the elements during charging will be replaced
    SOC_2day=[SOC SOC];
    altSOC4_2day = SOC_2day;
    
    % t_charge_step1 is the time when the first charging step ends
    t_charge_step1 = round(t_home + t_charge/3);
    
    % This for loop represents the first charging step
    for i = (t_home + 1):t_charge_step1
        % SOC increases by (car.ChargeKW/car.CapacityKWh)*(100/60) every minute
        altSOC4_2day(i) = altSOC4_2day(t_home) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i-t_home);
    end
    
    % pause is the duration of the break between two charging steps [in minutes]
    pause = round((t_leave - t_home - t_charge - 60)/2);
    
    % SOC stays at the same level during the first break
    for i = (t_charge_step1 + 1):(t_charge_step1 + pause);
        altSOC4_2day(i) = altSOC4_2day(t_charge_step1);
    end
    
    % t_charge_step2 is the time when the second charging step ends
    t_charge_step2 = round(t_home + t_charge/3 + pause + t_charge/3);
    
    % This for loop represents the second charging step
    for i = (t_charge_step1 + pause + 1):(t_charge_step2)
        altSOC4_2day(i) = altSOC4_2day(t_charge_step1 + pause) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i - (t_charge_step1 + pause));
    end
    
    % SOC stays at the same level during the second break
    for i = (t_charge_step2 + 1):(t_charge_step2 + pause);
        altSOC4_2day(i) = altSOC4_2day(t_charge_step2);
    end
    
    % This for loop represents the third charging step
    for i = (t_charge_step2 + pause + 1):(t_leave - 60)
        altSOC4_2day(i) = altSOC4_2day(t_charge_step2 + pause) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i - (t_charge_step2 + pause));
        
        % Set the upper bound for SOC in case SOC goes above 100
        if altSOC4_2day(i) > 100
            altSOC4_2day(i) = 100;
        end
        
    end
    
    % SOC stays at 100% for the last 60 minutes
    for i = (t_leave - 59):t_leave
        altSOC4_2day(i) = 100;
    end
    for i=t_leave0:24*60
        altSOC4(i)=altSOC4_2day(i);
    end
    for i=1:t_leave0
        altSOC4(i)=altSOC4_2day(i+24*60);
    end
end

function [ altSOC5 ] = FUNC_altPlan5(SOC,t_leave0, t_home, t_leave, t_charge, car)
% This subfunction finds the SOC when the fourth alternative plan is applied
% This plan charges a vehicle in three discrete steps; breaks among the charging steps are randomly determined 

    % Initialize altSOC5; only the elements during charging will be replaced
    SOC_2day=[SOC SOC];
    altSOC5_2day = SOC_2day;
    
    % t_charge_step1 is the time when the first charging step ends
    t_charge_step1 = round(t_home + t_charge/3);
    
    % This for loop represents the first charging step
    for i = (t_home + 1):t_charge_step1
        % SOC increases by (car.ChargeKW/car.CapacityKWh)*(100/60) every minute
        altSOC5_2day(i) = altSOC5_2day(t_home) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i-t_home);
    end
    
    % pause1 is the randomly determined duration of the first break between the first two charging steps [in minutes]
    pause1 = round(rand*(t_leave - t_home - t_charge - 60));
    
    % SOC stays at the same level during the first break
    for i = (t_charge_step1 + 1):(t_charge_step1 + pause1);
        altSOC5_2day(i) = altSOC5_2day(t_charge_step1);
    end
    
    % t_charge_step2 is the time when the second charging step ends
    t_charge_step2 = round(t_home + t_charge/3 + pause1 + t_charge/3);
    
    % This for loop represents the second charging step
    for i = (t_charge_step1 + pause1 + 1):(t_charge_step2)
        altSOC5_2day(i) = altSOC5_2day(t_charge_step1 + pause1) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i - (t_charge_step1 + pause1));
    end
    
    % pause 2 is the duration of the second break [in minutes]
    pause2 = round(rand*(t_leave - t_home - t_charge - pause1 - 60));
    
    % SOC stays at the same level during the second break
    for i = (t_charge_step2 + 1):(t_charge_step2 + pause2);
        altSOC5_2day(i) = altSOC5_2day(t_charge_step2);
    end
    
    % t_charge_step3 is the time when the third charging step ends
    t_charge_step3 = round(t_home + t_charge + pause1 + pause2);
    
    % This for loop represents the third charging step
    for i = (t_charge_step2 + pause2 + 1):(t_charge_step3)
        altSOC5_2day(i) = altSOC5_2day(t_charge_step2 + pause2) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i - (t_charge_step2 + pause2));
        
        % Set the upper bound for SOC in case SOC goes above 100
        if altSOC5_2day(i) > 100
            altSOC5_2day(i) = 100;
        end
        
    end
    
    % SOC stays at 100% for the remaining time
    for i = (t_charge_step3 + 1):t_leave
        altSOC5_2day(i) = 100;
    end
    for i=t_leave0:24*60
        altSOC5(i)=altSOC5_2day(i);
    end
    for i=1:t_leave0
        altSOC5(i)=altSOC5_2day(i+24*60);
    end
    
end
