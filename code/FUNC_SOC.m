function [ SOC ] = FUN_SOC( table,houseid )
%State of charge is function of location, speed and charging profile
%Get location and speed profile with given houseid using other function
location=FUNC_location(table, houseid);
speed=FUNC_speed(table,houseid);
%Get battery type from data

%Initialize SOC
SOC=100*ones(1,24*60);
%Calculate SOC
for t=2:(24*60)
    switch location(t)
        case 1
            %at home, can be charged
            if SOC(t-1)<100
                %SOC(t)=SOC(t-1)+charging_profile.CHARGE*1;
                %Here I use data of Nissan
                SOC(t)=SOC(t-1)+100/(8*60);
                if SOC(t)>100
                    SOC(t)=100;
                end
            end
        case -1
            %on road, being discharged
            %SOC(t)=SOC(t-1)-charging_profile.DISCHARGE*speed(t);
            SOC(t)=SOC(t-1)-speed(t);
        case 0
            %at other place no charging/discharging
            SOC(t)=SOC(t-1);
    end
end



end

