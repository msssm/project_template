function [ electricity ] = FUNC_electricity(SOC,car)
%derive electricity comsuption from a given SOC
electricity=zeros(1,1440);
for t=2:1440
if SOC(t)-SOC(t-1)>0
    electricity(t)=car.ChargeKW;
end
end

if SOC(1)-SOC(1440)>0
    electricity(1)=car.ChargeKW;
end


end
