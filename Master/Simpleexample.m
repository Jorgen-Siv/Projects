clear all;
A=[0 1; -2 -3]; %System dynamics
B1=[1;1]; %How the disturbance affect the states
B2=[0;1]; %How controller effort affect states
C1=[1 1]; %Which state to optimize around
C2=[1 0;0 1]; %Full state-feedback
D11=0; %Feedthrough term of disturbance on regulated output
D12=0.1; % Control efforts effect on regulated output
D21=0; %Feedthrough term of disturbance on sensed output
D22=0; % Control efforts effect on sensed output
 
%Ellipse constraints
umax=10; %Max controller effort -umax<=u<=umax
x1max=0.5;  %-x1max<=x1<x1max
x2max=1; %-x2max<=x2<x2max
yalmip('clear')
beta=sdpvar(1); %gamma squared eq. squared value for the H2 norm, our optimization objective
X=sdpvar(2,2); %Positive semi-definite matrix
Z=sdpvar(1,2);
%K=inv(X)*Z
W=sdpvar(1);%Essentially equal to [C_1X+D_{12}Z]X^{-1}[C_1X+D_{12}Z]^T)

Constraints=[X>=0.001, trace(W)<=beta];
Constraints=[Constraints, [A,B2]*[X;Z]+[X, Z']*[A';B2']+B1*B1'<=0, ...
    [X, (C1*X+D12*Z)';(C1*X+D12*Z), W]>=0.1];
T_i=1;%Selection matrix to collect the right row of the controller
          %Here its not really needed, since we only have one row in the
          %controller


inputConstraint=[umax^2 T_i*Z;Z'*T_i' X]; 
F1=[1 0]; %Selection vector to get the right state for the state constraint, this is x1
F2=[0 1]; %Same just x2
x1constraint=[x1max^2 F1*X; X*F1' X]; 
x2constraint=[x1max^2 F1*X; X*F1' X];
Constraints=[Constraints];%, inputConstraint>=0, x1constraint>=0, x2constraint>=0]; %Create all constraints

Objective=beta; %Choose what we want to minimize
%solver=sdpsettings('verbose',1,'solver','SeDuMi'); %Decide solver
sol = optimize(Constraints, Objective); %Solve the optimization problem

%Check if solved without problems
if sol.problem == 0
 % Extract and display value
 K=value(Z)*inv(value(X));
 disp('Controller: ')
 disp(value(K))
 disp(sqrt(value(beta)))
else
 disp('Hmm, something went wrong!');
 sol.info
 yalmiperror(sol.problem)
end
%%
%Compare with other K
K2=[-10 -10];
BK=B2*K2;
sys1=ss(A+BK,B2, C1, 0);
disp(norm(sys1,2))
