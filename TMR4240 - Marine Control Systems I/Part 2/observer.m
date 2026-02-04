load('supply.mat');
load('supplyABC.mat');
Mtot = vesselABC.MA + vesselABC.MRB; % Mass matrix
M_diag = [Mtot(1,1), 0, 0;
     0, Mtot(2,2), Mtot(2,6);
     0, Mtot(2,6), Mtot(6,6)];

D = diag([vessel.Bv(1,1), vessel.Bv(2,2), vessel.Bv(6,6)]);

M_inv = inv(M_diag);
D_diag = D;

t_p = 9;
% Random tuning parameters / placeholders
omega_1 = 2 * pi / t_p; % har vi bølgespektrum? 7.5
omega_c1 = 1.2*omega_1;
zeta_ni = 1.0; % 7.34 i kompendie
zeta_n = 0.1; % 7.34 i kompendie
t = 1000;

lambda = diag([0.01, 0.01, 0.01]);
omega = diag([omega_1, omega_1, omega_1]);

%Matrix Aw og Cw
Aw=[zeros(3,3), eye(3); -omega*omega, -2*lambda*omega];
Cw= [zeros(3,3), eye(3)];
B_npo = [zeros(6,3); eye(3)];
B_u = diag([1, 1, 1]);


% Bias time constants
Tb = diag([t, t, t]); % Bør være 1000 slik at vi kan se at b_dot går mot 0 eller ikke
Tb_inv = inv(Tb);

% Definerer K'ene til K1,K2,K3,K4 for nonlinear adaptive observer
k1 = - 2 * (zeta_ni - zeta_n) * (omega_c1 / omega_1);
k2 = k1;
k3 = k1;

k4 = 2 * omega_1 * (zeta_ni - zeta_n);
k5 = k4;
k6 = k4;

k7 = omega_c1;
k8 = k7;
k9 = k7;

K1 = [diag([k1, k2, k3]); diag([k4, k5, k6])];
K2 = diag([k7, k8, k9]);

%k12 = Mtot(1, 1);
%k14 = Mtot(2, 2);
%k15 = Mtot(6, 6);
k13 = M_diag(1,1);
k14 = M_diag(2,2);
k15 = M_diag(3,3);
%K4 = diag([k13, k14*1e1, k15*1e-2])*gamma;
K4 = diag([M_diag(1,1), M_diag(1,1), M_diag(1,1)])*1e-1;
K3 = 0.1* K4; % Fra fossen

display(omega_1);
display((K3(1,1))/K4(1,1));
display(K3);
display(K4);
display(M_diag);
display(M_inv);
display(D_diag);
disp("Observer has initilized")


% Mekker bodeplott
H_s = cell(3, 1);
H_0 = cell(3, 1);
for i = 1:3
    o = omega_1;
    o_c = omega_c1;
    z = zeta_n;
    z_n = zeta_ni;
    h0_1 = tf([1, 2*z*o, o*o], [1, 2*z_n*o_c, o_c*o_c]);
    h0_2 = tf(1, [1, o_c]);
    h0 = h0_2*h0_1;
    hb = K4(i,i)*tf([1, K3(i,i)/K4(i,i)], [1, 1/t]);
    h = h0*hb;
    H_0{i} = h0;
    H_s{i} = h;
end
w_test = logspace(-6, 2, 1000);
A_0 = [Aw zeros(6,3); zeros(3,6) zeros(3,3)];
B_0 = [zeros(6,3); eye(3)];
C_0 = [Cw eye(3)];

B = [B_0; zeros(3,3)];
display(B_0);

display(Cw)
% Define Laplace variable s
%s = tf('s');

% Define observer gain matrix K (you should have this from your observer design)
K0 = [K1; K2]; 

% Transfer function H_0(s)
%H_0 = C_0 * inv(s * eye(size(A_0)) + A_0 - K0 * C_0) * B_0;
%H_B = K4 + inv(s*eye(size(Tb_inv)) + Tb_inv)*K3;

%H_s = H_0*H_B;
figure;
hold on;
colors = ['b', 'r', 'g'];  % Definer farger for å differensiere plottene
for i = 1:1
    bode(H_s{i}, w_test, colors(i));
end
legend('H(s)');
grid on;