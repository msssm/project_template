function result = idm4(t,x,plebmap,iq,dis)
disturbance = dis;
%IDM function used in prototype4.m

%Simulation Parameters
L = 100000; %Length of the highway in m
lcar = 0; %Length of the cars in m
%Model Parameters
%desired speed in free traffic
s0 = 0.5; %minimum distance to next car
T = 1; %desired time headway to vehicle in front
a = 0.3; %maximum acceleration of a car
b = 3; %comfortable braking deceleration
delta = 4; %exponent used in equation
sStar = @(va,dva,dva1) s0 + va*T + va*dva/2/sqrt(a*b); %influence of the following car
sStar2 = @(va,dva,dva1) s0 + va*2*T + va*dva/2/sqrt(a*b); %influence of the following car


result = zeros(length(x),1);
Ncars = floor(length(x)/2);

for ii = 1:Ncars
    %  if x(ii) > 4000 && x(ii) < 4500
    %       v0 = 10;
    %   else
    v0=30;
    %    end
    follow = ii-1;
    if ii > 1 %All but first car
        dva = (x(ii+Ncars) - x(follow + Ncars));
        if ii-iq > 0
            dva1 = x(ii+Ncars)*(x(ii) - x(ii-iq))/v0;
        else
            dva1 = 0;
        end
        sa = x(follow) - x(ii) - lcar;
        %      if sa < s0
        %          sa = s0;
        %      end
    else %First car
        dva = x(ii+Ncars);
        sa = L - x(ii);
        dva1 = 0;
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
        result(ii+Ncars) = a*(1 - (x(ii+Ncars)/v0)^delta - (sStar(x(ii+Ncars),dva,dva1)/sa)^2);
        
    else
        result(ii) = x(ii+Ncars);
        if ii<(iq+5)
            result(ii+Ncars) = min(a*(1 - (x(ii+Ncars)/v0)^delta - (sStar2(x(ii+Ncars),dva,dva1)/sa)^2),a);% - (x(ii+Ncars)-v0)),a);
        else
            result(ii+Ncars) = min(a*(1 - (x(ii+Ncars)/v0)^delta - (sStar2(x(ii+Ncars),dva,dva1)/sa)^2 - (x(ii+Ncars)>x(ii+Ncars-iq))*(x(ii+Ncars)-x(ii+Ncars-iq))),a);
        end
        %result(ii+Ncars) = -10000*(x(ii) - (x(ii+1)+x(ii-1))/2);
        
    end
    if ii == 5 && disturbance
        v02 = @(x) max(30 - (x-15000)*25/200,5);
        if x(ii) > 15000 && x(ii) < 15500
            
            result(ii+Ncars) = a*(1 - (x(ii+Ncars)/v02(x(ii)))^delta - (sStar(x(ii+Ncars),dva,dva1)/sa)^2);
        end
        
    end
    if result(ii)<0
        result(ii) = 0;
    end
    %     else
    %         result(ii) = 0;
    %         result(ii+Ncars) = 0;
    %     end
    
end

end

