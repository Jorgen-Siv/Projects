g=9.81;
V=20;
A=0.0081*g^2;
B=0.74*(g/V)^4;
omega=logspace(-1,0.2,1000);
e2=tf(2.71, 1);
S=(A./omega.^5).*exp(-B./omega.^4);
S2=frd(S, omega);
bode(S2);
plot(omega,S);
[mag, ~] = bode(S2);
mag = squeeze(mag);
sys_fit = fitfrd(S2, 410);  % much better peak matching

% Convert to complex frequency response (assume phase = 0, just for approximation)
H = mag .* exp(1j * 0);  % crude: assuming real-valued response

[b, a] = invfreqs(H, 1j*omega, 10, 10);  % 5th order numerator/denominator
%sys_fit = tf(b, a);

bode(S2, sys_fit), grid on