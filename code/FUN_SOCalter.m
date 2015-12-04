function [SOC_alter] =FUN_SOCalter (SOC,location,car,pattern)
t=1;
SOC_alter=zeros(7,24*60);
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
        t_charge=ceil((1-SOC(t_home)/100)*car.CapacityKWh/car.ChargeKW*60);
        %start timing till the car leave again
        while location(t)==1 && t<24*60
            t=t+1;
        end
        if t~=24*60
            t_leave1=t;
            if t_leave1-t_home>=60+t_charge
                %apply alternative plans
                for j = 1:length(pattern)
                    switch pattern(j)
                        case 0
                            SOC_alter(j,:)=SOC;
                        case 1
                            SOC_alter(j,:)=FUNC_altPlan1(SOC,t_leave0,t_home,t_leave1,t_charge, car);
                        case 2
                            SOC_alter(j,:)=FUNC_altPlan2(SOC,t_leave0,t_home,t_leave1,t_charge, car);
                        case 3
                            SOC_alter(j,:)=FUNC_altPlan3(SOC,t_leave0,t_home,t_leave1,t_charge, car);
                        case 4
                            SOC_alter(j,:)=FUNC_altPlan4(SOC,t_leave0,t_home,t_leave1,t_charge, car);
                        case 5
                            SOC_alter(j,:)=FUNC_altPlan5(SOC,t_leave0,t_home,t_leave1,t_charge, car);
                        case 6
                            SOC_alter(j,:)=FUNC_altPlan6(SOC,t_leave0,t_home,t_leave1,t_charge, car);
                        case 7
                            SOC_alter(j,:)=FUNC_altPlan7(SOC,t_leave0,t_home,t_leave1,t_charge, car);
                    end
                end
            end
        elseif t_leave0+24*60-t_home>=60+t_charge
            %apply alternative plans
            for j = 1:length(pattern)
                    switch pattern(j)
                        case 0
                            SOC_alter(j,:)=SOC;
                        case 1
                            SOC_alter(j,:)=FUNC_altPlan1(SOC,t_leave0,t_home,t_leave0+24*60,t_charge, car);
                        case 2
                            SOC_alter(j,:)=FUNC_altPlan2(SOC,t_leave0,t_home,t_leave0+24*60,t_charge, car);
                        case 3
                            SOC_alter(j,:)=FUNC_altPlan3(SOC,t_leave0,t_home,t_leave0+24*60,t_charge, car);
                        case 4
                            SOC_alter(j,:)=FUNC_altPlan4(SOC,t_leave0,t_home,t_leave0+24*60,t_charge, car);
                        case 5
                            SOC_alter(j,:)=FUNC_altPlan5(SOC,t_leave0,t_home,t_leave0+24*60,t_charge, car);
                        case 6
                            SOC_alter(j,:)=FUNC_altPlan6(SOC,t_leave0,t_home,t_leave0+24*60,t_charge, car);
                        case 7
                            SOC_alter(j,:)=FUNC_altPlan7(SOC,t_leave0,t_home,t_leave0+24*60,t_charge, car);
                    end
            end
        end
    else
        t=t+1;
    end
end

end

function [ altSOC1 ] = FUNC_altPlan1(SOC, t_leave0, t_home, t_leave, t_charge, car)
% This subfunction finds the SOC when the first alternative plan is applied
% This plan charges a vehicle fully in one randomly determined charging step

    % Initialize altSOC2_2day; only the first half of the vector will be used at the end
    SOC_2day=[SOC SOC];
    altSOC1_2day = SOC_2day;
    
    % pause is the duration of the break before the first charging step [in minutes]
    pause = round(rand*(t_leave - t_home - t_charge - 60));
    
    % For the first "pause" minutes, SOC remains at the initial level
    for i = (t_home + 1):(t_home + pause)
       altSOC1_2day(i) = altSOC1_2day(t_home);
    end
    
    % t_full is the time when the vehicle charges fully
    t_full = ceil(t_home + pause + t_charge);
    
    % In this loop, the vehicle is charged fully
    for i = (t_home + pause + 1):t_full
        % SOC increases by (car.ChargeKW/car.CapacityKWh)*(100/60) every minute
        altSOC1_2day(i) = altSOC1_2day(t_home + pause) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i-(t_home + pause));
        
        % Set the upper bound for SOC in case SOC goes above 100
        if altSOC1_2day(i) > 100
            altSOC1_2day(i) = 100;
        end
        
    end
    
    % SOC stays at 100% until t_leave
    for i = (t_full + 1):t_leave
        altSOC1_2day(i) = 100;
    end
    
    % Initialize altSOC1, which will be the final output
    altSOC1 = zeros(1,24*60);
    
    % Find altSOC1 from altSOC1_2day
    for i=t_leave0:24*60
        altSOC1(i)=altSOC1_2day(i);
    end
    
    for i=1:t_leave0
        altSOC1(i)=altSOC1_2day(i+24*60);
    end

