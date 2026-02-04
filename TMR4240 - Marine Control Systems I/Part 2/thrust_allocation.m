load('thrusters_sup');
thrust = [thrusters.thrust];
rate = [thrusters.rate]*h_ekf;
rotationspeed = [thrusters.rotationspeed]*h_ekf;
initangle = [thrusters.initangle];
xpos = [thrusters.xposition];
ypos = [thrusters.yposition];

W = diag([10, 1, 1, 10, 1, 1, 1, 1]);
%W = eye(8);

thrust = [thrust(1), thrust(2), thrust(2), thrust(3), thrust(4), thrust(4), thrust(5), thrust(5)]; 
rate = [rate(1), rate(2), rate(2), rate(3), rate(4),rate(4), rate(5), rate(5)];
rotationspeed=[0 rotationspeed(1) 0 rotationspeed(2) rotationspeed(3)];