function [ altSOC2 ] = altPlan2(SOC, t_leave0, t_home, t_leave, t_charge, car)
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