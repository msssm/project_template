function [ altSOC6 ] = altPlan6(SOC,t_leave0, t_home, t_leave, t_charge, car)
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