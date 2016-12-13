%Runs the simulation with a certain guide car frequency, randomly
%distributed.
function [res1,res2] = prototype4(freq,dis)
%@param freq The chance of a car being a guide car
%@param dis 1:With disturbance 0:Without disturbance
%PRE: 0<=freq<=1

%Simulation Parameters
dt = 0.5; %Time Step
L = 100000; %Length of the highway in m
Ttot = 1000; %Total simultaion time
Ncars = 103; %may be prime

%Model Parameters
v0 = 30; %desired speed in free traffic
s0 = 0.5; %minimum distance to next car
T = 1; %desired time headway to vehicle in front
a = 0.3; %maximum acceleration of a car
b = 3; %comfortable braking deceleration
delta = 4; %exponent used in equation
sStar = @(va,dva) s0 + va*T + va*dva/2/sqrt(a*b); %influence of the following car
%iq = 200;
%initial condition and times at which cars are injected into the highway
%x1,x2,x3,...,v1,v2,...
x0 = zeros(2*Ncars,1);
%startTimes = zeros(Ncars,1);
plebmap = zeros(Ncars,1); %map which of the cars are plebejans
for ii = 1:Ncars
   x0(ii) = 8*(Ncars-ii); %Starting Position [m]
   x0(ii+Ncars) = 29;% + rand(1)*19; %Starting Velocity [m/s]

 %  startTimes(ii) = 1.7*ii; %Start Time
end
plebmap(ii) = rand(Ncars) < freq;

f = @(t,x) idm4(t,x,plebmap,iq,dis);


[TOUT,YOUT] = ode45(f,[0 Ttot],x0);
%subplot(1,2,1);
[ycol, yrow] = size(YOUT);
measurement = zeros(3,3); 
taken = zeros(3,3);
for ii = 1:ycol
     if YOUT(ii,1) > 5000 && taken(1,1) == 0
         measurement(1,1) = TOUT(ii);
         taken(1,1) = 1;
     end
     if YOUT(ii,5) > 5000 && taken(2,1) == 0
         measurement(2,1) = TOUT(ii);
         taken(2,1) = 1;
     end
     if YOUT(ii,103) > 5000 && taken(3,1) == 0
         measurement(3,1) = TOUT(ii);
         taken(3,1) = 1;
     end
     if YOUT(ii,1) > 13000 && taken(1,2) == 0
         measurement(1,2) = TOUT(ii);
         taken(1,2) = 1;
     end
     if YOUT(ii,5) > 13000 && taken(2,2) == 0
         measurement(2,2) = TOUT(ii);
         taken(2,2) = 1;
     end
     if YOUT(ii,103) > 13000 && taken(3,2) == 0
         measurement(3,2) = TOUT(ii);
         taken(3,2) = 1;
     end
     if YOUT(ii,1) > 20000 && taken(1,3) == 0
         measurement(1,3) = TOUT(ii);
         taken(1,3) = 1;
     end
     if YOUT(ii,5) > 20000 && taken(2,3) == 0
         measurement(2,3) = TOUT(ii);
         taken(2,3) = 1;
     end
     if YOUT(ii,103) > 20000 && taken(3,3) == 0
         measurement(3,3) = TOUT(ii);
         taken(3,3) = 1;
     end

end
% abstand = [measurement(2,1)-measurement(1,1), ...
%            measurement(3,1)-measurement(2,1);
%            measurement(2,2)-measurement(1,2), ...
%            measurement(3,2)-measurement(2,2);
%            measurement(2,3)-measurement(1,3), ...
%            measurement(3,3)-measurement(2,3)] 

res1 = measurement(3,3);
res2 = measurement(2,3);
plot(TOUT,YOUT(:,1:Ncars));
title('position')
end