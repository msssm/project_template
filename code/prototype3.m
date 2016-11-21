%Simulation Parameters
dt = 0.5; %Time Step
L = 2000; %Length of the highway in m
Ttot = 1000; %Total simultaion time
Ncars = 20;

%Model Parameters
v0 = 30; %desired speed in free traffic
s0 = 2; %minimum distance to next car
T = 1.5; %desired time headway to vehicle in front
a = 0.3; %maximum acceleration of a car
b = 3; %comfortable braking deceleration
delta = 4; %exponent used in equation
sStar = @(va,dva) s0 + va*T + va*dva/2/sqrt(a*b); %influence of the following car

%initial condition and times at which cars are injected into the highway
%x1,x2,x3,...,v1,v2,...
x0 = zeros(2*Ncars,1);
startTimes = zeros(Ncars,1);
for ii = 1:Ncars
   x0(ii) = 0; %Starting Position [m]
   x0(ii+Ncars) = 20; %Starting Velocity [m/s]
   startTimes(ii) = 100*Ncars - 100*(ii-1); %Start Time
end

f = @(t,x) idm(t,x,startTimes,x0);


[TOUT,YOUT] = ode15s(f,[0 Ttot],x0);
subplot(1,2,1);
title('position')
plot(TOUT,YOUT(:,1:20));
subplot(1,2,2);
plot(TOUT,YOUT(:,21:40));
title('velocity')
%plot(t,xa(1,:),t,xa(2,:));
%legend('x','v');