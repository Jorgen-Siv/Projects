G = [0 tf([3 0],[1 1 10]);tf([1 1],[1 5]),tf(2,[1 6])];

function [G]=createG2(a)
    G = [0 3*a/(a^2+ a+ 10);(a+1)/(a+5),2/(a+6)];
end
singularvalues=zeros(9991,1);
j=1;
disp(size(1:0.1:1000))
for i=1:0.1:1000
    G3=createG2(i);
    sv=svd(G3);

    singularvalues(j)=sv(1);
    j=j+1;
end
sigma(G)
%plot(1:0.1:1000,singularvalues)
