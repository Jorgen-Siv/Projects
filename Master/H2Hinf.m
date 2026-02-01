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
%MAT file from Trine
force_coeff=load('force_coeff_x.mat');



%Setting up StateSpace model: 5module system
function [A, B, C]=createss(m, km, s, d, k, x01, x02, x03,x04, x05, F_a)
    %Connected A with given mooring stiffness
    A=[0        1   0        0   0       0   0       0   0        0;...
     (-km-s)/m -d/m s/m      0   0       0   0       0   0        0;... 
       0        0   0        1   0       0   0       0   0        0;... 
       s/m      0 (-s-s)/m  -d/m s/m     0   0       0   0        0;... 
       0        0   0        0   0       1   0       0   0        0;... 
       0        0   s/m      0 (-s-s)/m -d/m s/m     0   0        0;...
       0        0   0        0   0       0   0       1   0        0;...
       0        0   0        0   s/m     0 (-s-s)/m -d/m s/m      0;...
       0        0   0        0   0       0   0       0   0        1;...
       0        0   0        0   0       0   s/m     0 (-s-km)/m -d/m];
    %B to implement phase changes
    %Assumption here that the change in absolute position of modules are
    %small
    %1/m*F_a
    B=1/m*F_a*[0           0;...
               cos(k*x01) -sin(k*x01);...
               0           0;...
               cos(k*x02) -sin(k*x02);...
               0           0;...
               cos(k*x03) -sin(k*x03);...
               0           0;...
               cos(k*x04) -sin(k*x04);...
               0           0;...
               cos(k*x05) -sin(k*x05)]; 

    %Basic weighting for the z-value
    p=10000;%Relative position
    v=0; %Velocity, Seems too not matter too much for whatever reason over entire freq domain
    s=s;%Here if you want to turn off force
    a=0; %Module positions
    rv=0; %Relative velocity very stable for stiffness above ~3500
    %Looking at the force in the connectors.
    C=[-1*s 0  1*s  0  0   0  0   0 0   0;...
        0   0 -1*s  0  1*s 0  0   0 0   0;...
        0   0  0    0 -1*s 0  1*s 0 0   0;... %Force in connectors
        0   0  0    0  0   0 -1*s 0 1*s 0; ...
       -1*p 0  1*p 0  0   0  0   0 0   0;...
        0   0 -1*p 0  1*p 0  0   0 0   0;... %Relative position
        0   0  0   0 -1*p 0  1*p 0 0   0;...
        0   0  0   0  0   0 -1*p 0 1*p 0;...
        0 1*v 0 0   0 0   0 0   0 0;...
        0 0   0 1*v 0 0   0 0   0 0;...
        0 0   0 0   0 1*v 0 0   0 0;...  %Velocity
        0 0   0 0   0 0   0 1*v 0 0;...
        0 0   0 0   0 0   0 0   0 1*v;...
        1*a 0 0   0 0   0 0   0 0   0;...
        0   0 1*a 0 0   0 0   0 0   0;... %Position
        0   0 0   0 1*a 0 0   0 0   0;...
        0   0 0   0 0   0 1*a 0 0   0;...
        0   0 0   0 0   0 0   0 1*a 0;...
        0 -1*rv 0  1*rv 0  0    0  0    0 0;...
        0  0    0 -1*rv 0  1*rv 0  0    0 0;...  %Relative velocity
        0  0    0  0    0 -1*rv 0  1*rv 0 0;...
        0  0    0  0    0  0    0 -1*rv 0 1*rv];

end

% Wave periods to look at:
T_w=1:0.25:9; %linspace(1,9, 30); %One slight problem here is that the file
                                  % with force amplitude values are missing 
                                  % some data, but is avaailable from
                                  % periods 1-10s with 0.25 jumps 
                         
%Stiffnesses to look at
stiffnesses=linspace(1000, 6000,30);
%Time for response simulation
t=linspace(0,1000, 10000);

