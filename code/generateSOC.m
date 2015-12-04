% This script generates a sample SOC profile for alternative plan testing
t_leave0 = 300;
t_home = 600;
t_leave = 1200;
car = model(2,:);

% Initialize SOC
SOC = zeros(1,1440);

for i = 1:300
   SOC(i) = 100; 
end

for i = 301:600
   SOC(i) = (-70/300)*i + 170; 
end

t_charge = ceil((1-30/100)*85/9.6*60);

for i = 601:(600 + t_charge)
   % SOC increases by (car.ChargeKW/car.CapacityKWh)*(100/60) every minute
   SOC(i) = SOC(600) + (9.6/85)*(100/60)*(i-600);
   
       % Set the upper bound for SOC in case SOC goes above 100
       if SOC(i) > 100
           SOC(i) = 100;
       end
   
end

for i = (600 + t_charge + 1):1440
    SOC(i) = 100;
end