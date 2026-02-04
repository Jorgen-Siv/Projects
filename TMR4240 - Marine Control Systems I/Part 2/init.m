%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% init()                                                                  %
%                                                                         %              
% Set initial parameters for part1.slx and part2.slx                      %
%                                                                         %
% Created:      2018.07.12	Jon Bjørnø                                    %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

load('supply.mat');
load('supplyABC.mat');
load('thrusters_sup.mat')
windCoefficients;
PID;
reference_model;
observer;
kalman;
thrust_allocation;

% Initial position x, y, z, phi, theta, psi
eta0 = [0,0,0,0,0,0]';
% Initial velocity u, v, w, p, q, r
nu0 = [0,0,0,0,0,0]';

% Wind
K = 0.003;
mu = 0.001;
mu_direction = 0.03; % Optimal value for limiting to max 5 degree deviation
U_10 = 10; % m/s
h = 1;
z = 10; % m
w = 0.005;

z0 = 10*exp(-2/(5*sqrt(K)));
U_mean = U_10*(5/2)*sqrt(K)*log(z/z0);
U_angle = 180; %Wind from North