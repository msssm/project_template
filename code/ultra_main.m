%% Script for parallel pooling on a cluster (Euler), calls the main function

allData=zeros(90,90); %Matrix to store the wins of player1 depending on the different risk factors
pool=parpool(12); %initiation of parallel pool

%This double-loop plays all the different risk levels against each other.
%r1 represents the risk factor for player1, r2 for player2.
%the risk factors reach from 0.1 to 0.9 in 0.01 steps.
for r1=1:1:90
    disp(r1)
    parfor r2=1:1:90
        allData(r1,r2)=main(r1/100,r2/100);
    end
end

%save needed data to file and close parallel pools
save('allData');
delete(pool);