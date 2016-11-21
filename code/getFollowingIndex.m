function idx = getFollowingIndex(x,ii)
    x = x(1:floor(length(x)/2));
    smallest = x(1);
    idx = ii-1;
    for j = 1:length(x)
        if j ~= ii && x(j) > x(ii) && x(j) < smallest
            idx = j;
        end
    end

end

