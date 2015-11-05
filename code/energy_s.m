function [ energy_single ] = energy_s( houseid, location, speed, data )
%Energy consumption is function of location, speed and charging profile
%Get location and speed profile with given houseid using other function
location=location(houseid,data);
speed=speed(houseid,data);
%Get vehtype (data(i,15)) from data

%Calculate energy consumption of single person
%Similar to SOC function but might with different assumption for coefficient

end