end

function [ altSOC2 ] = FUNC_altPlan2(SOC, t_leave0, t_home, t_leave, t_charge, car)
% This subfunction finds the SOC when the second alternative plan is applied
% This plan charges a vehicle halfway in two evenly distributed charging steps 


    % Initialize altSOC2_2day; only the first half of the vector will be used at the end
    SOC_2day=[SOC SOC];
    altSOC2_2day = SOC_2day;
    
    % t_half is the time when the vehicle gets charged halfway
    t_half = ceil(t_home + t_charge/2);
    
    % This for loop represents the first charging step that charges the vehicle halfway
    for i = (t_home + 1):t_half
        % SOC increases by (car.ChargeKW/car.CapacityKWh)*(100/60) every minute
        altSOC2_2day(i) = altSOC2_2day(t_home) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i-t_home);
    end
    
    % pause is the duration of the break between two charging steps [in minutes]
    pause = round(t_leave - t_home - t_charge - 60);
    
    % SOC stays at the same level during the break
    for i = (t_half + 1):(t_half + pause);
        altSOC2_2day(i) = altSOC2_2day(t_half);
    end
    
    % This for loop represents the second charging step that charges the vehicle up to 100%
    for i = (t_half + pause + 1):(t_leave - 60)
        altSOC2_2day(i) = altSOC2_2day(t_half + pause) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i - (t_half + pause));
        
        % Set the upper bound for SOC in case SOC goes above 100
        if altSOC2_2day(i) > 100
            altSOC2_2day(i) = 100;
        end
        
    end
    
    % SOC stays at 100% for the last 60 minutes
    for i = (t_leave - 59):t_leave
        altSOC2_2day(i) = 100;
    end
    
    % Initialize altSOC2, which will be the final output
    altSOC2 = zeros(1,24*60);
    
    % Find altSOC2 from altSOC2_2day
    for i=t_leave0:24*60
        altSOC2(i)=altSOC2_2day(i);
    end
    
    for i=1:t_leave0
        altSOC2(i)=altSOC2_2day(i+24*60);
    end
    
end

function [ altSOC3 ] = FUNC_altPlan3(SOC, t_leave0, t_home, t_leave, t_charge, car)
% This subfunction finds the SOC when the third alternative plan is applied
% This plan charges a vehicle in two charging steps, the first of which starts as soon as the vehicle arrives home; after a pause of random length, the vehicle is charged fully


    % Initialize altSOC3_2day; only the first half will be used as the final output
    SOC_2day=[SOC SOC];
    altSOC3_2day = SOC_2day;
    
    % t_half is the time when the vehicle gets charged halfway
    t_half = ceil(t_home + t_charge/2);
    
    % This for loop represents the first charging step that charges the vehicle halfway
    for i = (t_home + 1):t_half
        % SOC increases by (car.ChargeKW/car.CapacityKWh)*(100/60) every minute
        altSOC3_2day(i) = altSOC3_2day(t_home) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i-t_home);
    end
    
    % pause is the randomly determined duration of the break between two charging steps [in minutes]
    pause = round(rand*(t_leave - t_home - t_charge - 60));
    
    % SOC stays at the same level during the break
    for i = (t_half + 1):(t_half + pause);
        altSOC3_2day(i) = altSOC3_2day(t_half);
    end
    
    % t_full is the time when the vehicle is fully charged
    t_full = ceil(t_half + pause + t_charge/2);
    
    % This for loop represents the second charging step that charges the vehicle to 100%
    for i = (t_half + pause + 1):t_full
        altSOC3_2day(i) = altSOC3_2day(t_half + pause) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i - (t_half + pause));
        
        % Set the upper bound for SOC in case SOC goes above 100
        if altSOC3_2day(i) > 100
            altSOC3_2day(i) = 100;
        end
        
    end
    
    % SOC stays at 100% for the last 60 minutes
    for i = (t_full + 1):t_leave
        altSOC3_2day(i) = 100;
    end
    
    % Initialize altSOC3, which will be the final output
    altSOC3 = zeros(1,24*60);
    
    % Find altSOC3 from altSOC3_2day
    for i=t_leave0:24*60
        altSOC3(i)=altSOC3_2day(i);
    end
    
    for i=1:t_leave0
        altSOC3(i)=altSOC3_2day(i+24*60);
    end
    
