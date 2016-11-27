allData=zeros(8,8);
pool=parpool(12);
for r1=1:1:9
    disp(r1)
    parfor r2=1:1:9
        allData(r1,r2)=main(r1/10,r2/10);
    end
end
save('allData');
delete(pool);