%Function to get the specific values given stiffness K and a wave period T
function [z,h2,hi,rao,hisys2,fpeak]=getzvalue(T, s,m, km, d, x01, x02, x03,x04, x05, t,g,force_coeff)
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
    [A, B, C]=createss(m, km, s, d, k, x01, x02, x03,x04, x05, a_w*force_coeff.force_coeff_x(i,2));

    F=[sin(w*t); cos(w*t)]; %WaveForce structure bc of how B is structured
    sys1=ss(A, B, C, 0); %Create sys
    y=lsim(sys1, F, t); %Simulate
    y2=y(5000:end, 1:4)./s;
    %Get absolute force in all connectors and sum
    z1=sqrt(y(5000:end,1).^2)+sqrt(y(5000:end,2).^2)+sqrt(y(5000:end,3).^2)+sqrt(y(5000:end,4).^2);
    %Find max over timeframe
    z=max(z1)/a_w;
    %Get the H2 and Hinf MATLAB values. 
    %Different waves affect system dynamics but could probably move to 
    % Function named FindH2andHinfperK to lessen computation needed
    h2=norm(sys1, 2);
    rao=max(y2)./a_w; %RAO 
    hi=norm(sys1, inf);
    [hi, fpeak]=hinfnorm(sys1);
    

    %Messing around with trying to limit which frequencies the hinf norm 
    %considers.
    % T=linspace(9, 1, 100);
    % ws=linspace(w-0.1*w, w+0.1*w, 20);
    % sv=sigma(sys1, ws);
    % %figure(1)
    % %sigma(sys1, ws);
    % hi=max(sv(:));
    %H-infinity norm of module positions, can be removed but if you wanna
    %compare different weightings at the same time the C above can be added
    %with different weights
    H_tf=tf(sys1);
    C2=[-1 0 1 0 0 0 0 0 0 0;...
        0 0 -1 0 1 0 0 0 0 0;...
        0 0 0 0 -1 0 1 0 0 0;...
        0 0 0 0 0 0 -1 0 1 0];
    
    sys2=ss(A, B, C2, 0);
    hisys2=norm(sys2,inf);

    