end

function [ altSOC4 ] = FUNC_altPlan4(SOC, t_leave0, t_home, t_leave, t_charge, car)
% This subfunction finds the SOC when the fourth alternative plan is applied
% This plan charges a vehicle halfway in two randomly determined charging steps


    % Initialize altSOC4_2day; only the first half will be used as the final output
    SOC_2day=[SOC SOC];
    altSOC4_2day = SOC_2day;
    
    % pauseTotal is the sum of all pauses between charging steps [in minutes]
    pauseTotal = t_leave - t_home - t_charge - 60;
    
    % In this alternative plan, there will be three pauses
    R = rand(1,3);
    pause1 = round((R(1)/sum(R))*pauseTotal);
    pause2 = round((R(2)/sum(R))*pauseTotal);
    
    % SOC stays at the same level before the first charging step
    for i = (t_home + 1):(t_home + pause1)
       altSOC4_2day(i) = altSOC4_2day(t_home);
    end
    
    % t_half is the time when the vehicle gets charged halfway
    t_half = ceil(t_home + pause1+ t_charge/2);
    
    % This for loop represents the first charging step that charges the vehicle halfway
    for i = (t_home + pause1 + 1):t_half
        % SOC increases by (car.ChargeKW/car.CapacityKWh)*(100/60) every minute
        altSOC4_2day(i) = altSOC4_2day(t_home + pause1) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i-(t_home + pause1));
    end
    
    % SOC stays at the same level during the break
    for i = (t_half + 1):(t_half + pause2);
        altSOC4_2day(i) = altSOC4_2day(t_half);
    end
    
    % t_full is the time when the vehicle reaches 100%
    t_full = ceil(t_home + pause1 + pause2 + t_charge);
    
    % This for loop represents the second charging step that charges the vehicle up to 100%
    for i = (t_half + pause2 + 1):t_full
        altSOC4_2day(i) = altSOC4_2day(t_half + pause2) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i - (t_half + pause2));
        
        % Set the upper bound for SOC in case SOC goes above 100
        if altSOC4_2day(i) > 100
            altSOC4_2day(i) = 100;
        end
        
    end
    
    % SOC stays at 100% until the next departure
    for i = (t_full + 1):t_leave
        altSOC4_2day(i) = 100;
    end
    
    % Initialize altSOC4, which will be the final output
    altSOC4 = zeros(1,24*60);
    
    % Find altSOC4 from altSOC4_2day
    for i=t_leave0:24*60
        altSOC4(i)=altSOC4_2day(i);
    end
    
    for i=1:t_leave0
        altSOC4(i)=altSOC4_2day(i+24*60);
    end
    
end

