function [ altSOC3 ] = altPlan3(SOC, t_home, t_leave, t_charge)
% This subfunction finds the SOC when the third alternative plan is applied
% This plan charges a vehicle halfway as soon as the car is parked, takes a break of random length, and charges up to 100% 


    % Initialize altSOC3; only the elements during charging will be replaced
    altSOC3 = SOC;
    
    % t_charge_half is the time when the vehicle gets charged halfway
    t_charge_half = round(t_home + t_charge/2);
    
    % This for loop represents the first charging step that charges the vehicle halfway
    for i = (t_home + 1):t_charge_half
        % SOC increases by (chargeKW/capacityKWh)*(100/60) every minute
        altSOC3(i) = altSOC3(t_home) + (chargeKW/capacityKWh)*(100/60)*(i-t_home);
    end
    
    % pause is the randomly determined duration of the break between two charging steps [in minutes]
    pause = round(rand*(t_leave - t_home - t_charge - 60));
    
    % SOC stays at the same level during the break
    for i = (t_charge_half + 1):(t_charge_half + pause);
        altSOC3(i) = altSOC3(t_charge_half);
    end
    
    % This for loop represents the second charging step that charges the vehicle up to 100%
    for i = (t_charge_half + pause + 1):(t_charge_half + pause + t_charge/2)
        altSOC3(i) = altSOC3(t_charge_half + pause) + (chargeKW/capacityKWh)*(100/60)*(i - (t_charge_half + pause));
        
        % Set the upper bound for SOC in case SOC goes above 100
        if altSOC3(i) > 100
            altSOC3(i) = 100;
        end
        
    end
    
    % SOC stays at 100% for the last 60 minutes
    for i = (t_leave - 59):t_leave
        altSOC3(i) = 100;
    end
    
end