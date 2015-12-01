function [ SOC ] = FUNC_SOC( table,houseid, car )
%State of charge is function of location, speed and charging profile
%Get location and speed profile with given houseid using other function
location=FUNC_location(table, houseid);
speed=FUNC_speed(table,houseid);

%Get battery statistics from data (input "car" is a one-row table)
fullchagtime=car.CapacityKWh/car.ChargeKW;
SOCperMile_City=100/(car.MiPerKWhCity*car.CapacityKWh); % the percentage of SOC for a mile
SOCperMile_Highway=100/(car.MiPerKWhHighway*car.CapacityKWh);

%Initialize SOC
SOC=100*ones(1,24*60);
%Calculate SOC
if location(end)~=location(1)
    SOC=NaN;
else
for t=2:(24*60)
    switch location(t)
        case 1
            %at home, can be charged
            if SOC(t-1)<100
                %SOC(t)=SOC(t-1)+charging_profile.CHARGE*1;
                %Here I use data of Nissan
                SOC(t)=SOC(t-1)+100/(fullchagtime*60);
                if SOC(t)>100
                    SOC(t)=100;
                end
            end
        case -1
            %on road, being discharged
            %SOC(t)=SOC(t-1)-charging_profile.DISCHARGE*speed(t);
            if speed(t)>60  % highway
            SOC(t)=SOC(t-1)-speed(t)*SOCperMile_Highway;    %��speed(t) is in mile/min
            else            % city
            SOC(t)=SOC(t-1)-speed(t)*SOCperMile_City;
            end
               
        case 0
            %at other place no charging/discharging
            SOC(t)=SOC(t-1);
    end
end

%find the SOC with negative element
%if so output a zeros array(can be detected easily)
if any(SOC<0)
SOC=NaN;
% match the end and the beginning
elseif SOC(end)<100
SOC(1)=SOC(end);
    % run the new profile again based on the new starting point
    for t=2:(24*60)
        switch location(t)
            case 1
                %at home, can be charged
                if SOC(t-1)<100
                %SOC(t)=SOC(t-1)+charging_profile.CHARGE*1;
                %Here I use data of Nissan
                    SOC(t)=SOC(t-1)+100/(fullchagtime*60);
                    if SOC(t)>100
                        SOC(t)=100;
                    end
                end
            case -1
                %on road, being discharged
                %SOC(t)=SOC(t-1)-charging_profile.DISCHARGE*speed(t);
                if speed(t)>60  % highway
                SOC(t)=SOC(t-1)-speed(t)*SOCperMile_Highway;    %��speed(t) is in mile/min
                else            % city
                SOC(t)=SOC(t-1)-speed(t)*SOCperMile_City;
                end
               
            case 0
            %at other place no charging/discharging
            SOC(t)=SOC(t-1);
        end
    end
  % check if the new profile is stable(start=end || non negative), if not, return NaN
  if (SOC(1)~=SOC(end)) || any(SOC<0)
  SOC=NaN;
  end

end 
end
end
    


