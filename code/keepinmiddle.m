%Simulation Parameters
dt = 0.5; %Time Step
L = 2000; %Length of the highway in m
Ttot = 500; %Total simultaion time
Ncars = 103;

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
%startTimes = zeros(Ncars,1);
plebmap = zeros(Ncars,1);
for ii = 1:Ncars
   x0(ii) = 8*(Ncars-ii); %Starting Position [m]
   x0(ii+Ncars) = 10 + rand(1)*19; %Starting Velocity [m/s]
   plebmap(ii) = mod(ii,1) == 0;
 %  startTimes(ii) = 1.7*ii; %Start Time
end
plebmap(1) = 0;
plebmap(Ncars) = 0;

f = @(t,x) idm4(t,x,plebmap);


[TOUT,YOUT] = ode15s(f,[0 Ttot],x0);
subplot(1,2,1);
plot(TOUT,YOUT(:,1:Ncars));
title('position')
subplot(1,2,2);
plot(TOUT,YOUT(:,Ncars+1:2*Ncars));
title('velocity')
%plot(t,xa(1,:),t,xa(2,:));
%legend('x','v');