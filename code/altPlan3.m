function [ altSOC3 ] = altPlan3(SOC, t_leave0, t_home, t_leave, t_charge, car)
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