result = zeros(20,2);
result2 = zeros(20,2);
for dis = [0 1]
    
   for iq = 2:2:20
       [a, b] = prototype4(iq,dis);
       result(iq,dis+1) = a;
       result2(iq,dis+1) = b;
   end
end

plot(2*(1:10),result(2:2:21,2)-result(2:2:21,1),2*(1:10),result2(2:2:21,2)-result2(2:2:21,1))