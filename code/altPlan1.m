function [ altSOC1 ] = altPlan1(SOC, t_leave0, t_home, t_leave, t_charge, car)
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