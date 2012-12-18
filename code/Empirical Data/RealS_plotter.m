S=zeros(51,1);
for i=1:51
    S(i)=max(a(:,i));
    T(i)=std(a(:,i));
end
plot(S);
hold on;
plot(T,'o');