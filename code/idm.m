function result = idm(t,x)
%idm returns evaluation of intelligent driver model ODE
%Simulation Parameters
dt = 0.5; %Time Step
speedLimit = 30; %Speed Limit in m/s
L = 2000; %Length of the highway in m
lcar = 1;
Ttot = 1000; %Total simultaion time
Ncars = 20;
%Model Parameters
v0 = speedLimit; %desired speed in free traffic
s0 = 2; %minimum distance to next car
T = 1.5; %desired time headway to vehicle in front
a = 0.3; %maximum acceleration of a car
b = 3; %comfortable braking deceleration
delta = 4; %exponent used in equation
sStar = @(va,dva) s0 + va*T + va*dva/2/sqrt(a*b); %influence of the following car

result = zeros(length(x),1);
Ncars = floor(length(x)/2);
for ii = 1:Ncars
    if ii < Ncars
        dva = x(ii+Ncars) - x(ii+Ncars+1);
        sa = x(ii+1) - x(ii) - lcar;
    else
        dva = x(ii+Ncars);
        sa = L - x(ii);
    end
    result(ii) = x(ii+Ncars);
    result(ii+Ncars) = a*(1 - (x(ii+Ncars)/v0)^delta - (sStar(x(ii+Ncars),dva)/sa)^2);
end

end

