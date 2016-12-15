%Compare different iqs
% result = zeros(20,2);
% result2 = zeros(20,2);
% for dis = [0 1]
%     
%    for iq = 2:2:20
%        [a, b] = prototype4(iq,dis);
%        result(iq,dis+1) = a;
%        result2(iq,dis+1) = b;
%    end
% end
% 
% plot(2*(1:10),result(2:2:21,2)-result(2:2:21,1),2*(1:10),result2(2:2:21,2)-result2(2:2:21,1))

%Create histogram with randomly distributed guide cars
dis = 1;
freq = 0.00001;
x = zeros(300,1);
for ii = 1:300
    [a, b] = simulate(freq,dis);
    x(ii)=a;
end

[c, d] = prototype4(1/freq,dis);
xcor = c/1000;
line([xcor;xcor], [0.1;0.92],'Color',[1 0 0],'LineWidth',2);
histogram(x,930:2.5:1000)