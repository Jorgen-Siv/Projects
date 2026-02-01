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
F_a=1;
k=w0^2/g;
n=5;
x=[x01 x02 x03 x04 x05];
s=100;



%Create system dynamics matrix
%Takes in m: mass of the modules 1 value for all
%km: Mooring stiffness: 1 value for both
%s: stiffnesses in connectors between modules. Either 1 value for all or
%list for each module
%d: Damping for each module. Either 1 value for all or list for each
%modules
%n: Number of nodes
function [A]=createA1DOF(m, km, s, d,n)
    %Check if s and d are lists or singular values
    stiffnesses=ones(n-1);
    damping=ones(n);

    %Throw error if wrong input
    if isa(s, "double")
        stiffnesses=s*stiffnesses;
    elseif isequal(size(s), [1, n-1])
        stiffnesses=s;
    else
        error('Wrong input for stiffness, 1 val or list of size n')
    end
    %Same for damping
    if isa(d, "double")
        damping=d*damping;
    elseif isequal(size(d), [1, n])
        damping=d;
    else
        error('Wrong input for damping, 1 val or list of size n')
    end

    A=zeros([2*n, 2*n]);
    %Setting mooring stiffness and last 2 rows
    %To avoid index error in for loop
    A(2,1)=-km/m;
    A(2*n-1, 2*n)=1;
    A(2*n, 2*n-1)=-km/m;
    A(2*n, 2*n)=-d/m;
    for i=1:n-1
        A(2*i-1, 2*i)=1;
        A(2*i, 2*i-1)=A(2*i, 2*i-1)-stiffnesses(i)/m;
        A(2*i,2*i)=-d/m;
        A(2*i, 2*i+1)=A(2*i, 2*i+1)+stiffnesses(i)/m;
        A(2*i+2,2*i-1)=A(2*i+2,2*i-1)+stiffnesses(i)/m;
        A(2*i+2, 2*i+1)=A(2*i+2, 2*i+1)-stiffnesses(i)/m;
    end
    
end


%Create input matrix
%Takes in m:mass of module
%F_a: Force amplitude, Force coeff*waveamplitude
%k: wavenumber
%x: List of positions of modules
function [B]=createB1DOF(m, F_a, k, x)
    %Find amount of modules
    n=length(x);
    %Empty array in correct size
    B=zeros(n*2, 2);
    for i=1:n
        B(2*i, 1)=cos(k*x(i));
        B(2*i, 2)=-sin(k*x(i));
    end
    B=1/m*F_a*B;
end
%Create output matrix
%Takes in s:connector stiffness singular or list
%n:amount of connectors if s is not a list
function [C]=createC1DOF(s,n)
    stiffnesses=0;
    if nargin<2
        stiffnesses=s;
    else
        stiffnesses=ones(n)*s;
    end
    %Calc n modules
    n=(length(stiffnesses)+1);
    C=zeros([n-1, 2*n]);
    for i=1:length(stiffnesses)
        C(i, 2*i-1)=-stiffnesses(i);
        C(i, 2*i+1)=stiffnesses(i);
    end 
end

A=createA1DOF(m, km, s, d,n);
disp(A)

B=createB1DOF(m, F_a, k, x);
disp(B);
C=createC1DOF(s, 4);
disp(C)
function [A, B, C]=createss(m, km, s, d, k, x01, x02, x03,x04, x05, F_a)
    %Connected A with given mooring stiffness
    A=[0      1  0       0 0       0 0 0 0 0;...
          (-km-s)/m -d/m  s/m      0 0       0 0 0 0 0;... 
           0      0  0       1 0       0 0 0 0 0;... 
           s/m     0 (-s-s)/m  -d/m s/m      0 0 0 0 0;... 
           0      0  0       0 0       1 0 0 0 0 ;... 
           0 0 s/m 0 (-s-s)/m -d/m s/m 0 0 0;...
           0 0 0 0 0 0 0 1 0 0;...
           0 0 0 0 s/m 0 (-s-s)/m -d/m s/m 0;...
           0 0 0 0 0 0 0 0 0 1;...
           0 0 0 0 0 0 s/m 0 (-s-km)/m -d/m];
    %B to implement phase changes
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

    %Looking at the force in the connectors.
    C=[-1*s  0  1*s  0 0    0 0 0 0 0;...
        0     0 -1*s  0 1*s 0 0 0 0 0;...
        0 0 0 0 -s 0 s 0 0 0;...
        0 0 0 0 0 0 -s 0 s 0]; 


    % C=[1 0 0 0 0 0 0 0 0 0;...
    %     0 0 1 0 0 0 0 0 0 0;...
    %     0 0 0 0 1 0 0 0 0 0;...
    %     0 0 0 0 0 0 1 0 0 0;...
    %     0 0 0 0 0 0 0 0 1 0];  %Potential C for states position
end

[A2, B2, C2]=createss(m, km, s, d, k, x01, x02, x03,x04, x05, F_a);
disp(A);
disp(A2);

disp(B);
disp(B2);

disp(C);
disp(C2);