end
%Function to find highest values over the given waveperiods for a K
function [h_inf, rms1, h2max, hinfMatlabmax,wsc,rao, hinfposmax, fpeak]=FindH2andHinfperK(T_w,s,m, km, d, x01, x02, x03,x04, x05, t,g,force_coeff)
    %Empty arrays to fill values from for loop
    temp=zeros(length(T_w),1); %Holds the z-value for different periods
    h2=zeros(length(T_w),1);
    hinfMatlab=zeros(length(T_w),1);
    rao=zeros(length(T_w),4);
    hinfpos=zeros(length(T_w),1);
    fpeak=zeros(length(T_w),1);
    for i=1:length(T_w)
        %Get values over wave period spectrum
        [temp(i),h2(i),hinfMatlab(i),rao(i,:), hinfpos(i),fpeak(i)]=getzvalue(T_w(i), s,m, km, d, x01, x02, x03,x04, x05, t,g,force_coeff);
       
    end
    %Calculate the worst case scenario and rms score(rms since it is close
    %to calc for H2 norm
    rms1=rms(temp);
    %Max values to find "worst case"
    h_inf=max(temp);
    h2max=max(h2);
    hinfMatlabmax=max(hinfMatlab);
    wsc=temp; %Used for plots of one specific K over the waveperiod spectrum
              %Example plot of this further down
    hinfposmax=max(hinfpos);
end

%Function that takes in a span of stiffnesses and waveperiods to find the
%norm values given K
function [rms1, H_inf, h2Matlab, H_infMatlab, H_infpos,fpeak]=findValforallK(T_w,stiffnesses,m, km, d, x01, x02, x03,x04, x05, t,g,force_coeff)
    %Just a for loop of previous func to make code more readable and being
    %able to easily access different wave periods as well.

    %Empty arrays to hold values for each stiffness
    rms1temp=zeros(length(stiffnesses),1);
    H_inftemp=zeros(length(stiffnesses),1);
    h2Matlab=zeros(length(stiffnesses),1);
    H_infMatlab=zeros(length(stiffnesses),1);
    H_infpos=zeros(length(stiffnesses),1);
    fpeak=zeros(length(stiffnesses),length(T_w));
    for i=1:length(stiffnesses)
        [H_inftemp(i),rms1temp(i), h2Matlab(i), H_infMatlab(i),wsc, rao, H_infpos(i), fpeak(i,:)]=FindH2andHinfperK(T_w,stiffnesses(i),m, km, d, x01, x02, x03,x04, x05, t,g,force_coeff);    
    end
    rms1=rms1temp;
    H_inf=H_inftemp;
end
[rms1, H_inf, h2Matlab, HinfMatlab, Hinfpos,fpeak]=findValforallK(T_w,stiffnesses,m, km, d, x01, x02, x03,x04, x05, t,g,force_coeff);
%Basic plots to visualize the values

%Plot over manually calculated Hinf
figure(1)
plot(stiffnesses,H_inf);
title('Worstcase scenario')
xlabel('K [N/m]');

%Plot over manually calculated rms
figure(2)
plot(stiffnesses,rms1);
title('RMS')
xlabel('K [N/m]');

%Plot over MATLAB calculated H2
figure(3)
plot(stiffnesses,h2Matlab);
title('H2 MATLAB')
xlabel('K [N/m]');

%Plot over MATLAB calculated Hinf
figure(4)
plot(stiffnesses,HinfMatlab);
title('Hinf MATLAB')
xlabel('K [N/m]');

%Plot over MATLAB calculated Hinf for relative position instead of Force

figure(5)
plot(stiffnesses,Hinfpos);
title('Hinf Position MATLAB')
xlabel('K [N/m]');

disp(fpeak);


% %Example plots of one stiffness over different waveperiods. Just manually
% %calculated "worst case scenario" for each period. 

% [H_inftemp,rms1temp, h2Matlab, H_infMatlab, wsc]=FindH2andHinfperK(T_w,30 ,m, km, d, x01, x02, x03,x04, x05, t,g);    
% figure(5)
% plot(T_w, wsc);
% title('WSC based on wave period')
% xlabel('T [s]');
% 
% [H_inftemp,rms1temp, h2Matlab, H_infMatlab, wsc]=FindH2andHinfperK(T_w,800000 ,m, km, d, x01, x02, x03,x04, x05, t,g);    
% figure(6)
% plot(T_w, wsc);
% title('WSC based on wave period')
% xlabel('T [s]');
%i=2;
% for s=stiffnesses
%     [H_inftemp,rms1temp, h2Matlab, H_infMatlab, wsc,rao]=FindH2andHinfperK(T_w,s ,m, km, d, x01, x02, x03,x04, x05, t,g,force_coeff);
%     figure(i)
%     disp(s)
%     titletext=['WSC based on wave period for K=' num2str(stiffnesses(i-1))];
%     plot(T_w, wsc);
%     title(titletext);
%     xlabel('T [s]');
%     i=i+1;
% end
% 
% %RAO example relative position for each spring divided by wave amplitude

% [H_inftemp,rms1temp, h2Matlab, H_infMatlab, wsc,rao]=FindH2andHinfperK(T_w,14000 ,m, km, d, x01, x02, x03,x04, x05, t,g,force_coeff);
% figure(i)
% plot(T_w,rao(:,1))
% hold on 
% plot(T_w,rao(:,2))
% plot(T_w,rao(:,3))
% plot(T_w,rao(:,4))
% title('RAO for K=14000')
% legend({'Spring 1', 'Spring 2', 'Spring 3', 'Spring 4'});
% hold off
% 
% 
% 



