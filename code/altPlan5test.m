function [ altSOC5 ] = altPlan5test(SOC, t_leave0, t_home, t_leave, t_charge, car)
% This subfunction finds the SOC when the alternative plan 5 is applied
% This plan charges a vehicle halfway in three randomly determined charging steps


    % Initialize altSOC5_2day; only the first half will be used as the final output
    SOC_2day=[SOC SOC];
    altSOC5_2day = SOC_2day;
    
    % pauseTotal is the sum of all pauses between charging steps [in minutes]
    pauseTotal = t_leave - t_home - t_charge - 60;
    
    % In this alternative plan, there will be four pauses
    R = rand(1,4);
    pause1 = round((R(1)/sum(R))*pauseTotal);
    pause2 = round((R(2)/sum(R))*pauseTotal);
    pause3 = round((R(3)/sum(R))*pauseTotal);
    
    % SOC stays at the same level before the first charging step
    for i = (t_home + 1):(t_home + pause1)
       altSOC5_2day(i) = altSOC5_2day(t_home); 
    end
    
    % t_step1 is the time when the first charging step ends
    t_step1 = ceil(t_home + pause1 + t_charge/3);
    
    % This for loop represents the first charging step that charges the vehicle halfway
    for i = (t_home + pause1 + 1):t_step1
        % SOC increases by (car.ChargeKW/car.CapacityKWh)*(100/60) every minute
        altSOC5_2day(i) = altSOC5_2day(t_home + pause1) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i-(t_home + pause1));
    end
    
    % SOC stays at the same level during the break
    for i = (t_step1 + 1):(t_step1 + pause2);
        altSOC5_2day(i) = altSOC5_2day(t_step1);
    end
    
    % t_step2 is the time when the second charging step ends
    t_step2 = ceil(t_home + pause1 + pause2 + (2/3)*t_charge);
    
    % This for loop represents the second charging step
    for i = (t_step1 + pause2 + 1):t_step2
        altSOC5_2day(i) = altSOC5_2day(t_step1 + pause2) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i - (t_step1 + pause2));
            
    end

    % SOC stays at the same level during the third break
    for i = (t_step2 + 1):(t_step2 + pause3);
        altSOC5_2day(i) = altSOC5_2day(t_step2);
    end
    
    % t_step3 is the time when the third charging step ends
    t_step3 = ceil(t_home + t_charge + pause1 + pause2 + pause3);
    
    % This for loop represents the third charging step
    for i = (t_step2 + pause3 + 1):(t_step3)
        altSOC5_2day(i) = altSOC5_2day(t_step2 + pause3) + (car.ChargeKW/car.CapacityKWh)*(100/60)*(i - (t_step2 + pause3));
        
        % Set the upper bound for SOC in case SOC goes above 100
        if altSOC5_2day(i) > 100
            altSOC5_2day(i) = 100;
        end
        
    end
    
    % SOC stays at 100% for the remaining time
    for i = (t_step3 + 1):t_leave
        altSOC5_2day(i) = 100;
    end    
    
    % Initialize altSOC5, which will be the final output
    altSOC5 = zeros(1,24*60);
    
    % Find altSOC5 from altSOC5_2day
    for i=t_leave0:24*60
        altSOC5(i)=altSOC5_2day(i);
    end
    
    for i=1:t_leave0
        altSOC5(i)=altSOC5_2day(i+24*60);
    end
    
end