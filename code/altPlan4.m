function [ altSOC4 ] = altPlan4(SOC, t_home, t_leave, t_charge)
% This subfunction finds the SOC when the fourth alternative plan is applied
% This plan charges a vehicle in three discrete steps that are evenly spaced


    % Initialize altSOC4; only the elements during charging will be replaced
    altSOC4 = SOC;
    
    % t_charge_step1 is the time when the first charging step ends
    t_charge_step1 = round(t_home + t_charge/3);
    
    % This for loop represents the first charging step
    for i = (t_home + 1):t_charge_step1
        % SOC increases by (chargeKW/capacityKWh)*(100/60) every minute
        altSOC4(i) = altSOC4(t_home) + (chargeKW/capacityKWh)*(100/60)*(i-t_home);
    end
    
    % pause is the duration of the break between two charging steps [in minutes]
    pause = round((t_leave - t_home - t_charge - 60)/2);
    
    % SOC stays at the same level during the first break
    for i = (t_charge_step1 + 1):(t_charge_step1 + pause);
        altSOC4(i) = altSOC4(t_charge_step1);
    end
    
    % t_charge_step2 is the time when the second charging step ends
    t_charge_step2 = round(t_home + t_charge/3 + pause + t_charge/3);
    
    % This for loop represents the second charging step
    for i = (t_charge_step1 + pause + 1):(t_charge_step2)
        altSOC4(i) = altSOC4(t_charge_step1 + pause) + (chargeKW/capacityKWh)*(100/60)*(i - (t_charge_step1 + pause));
    end
    
    % SOC stays at the same level during the second break
    for i = (t_charge_step2 + 1):(t_charge_step2 + pause);
        altSOC4(i) = altSOC4(t_charge_step2);
    end
    
    % This for loop represents the third charging step
    for i = (t_charge_step2 + pause + 1):(t_leave - 60)
        altSOC4(i) = altSOC4(t_charge_step2 + pause) + (chargeKW/capacityKWh)*(100/60)*(i - (t_charge_step2 + pause));
        
        % Set the upper bound for SOC in case SOC goes above 100
        if altSOC4(i) > 100
            altSOC4(i) = 100;
        end
        
    end
    
    % SOC stays at 100% for the last 60 minutes
    for i = (t_leave - 59):t_leave
        altSOC4(i) = 100;
    end
    
end