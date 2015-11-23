function [ altSOC5 ] = altPlan5(SOC, t_home, t_leave, t_charge)
% This subfunction finds the SOC when the fourth alternative plan is applied
% This plan charges a vehicle in three discrete steps; breaks among the charging steps are randomly determined 

    % Initialize altSOC5; only the elements during charging will be replaced
    altSOC5 = SOC;
    
    % t_charge_step1 is the time when the first charging step ends
    t_charge_step1 = round(t_home + t_charge/3);
    
    % This for loop represents the first charging step
    for i = (t_home + 1):t_charge_step1
        % SOC increases by (chargeKW/capacityKWh)*(100/60) every minute
        altSOC5(i) = altSOC5(t_home) + (chargeKW/capacityKWh)*(100/60)*(i-t_home);
    end
    
    % pause1 is the randomly determined duration of the first break between the first two charging steps [in minutes]
    pause1 = round(rand*(t_leave - t_home - t_charge - 60));
    
    % SOC stays at the same level during the first break
    for i = (t_charge_step1 + 1):(t_charge_step1 + pause1);
        altSOC5(i) = altSOC5(t_charge_step1);
    end
    
    % t_charge_step2 is the time when the second charging step ends
    t_charge_step2 = round(t_home + t_charge/3 + pause1 + t_charge/3);
    
    % This for loop represents the second charging step
    for i = (t_charge_step1 + pause1 + 1):(t_charge_step2)
        altSOC5(i) = altSOC5(t_charge_step1 + pause1) + (chargeKW/capacityKWh)*(100/60)*(i - (t_charge_step1 + pause1));
    end
    
    % pause 2 is the duration of the second break [in minutes]
    pause2 = round(rand*(t_leave - t_home - t_charge - pause1 - 60));
    
    % SOC stays at the same level during the second break
    for i = (t_charge_step2 + 1):(t_charge_step2 + pause2);
        altSOC5(i) = altSOC5(t_charge_step2);
    end
    
    % t_charge_step3 is the time when the third charging step ends
    t_charge_step3 = round(t_home + t_charge + pause1 + pause2);
    
    % This for loop represents the third charging step
    for i = (t_charge_step2 + pause2 + 1):(t_charge_step3)
        altSOC5(i) = altSOC5(t_charge_step2 + pause2) + (chargeKW/capacityKWh)*(100/60)*(i - (t_charge_step2 + pause2));
        
        % Set the upper bound for SOC in case SOC goes above 100
        if altSOC5(i) > 100
            altSOC5(i) = 100;
        end
        
    end
    
    % SOC stays at 100% for the remaining time
    for i = (t_charge_step3 + 1):t_leave
        altSOC5(i) = 100;
    end
    
end