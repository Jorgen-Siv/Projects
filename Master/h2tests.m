clear all
clc
%Constants
m=1.2*9088;    %Mass+added mass 
km=4280;       %Mooring cable '
d=100;          %Damping force, Litt usikker på hva en god verdi vil være for den
x01=0;         %Starting pos of mod1
x02=13;        %Starting pos of mod1
x03=26;        %Starting pos of mod1
x04=39;        %Starting pos of mod1
x05=52;
F_a=1;         %Force amplitude
g=9.81;
w=0.2*pi;
k=w^2/g;
T0=10;
w0=2*pi/T0;
zeta=0.01;
d=m*2*zeta*w0;



%Setting up StateSpace model:
function [A, B, C]=createss(m, km, s, d, k, x01, x02, x03,x04, x05, F_a)
    A=1/m*[0      1  0       0 0       0 0 0 0 0;...
          -km-s -d  s      0 0       0 0 0 0 0;... 
           0      0  0       1 0       0 0 0 0 0;... 
           s     0 -s-s  -d s      0 0 0 0 0;... 
           0      0  0       0 0       1 0 0 0 0 ;... 
           0 0 s 0 -s-s -d s 0 0 0;...
           0 0 0 0 0 0 0 1 0 0;...
           0 0 0 0 s 0 -s-s -d s 0;...
           0 0 0 0 0 0 0 0 0 1;...
           0 0 0 0 0 0 s 0 -s-km -d]; %Connected A

    B=1/m*F_a*[0           0;...
               cos(k*x01) -sin(k*x01);...
               0           0;...
               cos(k*x02) -sin(k*x02);...
               0           0;...
               cos(k*x03) -sin(k*x03);...
               0           0;...
               cos(k*x04) -sin(k*x04);...
               0           0;...
               cos(k*x05) -sin(k*x05);];

    C=[-1*s  0  1*s  0 0    0 0 0 0 0;...
        0     0 -1*s  0 1*s 0 0 0 0 0;...
        0 0 0 0 -s 0 s 0 0 0;...
        0 0 0 0 0 0 -s 0 s 0]; %Looking at the force in the connectors.

    %C=[-1*k2  0  1*k2  0 0    0;...
    %    0     0 -1*k3  0 1*k3 0];

    %C=[-1  0  1  0 0    0;...
    %    0  0 -1  0 1 0];
    % C=[1 0 0 0 0 0 0 0 0 0;...
    %     0 0 1 0 0 0 0 0 0 0;...
    %     0 0 0 0 1 0 0 0 0 0;...
    %     0 0 0 0 0 0 1 0 0 0;...
    %     0 0 0 0 0 0 0 0 1 0];
end
% function [h2_norm1]=CalculateH2Norm(sys1, w)
%     K=1;
%     q=1*w;
%     Q=tf(K, [1 w/q w^2]); %Bandpassfilter around the frequency 
%     weigthedsys_1=series(Q, sys1);
%     h2_norm1=norm(weigthedsys_1, 2);
% 
% end
% w=0.2*pi;
% n=1000;
% stiffnesses=linspace(100, 1000000, n);
% h2values=zeros(n);
% h2valuesbandpass=zeros(n);
% for i=1:length(stiffnesses)
%     [A,B, C]=createss(m, km, stiffnesses(i), d, k, x01, x02, x03,x04, x05, F_a);
%     systemp=ss(A,B,C,0);
%     h2temp=norm(systemp, 2);
%     h2values(i)=h2temp;
%     h2valuesbandpass(i)=CalculateH2Norm(systemp, w);
% end

% figure(1)
% plot(stiffnesses, h2values)
% title('H2 norm white noise')
% xlabel('Stiffness')
% ylabel('H2 norm')
% figure(2)
% plot(stiffnesses, h2valuesbandpass)
% title('H2 norm bandpass')
% xlabel('Stiffness')
% ylabel('H2 norm')
%%
% Wave period:
T_w=linspace(1,15, 15);
stiffnesses=linspace(1000, 100000, 10);
t=linspace(0,31, 62);


%For hver stivhet: Gå gjennom alle bølgelengdene, regn ut 

function [z,h2,hi]=getzvalue(T, s,m, km, d, x01, x02, x03,x04, x05, t,g)
    w=2*pi/T;%Get wavefrequency
    l=g*T^2/(2*pi); %Wavelength
    h=l/60; %Waveheight
    a_w=h/2; %wave amplitude
    k=w^2/g; %Wave number
    %Create State space system
    [A, B, C]=createss(m, km, s, d, k, x01, x02, x03,x04, x05, a_w);
    F=[sin(w*t); cos(w*t)];
    sys1=ss(A, B, C, 0);
    y=lsim(sys1, F, t);
    z1=sqrt(y(:,1).^2)+sqrt(y(:,2).^2)+sqrt(y(:,3).^2)+sqrt(y(:,4).^2);
    z=max(z1)/a_w;
    h2=norm(sys1, 2);
    hi=norm(sys1, inf);
    disp(h2)
end

function [h_inf, rms1, h2max, hinfMatlabmax]=FindH2andHinfperK(T_w,s,m, km, d, x01, x02, x03,x04, x05, t,g)
    temp=zeros(length(T_w),1);
    h2=zeros(length(T_w),1);
    hinfMatlab=zeros(length(T_w),1);
    for i=1:length(T_w)
        [z_i,h2(i),hinfMatlab(i)]=getzvalue(T_w(i), s,m, km, d, x01, x02, x03,x04, x05, t,g);
        temp(i)=z_i;
    end
    disp(2)
    h_inf=max(temp);
    rms1=rms(temp);
    h2max=max(h2);
    hinfMatlabmax=max(hinfMatlab);
end


function [rms1, H_inf, h2Matlab, H_infMatlab]=findValforallK(T_w,stiffnesses,m, km, d, x01, x02, x03,x04, x05, t,g)
    rms1temp=zeros(length(stiffnesses),1);
    H_inftemp=zeros(length(stiffnesses),1);
    h2Matlab=zeros(length(stiffnesses),1);
    H_infMatlab=zeros(length(stiffnesses),1);
    for i=1:length(stiffnesses)
        disp('here')
        disp(FindH2andHinfperK(T_w,stiffnesses(i),m, km, d, x01, x02, x03,x04, x05, t,g))
        [H_inftemp(i),rms1temp(i), h2Matlab(i), H_infMatlab(i)]=FindH2andHinfperK(T_w,stiffnesses(i),m, km, d, x01, x02, x03,x04, x05, t,g);    
        disp('ok')
    end
    disp(1);
    rms1=rms1temp;
    H_inf=H_inftemp;
end
[rms1, H_inf, h2Matlab, HinfMatlab]=findValforallK(T_w,stiffnesses,m, km, d, x01, x02, x03,x04, x05, t,g);
figure(1)
plot(stiffnesses,H_inf);
title('Worstcase scenario, RMS, h2, hinf scores')
xlabel('K [N/m]');
figure(2)
plot(stiffnesses,H_inf);
title('Worstcase scenario, RMS, h2, hinf scores')
xlabel('K [N/m]');
figure(1)
plot(stiffnesses,H_inf);
title('Worstcase scenario, RMS, h2, hinf scores')
xlabel('K [N/m]');
figure(1)
plot(stiffnesses,H_inf);
title('Worstcase scenario, RMS, h2, hinf scores')
xlabel('K [N/m]');
plot(stiffnesses, rms1);

plot(stiffnesses, h2Matlab);
plot(stiffnesses, HinfMatlab);

legend('WSC', 'RMS', 'h2', 'hinf');

