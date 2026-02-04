

step1 = 50;
step2 = 1.4;
step3 = 1.2;

%Funket best med 80 hittil - dette
t1 = 80;
t2 = 80;
t3 = 80;

A_f = diag([1/t1 1/t2 1/t3]);

% Funket best med 1 hittil
zeta1 = 1;
zeta2 = 1;
zeta3 = 1;

w1 = 2*pi/t1;
w2 = 2*pi/t2;
w3 = 2*pi/t3;

Omega = diag([2*zeta1*w1, 2*zeta2*w2, 2*zeta3*w3]);

Gamma = diag([w1^2, w2^2, w3^2]);