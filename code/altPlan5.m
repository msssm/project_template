function [ altSOC5 ] = altPlan5(SOC, t_leave0, t_home, t_leave, t_charge, car)
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