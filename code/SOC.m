function [ SOC ] = SOC( houseid,location,speed, charging_profile,data )
%State of charge is function of location, speed and charging profile
%Get location and speed profile with given houseid using other function
location=location(houseid,data);
speed=speed(houseid,data);
%Get battery type from data

%Initialize SOC

%Calculate SOC
for t=2:(24*60)
    switch location(t)
        case 1
            %at home, can be charged
            %SOC(t)=function(SOC(t-1),charging rate)
            %charging_rate=function(battery_type)
        case -1
            %on road, being discharged
            %SOC(t)=function(SOC(t-1),discharging_rate)
            %discharging_rate=function(speed(t),battery_type)
        case 0
            %at other place no charging/discharging
    end
end



end

