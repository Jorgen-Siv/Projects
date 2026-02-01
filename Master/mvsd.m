m=100;
mu=0.8;
k=1:150:1000;
d=1:150:1000;
[K, D] = meshgrid(k, d);
N=100;
kappa=30;

% Define the function f(x, y)
Z = m/2*((mu^2.*D)+((1-mu)^2*m*K)./(D.*(2-2*cos(2*pi*kappa/N))));

% Plot using a surface plot
surf(K, D, Z);

% Add labels and title
xlabel('k');
ylabel('d');
zlabel('h2norm');
title('Surface Plot of h2 norm');
