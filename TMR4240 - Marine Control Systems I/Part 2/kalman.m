%%Definition for Extended Kalman filter
load('supply.mat');
load('supplyABC.mat');
load('observer_response.mat');
M = vesselABC.MA + vesselABC.MRB; % Mass matrix
D = vessel.Bv;
h_ekf = 0.1; %step time
P_0=eye(15);
x_0=zeros(1,15);

%Tuning varables
Ts = 9;
w = (2*pi)/Ts;
zeta = [0.1, 0.1, 0.1];
Kwi = [1, 1, 1];

%Equations
K_w_ekf = diag(Kwi);
lambda_ekf = diag(zeta);
omega_ekf = diag([w, w, w]);

%Matrix
A_w=[zeros(3,3), eye(3); -omega_ekf^2, -2*lambda_ekf*omega_ekf];
C_w= [zeros(3,3), eye(3)];
E_w = [zeros(3,3);eye(3)];

%Tuning varables
T_b_ekf = 1000*diag([1, 1, 1]);
E_b = diag([1, 1, 1]);

%Tuning matrix (noise)
%R_ekf = cov([eta_observer(2,2000:15001)', eta_observer(3,2000:15001)', eta_observer(4,2000:15001)']); 
R_ekf = diag([1, 5, 0.01]);
Q_ekf = diag([0.001, 0.001, 0.001, 1e8, 1e8, 1e9]);
%Q_ekf = diag([0.01, 0.01, 0.01, 2e8, 2e8, 1e9]);
%R_ekf = diag([1, 1, 0.1]);
%Q_ekf = diag([10, 10, 0.01, 5e7, 5e7, 1e9]);

%Use M and D from PID-file
M_3=[Mtot(1,1), 0, 0;
     0, Mtot(2,2), Mtot(2,6);
     0, Mtot(2,6), Mtot(6,6)];
%D_3=D([1,2,6], [1,2,6]);
D_3 = diag([vessel.Bv(1,1), vessel.Bv(2,2), vessel.Bv(6,6)]);
M_inv=inv(M_3);
%B, E and H
B_ekf=[zeros(6,3);zeros(3,3); zeros(3,3);M_inv];
E_ekf=[E_w zeros(6,3);
    zeros(3,3) zeros(3,3);
    zeros(3,3) E_b;
    zeros(3,3) zeros(3,3)];
H_ekf=[C_w eye(3) zeros(3,3) zeros(3,3)];

function Rotation = R(psi)
     Rotation = [cos(psi) -sin(psi) 0;
            sin(psi) cos(psi) 0;
            0   0   1];
end
G=zeros(3,3);

syms x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 real;
xi=[x1;x2;x3;x4;x5;x6];
nu=[x13;x14;x15];
eta=[x7;x8;x9];
bias=[x10;x11;x12];
-M_inv*D_3*nu-M_inv*R(x9)'*G*eta+M_inv*R(x9)'*bias
A_w*xi;
x=[x1; x2; x3; x4; x5; x6; x7; x8; x9; x10; x11; x12; x13; x14; x15];
funcy=[A_w*xi;R(x9)*nu;-inv(T_b_ekf)*bias;
    -M_inv*D_3*nu-M_inv*R(x9)'*G*eta+M_inv*R(x9)'*bias];%-M_inv*D_3*x13-M_inv*R(x9)'*G*x7+M_inv*R(x9)'*x10; -M_inv*D_3*x14-M_inv*R(x9)'*G*x8+M_inv*R(x9)'*x11; -M_inv*D_3*x15-M_inv*R(x9)'*G*x9+M_inv*R(x9)'*x12];
jacobi=jacobian(funcy, x);
disp(jacobi);
