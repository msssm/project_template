function result = idm4(t,x,plebmap)
%idm returns evaluation of intelligent driver model ODE
%Simulation Parameters
L = 2000; %Length of the highway in m
lcar = 0; %Length of the cars in m
%Model Parameters
v0 = 30; %desired speed in free traffic
s0 = 2; %minimum distance to next car
T = 1.5; %desired time headway to vehicle in front
a = 0.3; %maximum acceleration of a car
b = 3; %comfortable braking deceleration
delta = 4; %exponent used in equation
sStar = @(va,dva) s0 + va*T + va*dva/2/sqrt(a*b); %influence of the following car

result = zeros(length(x),1);
Ncars = floor(length(x)/2);
for ii = 1:Ncars
    follow = ii-1;
    if ii > 1 %All but first car
        dva = x(ii+Ncars) - x(follow + Ncars);
        sa = x(follow) - x(ii) - lcar;
 %      if sa < s0
 %          sa = s0;
 %      end
    else %First car
        dva = x(ii+Ncars);
        sa = L - x(ii);
%         if x(ii) > 803.5
%             sa = L - x(ii);
%         elseif x(ii) > 800
%             sa = 2.001;
%         end
    end
    %State Space Equation
    %if startTimes(ii) <= t %&& sa > s0 + 0.001
    if not(plebmap(ii))
        result(ii) = x(ii+Ncars);
        result(ii+Ncars) = a*(1 - (x(ii+Ncars)/v0)^delta - (sStar(x(ii+Ncars),dva)/sa)^2);
        if result(ii)<0
           result(ii) = 0;
        end
    else
        result(ii) = x(ii+Ncars);
        result(ii+Ncars) = a*(1 - (x(ii+Ncars)/15)^delta - (sStar(x(ii+Ncars),dva)/sa)^2);
        if result(ii)<0
            result(ii) = 0;
        end
    end
        
%     else
%         result(ii) = 0;
%         result(ii+Ncars) = 0;
%     end
    
end

end

