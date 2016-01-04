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

% Calculate SOC
if location(end)~=location(1)
   SOC=NaN;
else
    SOC_2day=[SOC SOC];
    speed_2day=[speed speed];
    location_2day=[location location];
    for t=2:(24*60*2)
        switch location_2day(t)
            case 1
                %at home, can be charged
                if SOC_2day(t-1)<100
                    %SOC(t)=SOC(t-1)+charging_profile.CHARGE*1;
                    %Here I use data of Nissan
                    SOC_2day(t)=SOC_2day(t-1)+100/(fullchagtime*60);
                    if SOC_2day(t)>100
                        SOC_2day(t)=100;
                    end
                end
            case -1
                %on road, being discharged
                %SOC(t)=SOC(t-1)-charging_profile.DISCHARGE*speed(t);
                if speed_2day(t)>60  % highway
                SOC_2day(t)=SOC_2day(t-1)-speed_2day(t)*SOCperMile_Highway;    %??speed(t) is in mile/min
                else            % city
                SOC_2day(t)=SOC_2day(t-1)-speed_2day(t)*SOCperMile_City;
                end

            case 0
                %at other place no charging/discharging
                SOC_2day(t)=SOC_2day(t-1);
        end
    end
    for i=1:1440
        SOC(i)=SOC_2day(i+1440);
    end
    %find the SOC that cannot sustain a cycling way
    if SOC_2day(1440)~=SOC_2day(2880)
    SOC=NaN;
    end
    %find the SOC with negative element
    %if so output a zeros array(can be detected easily)
    if any(SOC<0)
        SOC=NaN;
    end

 
end
end
    


