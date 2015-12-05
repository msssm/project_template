function [ altSOC3 ] = altPlan3test(SOC, t_leave0, t_home, t_leave, t_charge, car)
% This subfunction finds the SOC when the alternative plan 3 is applied
% This plan charges a vehicle halfway in two randomly determined charging steps


    % Initialize altSOC3_2day; only the first half will be used as the final output
    SOC_2day=[SOC SOC];
    altSOC3_2day = SOC_2day;
    
    % pauseTotal is the sum of all pauses between charging steps [in minutes]
    pauseTotal = t_leave - t_home - t_charge - 60;
    
    % In this alternative plan, there will be three pauses
    R = rand(1,3);
    pause1 = round((R(1)/sum(R))*pauseTotal);
    pause2 = round((R(2)/sum(R))*pauseTotal);
    
    % SOC stays at the same level before the first charging step
    for i = (t_home + 1):(t_home + pause1)
       altSOC3_2day(i) = altSOC3_2day(t_home); 
    end
    
    % t_half is the time when the vehicle gets charged halfway
    t_half = ceil(t_home + pause1+ t_charge/2);
    
    % This for loop represents the first charging step that charges the vehicle halfway
    for i = (t_home + pause1 + 1):t_half
        % SOC increases by (car.ChargeKW/car.CapacityKWh)*(100/60) every minute
        altSOC3_2day(i) = altSOC3_2day(t_home + pause1) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i-(t_home + pause1));
    end
    
    % SOC stays at the same level during the break
    for i = (t_half + 1):(t_half + pause2);
        altSOC3_2day(i) = altSOC3_2day(t_half);
    end
    
    % t_full is the time when the vehicle reaches 100%
    t_full = ceil(t_home + pause1 + pause2 + t_charge);
    
    % This for loop represents the second charging step that charges the vehicle up to 100%
    for i = (t_half + pause2 + 1):t_full
        altSOC3_2day(i) = altSOC3_2day(t_half + pause2) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i - (t_half + pause2));
        
        % Set the upper bound for SOC in case SOC goes above 100
        if altSOC3_2day(i) > 100
            altSOC3_2day(i) = 100;
        end
        
    end
    
    % SOC stays at 100% until the next departure
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
