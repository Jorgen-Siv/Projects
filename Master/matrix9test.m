clear all
%Definer konstanter
m=1.2*9088;    %Mass+added mass 
k1=4280;       %Mooring cable left
k4=4280;       %Mooring cable right
d=0.001;       %Damping force, Litt usikker på hva en god verdi vil være for den
d1=d;
d2=d;
d3=d;          %Antar lik demping
x01=0;         %Starting pos of mod1
x02=13;        %Starting pos of mod1
x03=26;        %Starting pos of mod1
F_a=1;         %Force amplitude
g=9.81;        %Gravity
w=0.5;         %Frequency
k=w^2/g;       %Wave number
k_min=1;
k_max=10000000;

alpha=8.1*10^(-3);
beta=0.74;
U195=5;
omega0=g/U195;
S=alpha*g^2/w^5*exp(-beta*(omega0/w)^4);


%Definer A, B1, B2, C1, C2, D11, D12, D21, D22

A=1/m*[0   1   0   0   0   0;...
      -k1 -d1  0   0   0   0;... 
       0   0   0   1   0   0;... 
       0   0   0  -d2  0   0;... 
       0   0   0   0   0   1;... 
       0   0   0   0  -k4 -d3];

B1=F_a*1/m*[0           0;...
        cos(k*x01) -sin(k*x01);...
        0           0;...
        cos(k*x02) -sin(k*x02);...
        0           0;...
        cos(k*x03) -sin(k*x03)];
B2=1/m*[ 0  0;...
         1  0;...
         0  0;...
        -1  1;...
         0  0;...
         0 -1]; %Bruker identitetsmatrise for å forenkle
%Vil ha K på formen:
%K=[K1;
%   K2]
% K=[ 0  0  0     0  0  0;
%    -K2 0  K2    0  0  0;
%     0  0  0     0  0  0;
%     K2 0 -K2-K3 0  K3 0;
%     0  0  K3    0 -K3 0];

C1=[-1 0  1 0 0 0;...
     0 0 -1 0 1 0;...
     zeros(4,6)]; %Minimere basert på kontrolloutput
C2=zeros(2,1); %Full-state feedback
D11=zeros(6,6); %Must i H2;
D12=;%Selection matrise for å hente ut rad 2 og 6 fra K for %å lage vår "z" vi vil minimere (kraft/energi i koblingene 
D21=0;
D22=0;

yalmip('clear')
gamma=sdpvar(1);                 
Z=sdpvar(2,6);
X=sdpvar(6,6);
W=sdpvar(6,6);
Y=sdpvar(6,6);

%P=Z*Y;
Constraints=[X>=0, trace(W)<=gamma];%, X*Y==eye(6)];
% for i=1:6
%     for j=1:6
%         if i==2&&j==1
%             Constraints=[Constraints, P(i,j)==-P(2,3)];
%         elseif i==2&&j==3||i==4&&j==5
%             Constraints=[Constraints, P(i,j)>=k_min, P(i,j)<=k_max];
%         elseif i==4&&j==1
%             Constraints=[Constraints, P(i,j)==P(2,3)];
%         elseif i==4&&j==3
%             Constraints=[Constraints, P(i,j)==-P(2,3)-P(4,5)];
%         elseif i==6&&j==3
%              Constraints=[Constraints, P(i,j)==P(4,5)];
%         elseif i==6&&j==5
%              Constraints=[Constraints, P(i,j)==-P(4,5)];
%         else
%              Constraints=[Constraints, P(i,j)==0];
%         end
%     end
% end

Constraints=[Constraints, [A,B2]*[X;Z]+[X, Z']*[A';B2']+B1*B1'<=0, ...
    [X, (C1*X+D12*Z)';(C1*X+D12*Z), W]>=0.1];


Objective=gamma;
solver=sdpsettings('verbose',1,'solver','SeDuMi');
sol = optimize(Constraints, [], solver);
if sol.problem == 0
 % Extract and display value
 solution =value(Z)*inv(value(X));
 disp(solution)
 disp(value(gamma))
else
 disp('Hmm, something went wrong!');
 sol.info
 yalmiperror(sol.problem)
end


