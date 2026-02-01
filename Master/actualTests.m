clc
clear all;
m=1.2*9088;    %Mass+added mass 
T0=5;         %Chosen natural period
w0=2*pi/T0;    %Natural frequency
g=9.81;        %Gravity
zeta=0.01;     %Damping coefficient
d_w=m*2*zeta*w0; %Damping
%MAT file from Trine
force_coeff=load('force_coeff_x.mat');

t=linspace(0,1000, 10000);
function [A, B, C]=createss(m, s, d,d_w, F_a, N)
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
        A_22(i,i)=A_22(i,i)-d_w;
    end
    A_21(1,N)=0;
    A_21(N,1)=0;
    A_22(1,N)=0;
    A_22(N,1)=0;
    A=[A_11 A_12;A_21 A_22];


    %Empty array in correct size
    B=[zeros(N,N);eye(N)];
    
    B=1/m*F_a*B;

    %Create output matrix
   
    C=zeros([2*(N-1), 2*N]);
    for i=1:(N-1)
        C(i, i)=-s;
        C(i, i+1)=s;
        C(i+(N-1),i+(N-1))=-d;
        C(i+(N-1),i+(N))=d;
    end 
    C=[C;eye(N)*1 zeros(N,N)];
end

function [z]=getzvalue(T, s,m, d,d_w, x, t,g,force_coeff)
    %Find force amplitude from provided MATLAB file. 
    
    [minimum, i]=min(abs(force_coeff.force_coeff_x(:,1)-T));
    w=2*pi/T;%Get wavefrequency
    l=g*T^2/(2*pi); %Wavelength
    h=l/60; %Waveheight
    a_w=h/2; %wave amplitude
    k=w^2/g; %Wave number
    %Create State space system, have been using a set mooring stiffness but
    %to have the same stiffness in mooring springs as the springs between
    %modules then change 2nd input (km) in createss to s. 
    [A, B, C]=createss(m, s, d, d_w, a_w*force_coeff.force_coeff_x(i,2),3);

    F=[sin(w*t+k*x(1)); sin(w*t+k*x(2));sin(w*t+k*x(3))]; %WaveForce structure bc of how B is structured
    sys1=ss(A, B, C, 0); %Create sys
    y=lsim(sys1, F, t); %Simulate
    %Get absolute force in all connectors and sum
    z1=sqrt(y(5000:end,1).^2)+sqrt(y(5000:end,2).^2)+sqrt(y(5000:end,3).^2)+sqrt(y(5000:end,4).^2);
    %Find max over timeframe
    z=max(z1)/a_w;
end

x=0:5:10;
%z=getzvalue(5,1000,m, 100, 0,x,t,g,force_coeff);
T_w=1:0.25:9;
S=[160 600000];
D=[0 10000 15000 25000];
z_11=zeros(length(T_w),1);
z_12=zeros(length(T_w),1);
z_13=zeros(length(T_w),1);
z_14=zeros(length(T_w),1);
z_21=zeros(length(T_w),1);
z_22=zeros(length(T_w),1);
z_23=zeros(length(T_w),1);
z_24=zeros(length(T_w),1);
for i=1:length(T_w)
    z_11(i)=getzvalue(T_w(i),S(1),m, D(1), d_w,x,t,g,force_coeff);
    z_12(i)=getzvalue(T_w(i),S(1),m, D(2), d_w,x,t,g,force_coeff);
    z_13(i)=getzvalue(T_w(i),S(1),m, D(3), d_w,x,t,g,force_coeff);
    z_14(i)=getzvalue(T_w(i),S(1),m, D(4), d_w,x,t,g,force_coeff);
    z_21(i)=getzvalue(T_w(i),S(2),m, D(1), d_w,x,t,g,force_coeff);
    z_22(i)=getzvalue(T_w(i),S(2),m, D(2), d_w,x,t,g,force_coeff);
    z_23(i)=getzvalue(T_w(i),S(2),m, D(3), d_w,x,t,g,force_coeff);
    z_24(i)=getzvalue(T_w(i),S(2),m, D(4), d_w,x,t,g,force_coeff);
end

plot(T_w,z_11,"Color",'r', 'LineStyle','-');
hold on
plot(T_w,z_12,"Color",'r', 'LineStyle','- -');
plot(T_w,z_13,"Color",'r', 'LineStyle',":");
plot(T_w,z_14,"Color",'r', 'LineStyle','-.');

plot(T_w,z_21,"Color",'b', 'LineStyle','-');
plot(T_w,z_22,"Color",'b', 'LineStyle','- -');
plot(T_w,z_23,"Color",'b', 'LineStyle',":");
plot(T_w,z_24,"Color",'b', 'LineStyle','-.');

legend('S=16000 D=0', 'S=16000 D=15000', 'S=16000 D=20000', 'S=16000 D=25000','S=600000 D=0', 'S=600000 D=15000', 'S=600000 D=20000', 'S=600000 D=25000')
hold off