function [ altSOC5 ] = FUNC_altPlan5(SOC, t_leave0, t_home, t_leave, t_charge, car)
% This subfunction finds the SOC when the fifth alternative plan is applied
% This plan charges a vehicle in three discrete steps that are evenly spaced


    % Initialize altSOC5_2day; only the first half will be used as the final output
    SOC_2day=[SOC SOC];
    altSOC5_2day = SOC_2day;
    
    % t_step1 is the time when the first charging step ends
    t_step1 = ceil(t_home + t_charge/3);
    
    % This for loop represents the first charging step
    for i = (t_home + 1):t_step1
        % SOC increases by (car.ChargeKW/car.CapacityKWh)*(100/60) every minute
        altSOC5_2day(i) = altSOC5_2day(t_home) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i-t_home);
    end
    
    % pause is the duration of the break between two charging steps [in minutes]
    pause = round((t_leave - t_home - t_charge - 60)/2);
    
    % SOC stays at the same level during the first break
    for i = (t_step1 + 1):(t_step1 + pause);
        altSOC5_2day(i) = altSOC5_2day(t_step1);
    end
    
    % t_step2 is the time when the second charging step ends
    t_step2 = ceil(t_home + t_charge/3 + pause + t_charge/3);
    
    % This for loop represents the second charging step
    for i = (t_step1 + pause + 1):(t_step2)
        altSOC5_2day(i) = altSOC5_2day(t_step1 + pause) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i - (t_step1 + pause));
    end
    
    % SOC stays at the same level during the second break
    for i = (t_step2 + 1):(t_step2 + pause);
        altSOC5_2day(i) = altSOC5_2day(t_step2);
    end
    
    % This for loop represents the third charging step
    for i = (t_step2 + pause + 1):(t_leave - 60)
        altSOC5_2day(i) = altSOC5_2day(t_step2 + pause) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i - (t_step2 + pause));
        
        % Set the upper bound for SOC in case SOC goes above 100
        if altSOC5_2day(i) > 100
            altSOC5_2day(i) = 100;
        end
        
    end
    
    % SOC stays at 100% for the last 60 minutes
    for i = (t_leave - 59):t_leave
        altSOC5_2day(i) = 100;
    end
    
    % Initialize altSOC5, which will be the final output
    altSOC5 = zeros(1,24*60);
    
    % Find altSOC5 from altSOC4_2day
    for i=t_leave0:24*60
        altSOC5(i)=altSOC5_2day(i);
    end
    
    for i=1:t_leave0
        altSOC5(i)=altSOC5_2day(i+24*60);
    end
    
end

function [ altSOC6 ] = FUNC_altPlan6(SOC,t_leave0, t_home, t_leave, t_charge, car)
% This subfunction finds the SOC when the sixth alternative plan is applied
% This plan charges a vehicle in three discrete steps;the first step starts immediately; breaks among the charging steps are randomly determined 

    % Initialize altSOC6_2day; only the first half will be used as the final output
    SOC_2day=[SOC SOC];
    altSOC6_2day = SOC_2day;
    
    % pauseTotal is the sum of all pauses between charging steps [in minutes]
    pauseTotal = t_leave - t_home - t_charge - 60;
    
    % In this alternative plan, there will be three pauses
    R = rand(1,3);
    pause1 = round((R(1)/sum(R))*pauseTotal);
    pause2 = round((R(2)/sum(R))*pauseTotal);
    
    % t_step1 is the time when the first charging step ends
    t_step1 = ceil(t_home + t_charge/3);
    
    % This for loop represents the first charging step
    for i = (t_home + 1):t_step1
        % SOC increases by (car.ChargeKW/car.CapacityKWh)*(100/60) every minute
        altSOC6_2day(i) = altSOC6_2day(t_home) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i-t_home);
    end
    
    % SOC stays at the same level during the first break
    for i = (t_step1 + 1):(t_step1 + pause1);
        altSOC6_2day(i) = altSOC6_2day(t_step1);
    end
    
    % t_step2 is the time when the second charging step ends
    t_step2 = ceil(t_home + t_charge/3 + pause1 + t_charge/3);
    
    % This for loop represents the second charging step
    for i = (t_step1 + pause1 + 1):(t_step2)
        altSOC6_2day(i) = altSOC6_2day(t_step1 + pause1) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i - (t_step1 + pause1));
    end
    
    % SOC stays at the same level during the second break
    for i = (t_step2 + 1):(t_step2 + pause2);
        altSOC6_2day(i) = altSOC6_2day(t_step2);
    end
    
    % t_step3 is the time when the third charging step ends
    t_step3 = round(t_home + t_charge + pause1 + pause2);
    
    % This for loop represents the third charging step
    for i = (t_step2 + pause2 + 1):(t_step3)
        altSOC6_2day(i) = altSOC6_2day(t_step2 + pause2) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i - (t_step2 + pause2));
        
        % Set the upper bound for SOC in case SOC goes above 100
        if altSOC6_2day(i) > 100
            altSOC6_2day(i) = 100;
        end
        
    end
    
    % SOC stays at 100% for the remaining time
    for i = (t_step3 + 1):t_leave
        altSOC6_2day(i) = 100;
    end
    
    % Initialize altSOC6, which will be the final output
    altSOC6 = zeros(1,24*60);
    
    % Find altSOC6 from altSOC6_2day
    for i=t_leave0:24*60
        altSOC6(i)=altSOC6_2day(i);
    end
    
    for i=1:t_leave0
        altSOC6(i)=altSOC6_2day(i+24*60);
    end
    
