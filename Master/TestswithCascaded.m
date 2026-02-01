clear all
clc
%2 modules with cascaded virtual filter
%Constants
m=1.2*9088;    %Mass+added mass
w2=2*pi/3;
w1=2*pi/4;
g=9.81;        %Gravity
T0=5;         %Chosen natural period
w0=2*pi/T0;    %Natural frequency
g=9.81;        %Gravity
zeta=0.01;     %Damping coefficient
d_w=m*2*zeta*w0; %Damping

k=((w1+w2)/2)^2/g; %Let it be an average for the frequency range we are looking at
F_a=10000; %Let it be an average for the frequency range we are looking at
function [A, B, C]=createss(m, s, d, k,x, F_a, N,d_w)
    %Connected A with given mooring stiffness

    %m=mass of module
    %s=stiffness
    %d=damping
    %N=number of modules
    A_11=zeros(N,N);
    A_12=eye(N);
    A_21=zeros(N,N);
    A_22=zeros(N,N);
    firstrow=zeros(1,N);
    firstrow(1)=-2;
    firstrow(2)=1;
    firstrow(N)=1;
    %Circulant matrix so can generate like this
    for i=1:N
        A_21(i,:)=s/m*circshift(firstrow, i-1);
        A_22(i,:)=d/m*circshift(firstrow, i-1);
        A_22(i,i)=A_22(i,i)-d_w/m;

    end
    A_21(1,N)=0;
    A_21(N,1)=0;
    A_22(1,N)=0;
    A_22(N,1)=0;
    A=[A_11 A_12;A_21 A_22];


    %Find amount of modules
    n=length(x);
    %Empty array in correct size
    B=zeros(n*2, 2);
    for i=(n+1):2*n
        B(i, 1)=cos(k*x(i-n));
        B(i, 2)=-sin(k*x(i-n));
    end
    %B=[zeros(n,n);eye(n)];
    % for i=1:n
    %     B(i+n, i)=-1+2*i/n;
    % end

    %B=[zeros(n,n);eye(n)];
    B=1/m*F_a*B;

    %Create output matrix
   
    C=zeros([2*(N-1), 2*N]);
    for i=1:(N-1)
        C(i, i)=-s;
        C(i, i+1)=s;
        C(i+(N-1),i+(N))=-d;
        C(i+(N-1),i+(N+1))=d;
    end 
    %C=[C;eye(N)*0 zeros(N,N)];
end

w0 = sqrt(w1*w2);  % Center frequency (rad/s)
B = w2 - w1;       % Bandwidth

% Transfer function: H(s) = (B*s) / (s^2 + B*s + w0^2)
s = tf('s');
H = (B*s) / (s^2 + B*s + w0^2);
N=3;
BR=ones(N,N);%rand(N);
G=eye(2)*H;%tf([1], [1/w1 1])*tf([1/w2 0], [1/w2 1]);
%G3=eye(2)*W;
x=0:13:(N-1)*13;
stiffnesses=2000:1000:60000;
damping=500:1000:20000;
h2cas=zeros(length(stiffnesses), length(damping));
h2cas2=zeros(length(stiffnesses), length(damping));

h2noncas=zeros(length(stiffnesses), length(damping));
intcalc=zeros(length(stiffnesses), length(damping));
[D, S]=meshgrid(damping, stiffnesses);
 
i=1;

for s=stiffnesses
    j=1;
    for d=damping
        [A,B,C]=createss(m, s, d, k, x, F_a,N,d_w);
        % disp(eig(A));
        % A_f=F*A*F';
        % B_f=(F*B)*F';
        % %C_f=C*F';
        sys=ss(A,B,C,0);
        h2noncas(i,j)=norm(sys,2);
        cassys=series(G,sys);
        h2cas(i,j)=norm(cassys,2);

        %cassys2=series(G3, sys);
        %h2cas2(i,j)=norm(cassys2, 2);
        j=j+1;
    end
    i=i+1;
end


figure(1);
surf(D, S, h2cas);
xlabel('Damping [Ns/m]');
ylabel('Stiffness [N/m]');
zlabel('H_2 Norm');
title('Cascaded H_2 Norm vs Damping and Stiffness');
figure(2);
surf(D, S, h2noncas);
xlabel('Damping [Ns/m]');
ylabel('Stiffness [N/m]');
zlabel('H_2 Norm');
title('not cascaded H_2 Norm vs Damping and Stiffness');
% figure;
% surf(D, S, h2cas2);
% xlabel('Damping');
% ylabel('Stiffness');
% zlabel('H_2 Norm');
% title('Wavespectrum H_2 Norm vs Damping and Stiffness');

% %Plots during zoom
% [A,B,C]=createss(m, 40000, 0, k, x, F_a,N);
% sys1=ss(A,B,C,0);
% t=1:0.1:1000;
% u=[sin(w1*t); cos(w1*t)];
% y1=lsim(sys1,u, t);
% [A,B,C]=createss(m, 1000, 0, k, x, F_a,N);
% sys2=ss(A,B,C,0);
% y2=lsim(sys2,u, t);
% figure(1)
% plot(t,y1(:,1:4))
% figure(2)
% plot(t,y2(:,1:4))


