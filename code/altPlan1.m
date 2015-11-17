function [ altSOC1 ] = altPlan1(SOC, t_home, t_leave, t_charge)
% This subfunction finds the SOC when the second alternative plan in applied
% This plan charges a vehicle halfway as soon as the car is parked, pauses, and charges up to 100% at the end of the parking hours 


    % Initialize altSOC1; only the elements during charging will be replaced
    altSOC1 = SOC;
    
    % t_charge_half is the time when the vehicle gets charged halfway
    t_charge_half = round(t_home + t_charge/2);
    
    % This for loop represents the first charging step that charges the vehicle halfway
    for i = (t_home + 1):t_charge_half
        % SOC increases by (chargeKW/capacityKWh)*(100/60) every minute
        altSOC1(i) = altSOC1(t_home) + (chargeKW/capacityKWh)*(100/60)*(i-t_home);
    end
    
    % pause is the duration of the break between two charging steps [in minutes]
    pause = round(t_leave - t_home - t_charge - 60);
    
    % SOC stays at the same level during the break
    for i = (t_charge_half + 1):(t_charge_half + pause);
        altSOC1(i) = altSOC1(t_charge_half);
    end
    
    % This for loop represents the second charging step that charges the vehicle up to 100%
    for i = (t_charge_half + pause + 1):(t_leave - 60)
        altSOC1(i) = altSOC1(t_charge_half + t_pause) + (chargeKW/capacityKWh)*(100/60)*(i - (t_charge_half + pause));
        
        % Set the upper bound for SOC in case SOC goes above 100
        if altSOC1(i) > 100
            altSOC1(i) = 100;
        end
        
    end
    
    % SOC stays at 100% for the last 60 minutes
    for i = (t_leave - 59):t_leave
        altSOC1(i) = 100;
    end
    
end