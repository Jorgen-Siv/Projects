clc
clear all
m=1.2*9088;  
function [M,K]=makeMK(m,s,n)
    M=eye(n)*m;
    firstrow=zeros(1,n);
    firstrow(1)=2;
    firstrow(2)=-1;
    firstrow(n)=-1;
    K=zeros(n,n);
    for i=1:n
        K(i,:)=s*circshift(firstrow, i-1);
    end
    K(1,n)=0;
    K(n,1)=0;
end
function [T0]=EigPeriod(M,K)
    [V, lambda]=eig(K,M);
    %disp(diag(lambda));
    w0=sqrt(diag(lambda));
    disp(V);
    T0=2*pi./w0;
end
[M,K]=makeMK(m,100000,3);
T0=EigPeriod(M,K);
disp(T0);

% stiff=500:500:600000;
% eigenperiod=zeros(1,length(stiff));
% for i=1:length(eigenperiod)
%     [M,K]=makeMK(m,stiff(i),3);
%     T0=EigPeriod(M,K);
%     eigenperiod(i)=T0(1);
% end

% plot(stiff, eigenperiod)
% ylabel('Eigenperiod for smallest eigenvalue [s]');
% xlabel('Stiffness [N/m]');
% title('Eigenperiod given stiffness')



