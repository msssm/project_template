%Runs the simulation with a certain guide car frequency, randomly
%distributed.
function [res1,res2] = simulate(freq,disMatrix)
%@param freq The chance of a car being a guide car
%@param dis 1:With disturbance 0:Without disturbance
%PRE: 0<=freq<=1

%Simulation Parameters
Ttot = 10000; %Total simultaion time
Ncars = 1013;

x0 = zeros(2*Ncars,1);
%startTimes = zeros(Ncars,1);

for ii = 1:Ncars
   x0(ii) = 8*(Ncars-ii); %Starting Position [m]
   x0(ii+Ncars) = 29;% + rand(1)*19; %Starting Velocity [m/s]

 %  startTimes(ii) = 1.7*ii; %Start Time
end

guideMap = (rand(Ncars,1) < freq); %randomly introduce guide cars


% if dis %The car that causes the disturbance cannot be a guide car
%     fprintf('!! Car 5 is now not a guide car; it causes the disturbance !!')
%     guideMap(5) = 0;
% end

    %disMatrix = generateDis(pDis,Ncars);
    f = @(t,x) idm_final(t,x,guideMap,disMatrix); %map which of the cars are guide cars

%find(guideMap)
[TOUT,YOUT] = ode45(f,[0 Ttot],x0);
%subplot(1,2,1);
[ycol, yrow] = size(YOUT);

%In this section we extract critical values for measuring the car
%throughput
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
     if YOUT(ii,1013) > 1.6e5 && taken(3,3) == 0
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
ColorMap = [guideMap zeros(Ncars,1) ~guideMap]; %color guide cars red, normal cars blue

set(gca, 'ColorOrder', ColorMap, 'NextPlot', 'replacechildren');
plot(TOUT,YOUT(:,1:Ncars));
title('position')
end