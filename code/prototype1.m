%Simulation Parameters
dt = 0.5; %Time Step
speedLimit = 30; %Speed Limit in m/s
L = 2000; %Length of the highway in m
Ttot = 1000; %Total simultaion time

%Model Parameters
v0 = speedLimit; %desired speed in free traffic
s0 = 2; %minimum distance to next car
T = 1.5; %desired time headway to vehicle in front
a = 0.3; %maximum acceleration of a car
b = 3; %comfortable braking deceleration
delta = 4; %exponent used in equation
sStar = @(va,dva) s0 + va*T + va*dva/2/sqrt(a*b); %influence of the following car

%initial condition
x0 = [0;0]; %x(1) Position, x(2) Speed

%allocation
xa = zeros(2,ceil(Ttot/dt));
t = 0:dt:Ttot;

%applying initial conditions
xa(:,1) = x0;
ii = 1; %iteration variable

% while t(ii) < Ttot
%     dva = v0 - xa(2,ii); %for the moment; only one car
%     sa = L - xa(1,ii);
%     f = @(t,x) [x(2);a*(1 - (x(2)/v0)^delta - (sStar(x(2),dva)/sa)^2)];
%     [TOUT,YOUT] = ode45(f,[t(ii) t(ii+1)],xa(:,ii));
%     YOUT=YOUT';
%     Ysize = size(YOUT);
%     xa(:,ii+1) = YOUT(:,Ysize(1));
%     
%     ii = ii + 1;
% end
f = @(t,x) [x(2);a*(1 - (x(2)/v0)^delta - (sStar(x(2),v0-x(2))/(L-x(1)))^2)];
[TOUT,YOUT] = ode45(f,[0 Ttot],x0);
plot(TOUT,YOUT)
%plot(t,xa(1,:),t,xa(2,:));
legend('x','v');