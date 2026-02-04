
load('supply.mat');
load('supplyABC.mat');
Mtot = vesselABC.MA + vesselABC.MRB; % Mass matrix
M = [Mtot(1,1), 0, 0;
     0, Mtot(2,2), Mtot(2,6);
     0, Mtot(2,6), Mtot(6,6)];

D = diag([vessel.Bv(1,1), vessel.Bv(2,2), vessel.Bv(6,6)]); % Damping matrix

display(M);

%Ti = [50, 35, 50]; % Initial guess kan være Tn = 100, % zeta = d/(2*m w0)
%Ti = [45, 32, 45];
%Ti = [45, 35, 45];
%Ti = [80, 70, 80]; - Veldig fint i dag med nye s-variabler og reference
%model
Ti = [70, 60, 97]; % Beste hittil
%Ti = [60, 60, 90];
Ti_inv = diag([1/Ti(1), 1/Ti(2), 1/Ti(3)]);
Omega_n = (2*pi*Ti_inv);
Zeta = 0.7 * eye(3);

Kp_t = M * (Omega_n^2); % Proportional gain matrix
Kd_t = 2 * M * Zeta * Omega_n - D;
%Ki_t = 0.1 * Kp_t * Omega_n;
%Ki_t = 2*Ti_inv*Kp_t*Omega_n;
Ki_t = 0.1*Kp_t*Omega_n;

Kp = diag([Kp_t(1,1), Kp_t(2,2), Kp_t(3,3)]);
Kd = diag([Kd_t(1,1), Kd_t(2,2), Kd_t(3,3)]);
Ki = diag([Ki_t(1,1), Ki_t(2,2), Ki_t(3,3)]);

%Kp = diag([6.00e+05,  7.80e+05, 6.00e+08]); 
%Kd = diag([3.37e+06,  4.38e+06, 2.12e+09]);
%Ki = diag([2.12e+04,  2.76e+04, 1.04e+07]);