end

function [ altSOC7 ] = FUNC_altPlan7(SOC, t_leave0, t_home, t_leave, t_charge, car)
% This subfunction finds the SOC when the seventh alternative plan is applied
% This plan charges a vehicle halfway in three randomly determined charging steps


    % Initialize altSOC7_2day; only the first half will be used as the final output
    SOC_2day=[SOC SOC];
    altSOC7_2day = SOC_2day;
    
    % pauseTotal is the sum of all pauses between charging steps [in minutes]
    pauseTotal = t_leave - t_home - t_charge - 60;
    
    % In this alternative plan, there will be four pauses
    R = rand(1,4);
    pause1 = round((R(1)/sum(R))*pauseTotal);
    pause2 = round((R(2)/sum(R))*pauseTotal);
    pause3 = round((R(3)/sum(R))*pauseTotal);
    
    % SOC stays at the same level before the first charging step
    for i = (t_home + 1):(t_home + pause1)
       altSOC7_2day(i) = altSOC7_2day(t_home); 
    end
    
    % t_step1 is the time when the first charging step ends
    t_step1 = ceil(t_home + pause1 + t_charge/3);
    
    % This for loop represents the first charging step that charges the vehicle halfway
    for i = (t_home + pause1 + 1):t_step1
        % SOC increases by (car.ChargeKW/car.CapacityKWh)*(100/60) every minute
        altSOC7_2day(i) = altSOC7_2day(t_home + pause1) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i-(t_home + pause1));
    end
    
    % SOC stays at the same level during the break
    for i = (t_step1 + 1):(t_step1 + pause2);
        altSOC7_2day(i) = altSOC7_2day(t_step1);
    end
    
    % t_step2 is the time when the second charging step ends
    t_step2 = ceil(t_home + pause1 + pause2 + (2/3)*t_charge);
    
    % This for loop represents the second charging step
    for i = (t_step1 + pause2 + 1):t_step2
        altSOC7_2day(i) = altSOC7_2day(t_step1 + pause2) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i - (t_step1 + pause2));
            
    end

    % SOC stays at the same level during the third break
    for i = (t_step2 + 1):(t_step2 + pause3);
        altSOC7_2day(i) = altSOC7_2day(t_step2);
    end
    
    % t_step3 is the time when the third charging step ends
    t_step3 = ceil(t_home + t_charge + pause1 + pause2 + pause3);
    
    % This for loop represents the third charging step
    for i = (t_step2 + pause3 + 1):(t_step3)
        altSOC7_2day(i) = altSOC7_2day(t_step2 + pause3) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i - (t_step2 + pause3));
        
        % Set the upper bound for SOC in case SOC goes above 100
        if altSOC7_2day(i) > 100
            altSOC7_2day(i) = 100;
        end
        
    end
    
    % SOC stays at 100% for the remaining time
    for i = (t_step3 + 1):t_leave
        altSOC7_2day(i) = 100;
    end    
    
    % Initialize altSOC7, which will be the final output
    altSOC7 = zeros(1,24*60);
    
    % Find altSOC7 from altSOC7_2day
    for i=t_leave0:24*60
        altSOC7(i)=altSOC7_2day(i);
    end
    
    for i=1:t_leave0
        altSOC7(i)=altSOC7_2day(i+24*60);
    end
    
end
