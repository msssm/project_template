dis5=generateDis(0,105);
dis5(5,:)=[4000 400 5];

freqm=[0,0.01,0.02,0.04,0.05,0.06,0.07,0.08,0.09,0.1,0.15,0.2,0.3,0.5,0.75,1];%0,0.01,0.02,0.04,0.05,0.06,0.07,0.08,0.09,0.1,0.15,0.2,0.3,0.5,0.75,1
result=zeros(length(freqm));
for ii = 1:length(freqm)
    freq=freqm(ii);
    for jj = 1:200
        [a,b]=simulate2(freq,zeros(105,3));
        [c,d]=simulate2(freq,dis5);
        restemp=(d-b);%(c-a);
        if restemp==0
            break;
        end
        result(ii)=result(ii)+restemp;
    end
    result(ii)=result(ii)/200;
end
plot(freqm,result);
refline(0,40.0025)