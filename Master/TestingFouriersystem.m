%New automated build of A
function [A]=buildA(m,s,d,N)
    %m=mass of module
    %s=stiffness
    %d=damping
    %N=number of modules
    A_11=zeros(N,N);
    A_12=eye(N);
    A_21=eye(N);
    A_22=eye(N);
    
    for i=1:N
        A_21(i,i)=-s/m*(2-2*cos(2*pi*i/N));
        A_22(i,i)=-d/m*(2-2*cos(2*pi*i/N));
    end
    A=[A_11 A_12;A_21 A_22];
end
function [B]=buildB(m,F_a,k,x)
    %Find amount of modules
    n=length(x);
    %Empty array in correct size
    B=zeros(n*2, 2);
    for i=(n+1):2*n
        B(i, 1)=cos(k*x(i-n));
        B(i, 2)=-sin(k*x(i-n));
    end
    B=1/m*F_a*B;
end
%Create output matrix
%Takes in s:connector stiffness singular or list
%n:amount of connectors if s is not a list
function [C]=buildC(s,d,N)

    C=zeros([2*(N-1), 2*N]);
    for i=1:(N-1)
        C(i, i)=-s;
        C(i, i+1)=s;
        C(i+(N-1),i+(N-1))=-d;
        C(i+(N-1),i+(N))=d;
    end 
end



k=15000;
m=9500;
d=2000;
k=0.5;
N=40;
F_a=1000;
%A=[0 1; -k/m*(2-2*cos(2*pi*kappa/N)) -d/m*(2-2*cos(2*pi*kappa/N))];
A=buildA(m,s,d, N);
disp(eig(A))
x=0:13:(N-1)*13;
B=buildB(m, F_a, k, x);
C=buildC(s,d,N);
sys1=ss(A,B,C,0);
disp(norm(sys1,2))
