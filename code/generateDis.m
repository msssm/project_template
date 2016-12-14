function disMatrix = generateDis(pDis,Ncars)
%generates a random map for the disturbances to be introduced
disMatrix = zeros(Ncars,3);
for ii = 1:Ncars
    if rand(1) < pDis
       disMatrix(ii,1) = 40000 + rand(1)*80000; %Start of disturbance
       disMatrix(ii,2) = 100 + rand(1)*500; %Length of disturbance
       disMatrix(ii,3) = 5 + rand(1)*15; %Speed to which the disturbed car slows down
    end
end

end

