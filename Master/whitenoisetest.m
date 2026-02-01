clear all
clc


%Constants
m=1.2*9088;    %Mass+added mass 
km=4280;       %Mooring cable '
x01=0;         %Starting pos of mod1
x02=13;        %Starting pos of mod2
x03=26;        %Starting pos of mod3
x04=39;        %Starting pos of mod4
x05=52;        %Starting pos of mod5
T0=10;         %Chosen natural period
w0=2*pi/T0;    %Natural frequency
g=9.81;        %Gravity
zeta=0.01;     %Damping coefficient
d=m*2*zeta*w0; %Damping
force_coeff=load('force_coeff_x.mat');
k=w0^2/g;



%Setting up StateSpace model:
function [A, B, C]=createss(m, km, s, d, k, x01, x02, x03,x04, x05, F_a)
    A=[0      1  0       0 0       0 0 0 0 0;...
          (-km-s)/m -d/m  s/m      0 0       0 0 0 0 0;... 
           0      0  0       1 0       0 0 0 0 0;... 
           s/m     0 (-s-s)/m  -d/m s/m      0 0 0 0 0;... 
           0      0  0       0 0       1 0 0 0 0 ;... 
           0 0 s/m 0 (-s-s)/m -d/m s/m 0 0 0;...
           0 0 0 0 0 0 0 1 0 0;...
           0 0 0 0 s/m 0 (-s-s)/m -d/m s/m 0;...
           0 0 0 0 0 0 0 0 0 1;...
           0 0 0 0 0 0 s/m 0 (-s-km)/m -d/m]; %Connected A

    B=[0           0;...
               cos(k*x01) -sin(k*x01);...
               0           0;...
               cos(k*x02) -sin(k*x02);...
               0           0;...
               cos(k*x03) -sin(k*x03);...
               0           0;...
               cos(k*x04) -sin(k*x04);...
               0           0;...
               cos(k*x05) -sin(k*x05)]; %B to implement phase changes 1/m*F_a

    C=[-1*s  0  1*s  0 0    0 0 0 0 0;...
        0     0 -1*s  0 1*s 0 0 0 0 0;...
        0 0 0 0 -s 0 s 0 0 0;...
        0 0 0 0 0 0 -s 0 s 0]; %Looking at the force in the connectors.


    % C=[1 0 0 0 0 0 0 0 0 0;...
    %     0 0 1 0 0 0 0 0 0 0;...
    %     0 0 0 0 1 0 0 0 0 0;...
    %     0 0 0 0 0 0 1 0 0 0;...
    %     0 0 0 0 0 0 0 0 1 0];  %Potential C for states position
end


%Stiffnesses to look at
stiffnesses=linspace(1000, 100000, 1500);

% Generate White Noise Input
fs = 1000;        % Sampling frequency (Hz)
t = 0:1/fs:1000;     % Time vector (500 seconds)
white_noise = randn(length(t),2);  % Generate Gaussian white noise

hinf=zeros(length(stiffnesses));
sim=zeros(length(stiffnesses));
for i=1:length(stiffnesses)

    % Simulate Response
    [A,B,C]=createss(m, km, stiffnesses(i), d, k, x01, x02, x03,x04, x05, 1);
    sys1=ss(A,B,C,0);
    y = lsim(sys1, white_noise, t);
    z=max(abs(y(:,1))+abs(y(:,2))+abs(y(:,3))+abs(y(:,4)));
    hi=norm(sys1,inf);
    hinf(i)=hi;
    sim(i)=z;
end
figure(1)
plot(stiffnesses, hinf(:,1));
title('H_{inf}')
xlabel('K [N/m]');



figure(2)
plot(stiffnesses, sim(:,1));
title('White noise test')
xlabel('K [N/m]');

